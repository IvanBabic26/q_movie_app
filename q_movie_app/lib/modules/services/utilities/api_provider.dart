import 'package:dio/dio.dart';
import 'package:q_movie_app/modules/movies/models/movie_genres_model.dart';

class ApiProvider {
  Future<List<Genres?>> getAllGenres() async {
    var genres = "https://api.themoviedb.org/3/genre/movie/list";
    Response response = await Dio().get(genres,
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGQ3Zjc2OTQ3OTA0YTAxMTI4NmRjNzMyYzU1MjM0ZSIsInN1YiI6IjYwMzM3ODBiMTEzODZjMDAzZjk0ZmM2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XYuIrLxvowrkevwKx-KhOiOGZ2Tn-R8tEksXq842kX4",
          "Content-Type": "application/json"
        }));

    return (response.data['genres'] as List).map((genres) {
      return Genres.fromJson(genres);
    }).toList();
  }
}
