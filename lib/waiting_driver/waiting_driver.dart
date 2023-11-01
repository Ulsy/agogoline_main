import 'dart:convert';

import 'package:agogolines/stripe_payment/pay_with_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver_passenger/driver_map_helper.dart';
import '../driver_passenger/driver_with_passenger.dart';
import '../free_drive/data_helper.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import './maps_background_tracker.dart';
import '../global_screen/trajectory_direction.dart';
import '../passenger_menu/passenger_top_menu.dart';
import 'driver_witing_form.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class WaitingDriver extends StatefulWidget {
  dynamic trajectoryId;
  dynamic userData;
  WaitingDriver({required this.trajectoryId, required this.userData});
  @override
  State<WaitingDriver> createState() => _WaitingDriver();
}

class _WaitingDriver extends State<WaitingDriver> {
  bool _isLoading = true;
  String _distance = "";
  String _textContent = "Votre conducteur est en route";
  LatLng _departure = LatLng(0.0000, 0.0000);
  LatLng _arrival = LatLng(0.0000, 0.0000);
  LatLng _actuallyPosition = LatLng(0.0000, 0.0000);
  dynamic _trajectory = {};
  int _tripState = 0;
  bool playAlg = true;
  int idTrip = 0;
  void testState(data, response) {
    switch (response['status']) {
      case 0:
        setState(() {
          _tripState = 0;
        });
        RefreshTrip(data);
        break;
      case 1:
        setState(() {
          _tripState = 1;
          _textContent = " vient d'annuler son trajet !";
          playAlg = false;
        });
        break;
      case 4:
        setState(() {
          _textContent = "Votre conducteur est arrivé et vous attend !";
          _tripState = 4;
          playAlg = false;
        });
        break;
    }
  }

  void _goToMappy() async {
    var coordinate = (_trajectory['d_latitude']).toString() +
        ',' +
        (_trajectory['d_latitude']).toString() +
        ',' +
        (_trajectory['a_latitude']).toString() +
        ',' +
        (_trajectory['a_longitude']).toString();
    String url =
        "https://fr.mappy.com/itineraire#/voiture/" + coordinate + "/car/16";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

  void dispose() {
    playAlg = false;

    super.dispose();
  }

  _getWithDriver() {
    var data = [_trajectory, 0, idTrip];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverWithPassenge(
          trajectory: data,
          userData: widget.userData,
        ),
      ),
    );
  }

  void RefreshTrip(data) async {
    var response = await DataHelperDriverFree.getPositionByTrajectory(data);
    if (response.length > 0) {
      dynamic tripData = response[0];
      await getNorme(
        tripData['actually_latitude'],
        tripData['actually_longitude'],
        tripData['a_latitude'],
        tripData['a_longitude'],
      );
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        idTrip = tripData['id'];
        _actuallyPosition = LatLng(
            tripData['actually_latitude'], tripData['actually_longitude']);
      });
      if (playAlg == true) {
        testState(data, response[0]);
      }
    } else {
      await Future.delayed(Duration(seconds: 3));
      if (playAlg == true) {
        RefreshTrip(data);
      }
    }
  }

  void RefreshRate(data) async {
    var response = await DataHelperDriverFree.getOneDiscussion(data);
    setState(() {
      _trajectory = response[0];
      _isLoading = false;
    });
    RefreshTrip(data);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _departure = LatLng(
          _trajectory['driver_d_latitude'], _trajectory['driver_d_longitude']);
      _arrival = LatLng(_trajectory['d_latitude'], _trajectory['d_longitude']);
    });
  }

  // void _cancelTrip(data) {}

  void _cancelTrip() async {
    dynamic body = {'status': 3, 'type': 0};
    var res = await DriverPassengerHelper.updateData(idTrip, body);
    setState(() {
      playAlg = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
    );
  }

  getNorme(d_latitude, d_longitude, a_latitude, a_longitude) async {
    print('*****************************************');
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAQX2iFEPh2ZaX5ks8JHbHpzc5K8GD6G08",
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
      setState(() {
        _distance = (totalDistance / 1000).toStringAsFixed(2);
        _textContent = "Votre conducteur est en route, il arrive dans " +
            ((double.parse(_distance) / 30) * 60).toStringAsFixed(0) +
            "min";
      });
    } else {}
  }

  @override
  void initState() {
    RefreshRate(widget.trajectoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          margin: EdgeInsets.only(top: 25),
          height: 80,
          child: PassengerTopMenu(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                children: [
                  Container(
                    height: screenHeight,
                    width: screenWidth,
                    child: MapsBGTracker(
                      departure: _departure,
                      arrival: _arrival,
                      actullyPosition: _actuallyPosition,
                      markerPostion: 0.0,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Container(
                      child: TrajectoryDirection(trajectory: _trajectory),
                    ),
                  ),
                  Container(
                    child: DriverWaitingFrom(
                      driver: _trajectory['driver'],
                      cancelTrip: _cancelTrip,
                      goToMappy: _goToMappy,
                      getWithDriver: _getWithDriver,
                      textContent: _textContent,
                      status: _tripState,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
