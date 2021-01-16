import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io';

import 'movie.dart';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();

  factory MovieDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  MovieDatabase._internal();

  Future<Database> initDB() async {
    print('State initated');
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'main2.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    print('INIT OVER PATH: $path');
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    print('Creation started');
    await db.execute('''CREATE TABLE Movies(id STRING PRIMARY KEY, 
        Title TEXT, Year TEXT,
        Poster TEXT, 
        Type TEXT)''');

    print("Database was Created!");
  }

  Future<int> addMovie(MovieItem movie) async {
    print('MOVIE ${movie.info["Title"]} ADDED TO DB');
    var dbClient = await db;

    try {
      int res = await dbClient.insert("Movies", movie.toDbMap());
      print("Movie added $res");
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> deleteMovie(String id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Movies", where: "id = ?", whereArgs: [id]);
    print("Movie deleted $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<int> updateMovie(MovieItem movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Movies", movie.toDbMap(),
        where: "id = ?", whereArgs: [movie.id]);
    print("Movie updated $res");
    return res;
  }

  Future<List<MovieItem>> retrieveMovies() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('Movies');

    return List.generate(maps.length, (i) {
      return MovieItem(
          id: maps[i]['id'],
          title: maps[i]['Title'],
          type: maps[i]['Type'],
          year: maps[i]['Year']);
    });
  }
}
