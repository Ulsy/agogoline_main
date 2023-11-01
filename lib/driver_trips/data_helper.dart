import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperDriverTrip {
  static Future<int> createDataBack(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/driver_trip'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var data = jsonDecode(response.body);
      return 1;
    } else {
      print(response.body);
      print("erreur");
      return 0;
    }
  }

  static Future<int> updateData(int id, body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/driver_trip/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var data = jsonDecode(response.body);
      return 1;
    } else {
      return 0;
    }
  }

  static Future<List> getAllData(int id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/driver_trip/get/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }

  static Future<void> deleteDataBack(int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(
          GlobalUrl.getGlobalUrl() + '/driver_trip/delete/' + id.toString()),
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
