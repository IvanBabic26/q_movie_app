import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:q_movie_app/modules/movies/components/movie_list_header.dart';
import 'package:q_movie_app/modules/movies/models/movie_genres_model.dart';
import 'package:q_movie_app/modules/services/utilities/api_provider.dart';
import 'package:q_movie_app/modules/services/utilities/sqflite_service.dart';
import 'package:q_movie_app/modules/movies/models/popular_movies_model.dart';
import 'package:q_movie_app/modules/movies/components/movie_list_tile.dart';

class PopularMoviesScreen extends StatefulWidget {
  static const String id = 'popular_movies_screen';
  const PopularMoviesScreen({Key? key, this.popularMoviesScreenKey})
      : super(key: key);
  final GlobalKey<ScaffoldState>? popularMoviesScreenKey;

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  final ScrollController _scrollController = ScrollController();

  var isLoading = false;
  int page = 1;

  final int _limit = 20;

  /// There is next page or not
  bool _hasNextPage = true;

  /// Used to display loading indicators when _initFetch function is running
  bool _isFirstLoadRunning = false;

  /// Used to display loading indicators when _fetchMore function is running
  bool _isLoadMoreRunning = false;

  /// This holds movies fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _initFetch() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var url =
          "https://api.themoviedb.org/3/movie/popular?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=$page&_limit=$_limit";
      Response response = await Dio().get(url);

      setState(() {
        _posts = response.data['results'];
      });

      _posts.map((movies) {
        DataBaseProvider.db.createPopularMovie(PopularMovies.fromJson(movies));
      }).toList();
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  /// This will be triggered whenever the user scroll to near the bottom of the list view
  void _fetchMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      /// Increase _page by 1
      page += 1;
      try {
        var url =
            "https://api.themoviedb.org/3/movie/popular?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=$page&_limit=$_limit";
        Response response = await Dio().get(url);

        final List fetchedPosts = response.data['results'];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          /// This means there is no more data and therefore, we will not send another GET request

          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    _initFetch();
    _scrollController.addListener(_fetchMore);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_fetchMore);
    super.dispose();
  }

  List getGenres(List<Genres> genres, int index) {
    final Set movieGenreIds = Set.from(_posts[index]!['genre_ids']);
    return genres
        .where((g) => movieGenreIds.contains(g.id))
        .map((g) => g.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.3),
      key: widget.popularMoviesScreenKey,
      body: SafeArea(
        child: FutureBuilder(
          future: ApiProvider().getAllGenres(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _isFirstLoadRunning
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MoviesListHeader(listTitle: 'Popular'),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _posts.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var genreList = getGenres(snapshot.data!, index)
                                  as List<String?>;
                              return MoviesListTile(
                                movieId: _posts[index]['id'],
                                title: _posts[index]['title'],
                                voteAverage: _posts[index]['vote_average'],
                                description: _posts[index]['overview'],
                                posterPath: _posts[index]['poster_path'],
                                genreIds: _posts[index]['genre_ids'],
                                genres: genreList,
                                index: index,
                              );
                            },
                          ),
                          if (_isLoadMoreRunning == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          // When nothing else to load
                          if (_hasNextPage == false)
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 40),
                              color: Colors.amber,
                              child: const Center(
                                child:
                                    Text('You have fetched all of the content'),
                              ),
                            ),
                        ],
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
