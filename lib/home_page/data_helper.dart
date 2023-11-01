import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class Furniture {
  final int id = 0;
  final String label = '';
  final String icon = '';
  final String created_at = '';
  final String updated_at = '';
}

class DataHelperlogin {
  static Future<String> connexion(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/user_connection'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final res = testAccount(jsonDecode(response.body));
      return res;
    } else {
      print(response.body);
      return '';
    }
  }

  static Future<String> testAccount(serverResponseData) async {
    if (serverResponseData[0][0] == 0) {
      return 'email';
    } else if (serverResponseData[0][1] == 0) {
      return 'password';
    } else {
      createData(jsonEncode(serverResponseData[1][0]));
      return serverResponseData[1][0]['type'];
    }
  }

  //local data
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

  static Future<int> createData(information) async {
    final db = await DataHelperlogin.db();
    final data = {'id': 1, 'information': information};
    final id = await db.insert('user_connected', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getUserConnected() async {
    final db = await DataHelperlogin.db();
    return db.query('user_connected', orderBy: 'id');
  }
}
