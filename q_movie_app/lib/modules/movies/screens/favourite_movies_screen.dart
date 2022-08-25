import 'package:flutter/material.dart';
import 'package:q_movie_app/modules/movies/components/movie_list_header.dart';
import 'package:q_movie_app/modules/movies/models/movie_genres_model.dart';
import 'package:q_movie_app/modules/movies/models/popular_movies_model.dart';
import 'package:q_movie_app/modules/movies/components/movie_list_tile.dart';
import 'package:q_movie_app/constants/style_constants.dart';
import 'package:q_movie_app/modules/services/utilities/sqflite_service.dart';
import 'package:q_movie_app/modules/services/utilities/api_provider.dart';

class FavouriteMoviesScreen extends StatelessWidget {
  static const String id = 'favorite_movies_screen';
  const FavouriteMoviesScreen({Key? key, this.favouriteMoviesScreenKey})
      : super(key: key);
  final GlobalKey<ScaffoldState>? favouriteMoviesScreenKey;

  List getGenres(List<PopularMovies> movies, List<Genres> genres, int index) {
    final Set movieGenreIds = Set.from(movies[index].genreIds!);
    return genres
        .where((g) => movieGenreIds.contains(g.id))
        .map((g) => g.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.3),
      key: favouriteMoviesScreenKey,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            DataBaseProvider.db.getAllFavouriteMovies(),
            ApiProvider().getAllGenres(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MoviesListHeader(listTitle: 'Favourite'),
                    snapshot.data![0].length == 0
                        ? const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'You haven\'t selected any favourite movies',
                              style: kHeadingTextStyle,
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data![0].length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var genreList = getGenres(snapshot.data![0],
                                  snapshot.data![1], index) as List<String?>;
                              return MoviesListTile(
                                title: snapshot.data![0][index].title,
                                voteAverage:
                                    snapshot.data![0][index].voteAverage,
                                description: snapshot.data![0][index].overview,
                                posterPath: snapshot.data![0][index].posterPath,
                                genreIds: snapshot.data![0][index].genreIds,
                                genres: genreList,
                                index: index,
                              );
                            },
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
