import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class PaymentChoiseService {
  static Future<int> choosePayment(body, id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/choose_payment/' + id.toString()),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return 1;
    } else {
      return 0;
    }
  }
}
