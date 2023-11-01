import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class TrajectoryStoryService {
  static Future<List> getAllData(int id, int type) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    print('id: ' + id.toString());
    print('type: ' + type.toString());
    final response = await http.post(
      Uri.parse(
          GlobalUrl.getGlobalUrl() + '/get_trajectory_story/' + id.toString()),
      headers: headers,
      body: jsonEncode({'type': type}),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }
}
