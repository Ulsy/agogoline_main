import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperForgotPassword {
  static Future<String> forgotPassword(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/forgot_password/email'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final res = response.body;
      return res;
    } else {
      print("error");
      print(response.body);
      return '';
    }
  }

  static Future<String> resetPassword(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/forgot_password/reset'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final res = response.body;
      return res;
    } else {
      return '0';
    }
  }
}
