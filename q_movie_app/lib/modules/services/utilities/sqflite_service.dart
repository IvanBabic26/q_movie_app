import 'dart:io';
import 'package:q_movie_app/modules/movies/models/favourite_movies_model.dart';
import 'package:q_movie_app/modules/movies/models/popular_movies_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  static Database? _database;
  static final DataBaseProvider db = DataBaseProvider._();

  DataBaseProvider._();

  Future<Database?> get database async {
    /// If database exists, return database
    if (_database != null) return _database;

    /// If database don't exists, create one
    _database = await initDB();
    return _database;
  }

  // Create the database and the PopularMovies and FavouriteMovies table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'movies.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE PopularMovies('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'overview TEXT,'
          'vote_average REAL,'
          'poster_path TEXT,'
          'genre_ids BLOB'
          ')');
      await db.execute('CREATE TABLE FavouriteMovies('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'overview TEXT,'
          'vote_average REAL,'
          'poster_path TEXT,'
          'genre_ids BLOB'
          ')');
    });
  }

  // Insert employee on database
  createPopularMovie(PopularMovies newMovie) async {
    final db = await database;
    final res = await db?.insert(
      'PopularMovies',
      newMovie.toJson(),
    );

    return res;
  }

  createFavouriteMovie(FavouriteMovies newMovie) async {
    final db = await database;
    final res = await db?.insert(
      'FavouriteMovies',
      newMovie.toJson(),
    );

    return res;
  }

  /// Delete all popular movies
  Future<int?> deleteAllPopularMovies() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM FavouriteMovies');

    return res;
  }

  Future<List<PopularMovies>> getAllPopularMovies() async {
    final db = await database;
    final res = await db?.query("PopularMovies");

    List<PopularMovies> list = res!.isNotEmpty
        ? res.map((c) => PopularMovies.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<FavouriteMovies>> getAllFavouriteMovies() async {
    final db = await database;
    final res = await db?.query("FavouriteMovies");

    List<FavouriteMovies> list = res!.isNotEmpty
        ? res.map((c) => FavouriteMovies.fromJson(c)).toList()
        : [];

    return list;
  }
}
