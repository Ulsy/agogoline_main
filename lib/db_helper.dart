import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Furniture {
  final int id = 0;
  final String label = '';
  final String icon = '';
  final String created_at = '';
  final String updated_at = '';
}

class SQLHelper {
  //SQFlite
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      desc TEXT,
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

  static Future<int> createData(String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'desc': desc};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch (err) {}
  }

  //Laravel Backend
  static Future<int> createDataBack(String title, String? desc) async {
    final body = jsonEncode({"id": 0, "label": title, "icon": desc});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/furniture'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Add response: " + data);
      return 1;
    } else {
      print("erreur");
      return 0;
    }
  }

  static Future<List> getAllDataBack() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/furniture'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body)["data"];
      return list;
    } else {
      print(response.body);
      return [];
    }
  }

  static Future<int> updateDataBack(int id, String title, String? desc) async {
    final body = jsonEncode({"id": 0, "label": title, "icon": desc});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/furniture/${id}'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Add response: " + data);
      return 1;
    } else {
      print("erreur");
      return 0;
    }
  }

  static Future<void> deleteDataBack(int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/furniture/delete/${id}'),
      headers: headers,
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    } else {
      print("erreur");
    }
  }
}
