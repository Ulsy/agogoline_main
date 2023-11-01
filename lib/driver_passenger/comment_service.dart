import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class CommnentService {
  static Future<dynamic> createData(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/comment'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return {};
    }
  }
}
