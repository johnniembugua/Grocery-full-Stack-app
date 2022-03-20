import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/model.dart';

abstract class DBHelper {
  static Database? _db;

  static int get _version => 1;
  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      var databasePath = await getDatabasesPath();

      String _path = p.join(databasePath, "flutter_sqflite.db");
      _db = await openDatabase(_path,
          version: _version, onCreate: onCreate, onUpgrade: onUpgrade);
    } catch (e) {
      print(e);
    }
  }

  static void onCreate(Database db, int version) async {
    String sqlQuery =
        "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, productName STRING,productDesc STRING,categoryId INTEGER,price REAL,productPic String)";
    await db.execute(sqlQuery);
  }

  static void onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {
      //
    }
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toJson());
  }

  static Future<int> update(String table, Model model) async {
    return await _db!.update(
      table,
      model.toJson(),
      where: "id=?",
      whereArgs: [model.id],
    );
  }

  static Future<int> delete(String table, Model model) async {
    return await _db!.delete(
      table,
      where: "id=?",
      whereArgs: [model.id],
    );
  }
}
