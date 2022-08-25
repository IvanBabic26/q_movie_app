import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:q_movie_app/modules/movies/components/movie_genre_list.dart';
import 'package:q_movie_app/modules/movies/screens/movie_details_screen.dart';
import 'package:q_movie_app/constants/style_constants.dart';
import 'package:q_movie_app/modules/movies/stores/favourite_movies_store.dart';
import 'package:q_movie_app/modules/services/utilities/sqflite_service.dart';
import 'package:q_movie_app/modules/movies/models/favourite_movies_model.dart';

class MoviesListTile extends StatelessWidget {
  const MoviesListTile(
      {Key? key,
      this.movieId,
      this.title,
      this.voteAverage,
      this.description,
      this.posterPath,
      this.genreIds,
      this.genres,
      this.index})
      : super(key: key);
  final int? movieId;
  final String? title;
  final dynamic voteAverage;
  final String? description;
  final String? posterPath;
  final List<dynamic>? genreIds;
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () => {
          Get.to(
              () => MovieDetails(
                    movieId: movieId,
                    title: title,
                    description: description,
                    voteAverage: voteAverage,
                    posterPath: posterPath,
                    genres: genres,
                    index: index,
                  ),
              transition: Transition.zoom,
              duration: const Duration(seconds: 1)),
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500$posterPath'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: SizedBox(
                            width: 179.0,
                            child: Text(
                              title!,
                              style: kHeadingTextStyle,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFF2CF16),
                              size: 13.33,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.33),
                              child: Text('$voteAverage / 10 IMDb',
                                  style: kVoteAverageText),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: MovieGenreList().getTextWidgets(genres!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Provider.of<FavouriteMoviesStore>(context, listen: false)
                    .onTap(index);
                DataBaseProvider.db.createFavouriteMovie(newFavourite);
              },
              child: SizedBox(
                height: 24.0,
                width: 24.0,
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
      ),
    );
  }
}
