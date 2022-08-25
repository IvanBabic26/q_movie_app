import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_movie_app/constants/style_constants.dart';
import 'package:q_movie_app/modules/movies/models/favourite_movies_model.dart';
import 'package:q_movie_app/modules/services/utilities/sqflite_service.dart';
import 'package:q_movie_app/modules/movies/stores/favourite_movies_store.dart';
import 'package:q_movie_app/modules/movies/components/movie_genre_list.dart';

class MovieDetails extends StatelessWidget {
  static const String id = 'movie_details_screen';
  const MovieDetails(
      {Key? key,
      this.movieId,
      this.description,
      this.title,
      this.voteAverage,
      this.posterPath,
      this.genres,
      this.index})
      : super(key: key);
  final int? movieId;
  final String? title;
  final String? description;
  final dynamic voteAverage;
  final String? posterPath;
  final List<String?>? genres;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final toggle =
        Provider.of<FavouriteMoviesStore>(context, listen: true).favourite;
    final newFavourite = FavouriteMovies(
        id: movieId,
        title: title,
        overview: description,
        voteAverage: voteAverage,
        posterPath: posterPath,
        genreIds: genres);

    return Scaffold(
      backgroundColor: kMainColorTheme,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 334.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500$posterPath'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 314,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 498,
                decoration: const BoxDecoration(
                  color: kMainColorTheme,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                    right: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 43.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title!,
                                  style: kMovieDetailsTitle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 16.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFF2CF16),
                                        size: 13.33,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.33),
                                        child: Text('$voteAverage / 10 IMDb',
                                            style: kVoteAverageText),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<FavouriteMoviesStore>(context,
                                      listen: false)
                                  .onTap(index);
                              DataBaseProvider.db
                                  .createFavouriteMovie(newFavourite);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 45.0),
                              child: Icon(
                                toggle.contains(index)
                                    ? Icons.bookmark_added_rounded
                                    : Icons.bookmark_border_outlined,
                                size: 18,
                                color: toggle.contains(index)
                                    ? const Color(0xFFEC9B3E)
                                    : const Color(0xFFE4ECEF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      MovieGenreList().getTextWidgets(genres!),
                      const Padding(
                        padding: EdgeInsets.only(top: 40.0, bottom: 8.0),
                        child: Text(
                          'Description',
                          style: kHeadingTextStyle,
                        ),
                      ),
                      Text(
                        description!,
                        style: kMovieDetailsDescription,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 26,
              child: IconButton(
                icon: const Icon(Icons.keyboard_backspace_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
