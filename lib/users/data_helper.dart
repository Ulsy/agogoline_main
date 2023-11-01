import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperUser {
  static Future<dynamic> createDataBack(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/user_client'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.body);
      print("erreur");
      return {};
    }
  }

  static Future<dynamic> generateOtpCode(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/generate_code'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];

      return data;
    } else {
      print(response.body);
      return {'otp': 0};
    }
  }

  static Future<dynamic> verifyOtpCode(body) async {
    print('**************************');
    print(body);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/verify_code'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print('**************************');
      print(response.body);
      return data;
    } else {
      print(response.body);
      return {'otp': 0};
    }
  }

  static Future<int> testEmail(body) async {
    print(body);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/test_email'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return 1;
    } else {
      print(response.body);
      return 0;
    }
  }

  static Future<dynamic> updateProfil(body, id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/user_client/' + id.toString()),
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
}
