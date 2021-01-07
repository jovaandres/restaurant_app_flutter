import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  Future<Database> _initializeDb() async {
    var path = getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tblRestaurant (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating DOUBLE
        )''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<void> insertFavorite(Restaurants restaurant) async {
    final db = await database;
    await db.insert(tblRestaurant, restaurant.toJson());
  }

  Future<List<Restaurants>> getFavorites() async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(tblRestaurant);

    return results
        .map((res) => Restaurants.fromJson(res))
        .toList()
        .reversed
        .toList();
  }

  Future<Map> getFavoritesById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tblRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(
      tblRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
