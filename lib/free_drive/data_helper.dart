import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global_url.dart';

class DataHelperDriverFree {
  static Future<dynamic> addData(body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/passenger_trip'),
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

  static Future<List> getPositionByTrajectory(id) async {
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() +
          '/get_position_by_trajectory/' +
          id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }

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
      return {};
    }
  }

  static Future<int> updateData(body, id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      Uri.parse(GlobalUrl.getGlobalUrl() +
          '/passenger_trip/proposition/' +
          id.toString()),
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

  static Future<List> getAllData(initialData) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(
      Uri.parse(GlobalUrl.getGlobalUrl() + '/get_near_driver'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final oneDriver = getOneDrive(data['data'], initialData);
      return oneDriver;
    } else {
      return [];
    }
  }

  static Future<List> getNearOneDrive(int id) async {
    final response = await http.get(
      Uri.parse(
          GlobalUrl.getGlobalUrl() + '/get_one_near_driver/' + id.toString()),
    );
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return list;
    } else {
      return [];
    }
  }

  static Future<List> getOneDrive(drivers, initialData) async {
    List driver = [];
    for (var i = 0; i < drivers.length; i++) {
      var norme1 = await getNorme(
          drivers[i]['d_latitude'],
          drivers[i]['d_longitude'],
          initialData['lat_departure'],
          initialData['log_departure']);
      if (norme1 <= 5.00) {
        var norme2 = await getNorme(
            drivers[i]['a_latitude'],
            drivers[i]['a_longitude'],
            initialData['lat_arrival'],
            initialData['log_arrival']);
        if (norme2 <= 5.00) {
          var oneDriver = await getNearOneDrive(drivers[i]['user_client_id']);

          var newDriver = Map.from(oneDriver[0]);
          newDriver['driver_departure'] = drivers[i]['departure'];
          newDriver['driver_d_latitude'] = drivers[i]['d_latitude'];
          newDriver['driver_d_longitude'] = drivers[i]['d_longitude'];
          newDriver['driver_passenger_distance'] = norme1;
          driver.add([newDriver]);
        }
      }
      if (driver.length >= 3) {
        break;
      }
    }

    return driver;
  }

  static Future<int> TestDistance(latitude, longitude) {
    final distance = latitude + longitude;
    return distance;
  }

  static Future<double> getNorme(
      d_latitude, d_longitude, a_latitude, a_longitude) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalUrl.apiKey,
      PointLatLng(d_latitude, d_longitude),
      PointLatLng(a_latitude, a_longitude),
    );

    if (result.status == 'OK') {
      List<PointLatLng> points = result.points;

      double totalDistance = 0.0;

      for (int i = 0; i < points.length - 1; i++) {
        double distance = await Geolocator.distanceBetween(
          points[i].latitude,
          points[i].longitude,
          points[i + 1].latitude,
          points[i + 1].longitude,
        );
        totalDistance += distance;
      }
      return double.parse((totalDistance / 1000).toStringAsFixed(2));
    } else {
      return 100;
    }
  }
}
