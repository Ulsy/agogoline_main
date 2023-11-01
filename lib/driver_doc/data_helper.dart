import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperDriver {
  static Future<int> createDataBack(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/driver_doc'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return 1;
    } else {
      print(response.body);
      print("erreur");
      return 0;
    }
  }
}
