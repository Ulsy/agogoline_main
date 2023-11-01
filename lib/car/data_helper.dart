import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperCar {
  static Future<int> createDataBack(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/car'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return 1;
    } else {
      return 0;
    }
  }

  static Future<int> deleteData(int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/car/delete/' + id.toString()),
      headers: headers,
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return 1;
    } else {
      print(response.body);
      return 0;
    }
  }

  static Future<int> updateData(body, int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/car_update/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      print(response.body);
      return 1;
    } else {
      print(response.body);
      return 0;
    }
  }

  static Future<List> getAllData(int id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/car/get/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }

  static Future<List> searchBrand(brand, model) async {
    final response = await http.get(
      Uri.parse(
          GlobalUrl.getGlobalUrl() + '/search_brand/' + brand + '/' + model),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }
}
