import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DriverPassengerHelper {
  static Future<dynamic> createData(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/trip'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      print("erreur");
      return {};
    }
  }

  static Future<dynamic> updatePosition(body, int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/update_position/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      return {};
    }
  }

  static Future<dynamic> updateData(int id, body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/trip_status/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      return {};
    }
  }

  static Future<dynamic> cancelReason(int id, body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/cancel_reason/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      return {};
    }
  }

  static Future<List> getOne(int id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/trip/get/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }
}
