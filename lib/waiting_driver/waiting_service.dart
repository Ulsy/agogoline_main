import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperDriverFree {
  static Future<dynamic> getOneDiscussionDriver(id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() +
          '/get_negociation_driver/' +
          id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      print('erreur');
      print(response.body);
      return {};
    }
  }

  static Future<dynamic> getOneDiscussion(id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/get_negociation/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      print(response.body);
      return {};
    }
  }
}
