import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

//=========================================
// Creating table 'cars' / setting up table
//=========================================
class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      'CREATE TABLE IF NOT EXISTS cars('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'make TEXT,'
      'model TEXT,'
      'year INTEGER,'
      'color TEXT,'
      'mileage INTEGER,'
      'price INTEGER,'
      'description TEXT,'
      'image TEXT'
      ')',
    );
  }

//================================================================
// Checking if table exists, creting it and linking it to 'cars.db
//================================================================
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'cars.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

//=========================================
// Loading data to database, creating a car
//=========================================
  static Future<int> createCar(
      String make,
      String model,
      int year,
      String color,
      int mileage,
      int price,
      String description,
      String image) async {
    final db = await SqlHelper.db();

//===============================================
// Resolve conflicts by overwriting existing data
//===============================================
    final data = {
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'mileage': mileage,
      'price': price,
      'description': description,
      'image': image,
    };
    final id = await db.insert(
        //.insert (POST)
        'cars',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

//=====================================
// Obtaining all cars from the database
//=====================================
  static Future<List<Map<String, dynamic>>> getCars() async {
    final db = await SqlHelper.db();
    return db.query('cars', orderBy: "id DESC"); //.query (GET)
  }

//==================================
// Obtaining a car from the database
//==================================
  static Future<List<Map<String, dynamic>>> getCar(int id) async {
    final db = await SqlHelper.db();
    return db.query('cars', where: 'id = ?', whereArgs: [id], limit: 1);
  }

//===========
// PUT Method
//===========
  static Future<int> updateCar(
      int id,
      String make,
      String model,
      int year,
      String color,
      int mileage,
      int price,
      String description,
      String image) async {
    final db = await SqlHelper.db();
    final data = {
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'mileage': mileage,
      'price': price,
      'description': description,
      'image': image,
    };

    final result = await db.update('cars', data, where: 'id = ?', whereArgs: [id]);

    return result;
  }

}
