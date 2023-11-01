import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class ProfitService {
  static Future<dynamic> getAllProfit(id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/get_all_profit/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return {};
    }
  }
}
