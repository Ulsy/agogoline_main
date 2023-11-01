import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DataHelperMenu {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE user_connected(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      information TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("database_name.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> deleteData(int id) async {
    print(id);
    final db = await DataHelperMenu.db();
    try {
      await db.delete('user_connected', where: "id = ?", whereArgs: [id]);
      print('tsy errerur');
    } catch (err) {
      print('errur');
      print(err);
    }
  }
}
