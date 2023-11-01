import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver_menu/driver_menu.dart';
import '../driver_trips/data_helper.dart';
import '../driver_trips/driver_trips.dart';
import '../global_url.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../location/location_search_dialogue.dart';
import '../location/maps_only_screen.dart';

class PassengerTrajectory extends StatefulWidget {
  Map<String, dynamic>? data;
  PassengerTrajectory(this.data);
  @override
  State<PassengerTrajectory> createState() => _PassengerTrajectory();
}

class _PassengerTrajectory extends State<PassengerTrajectory> {
  Map<String, dynamic> _userConnected = {};
  bool _isLoading = true;
  bool _fullTrajectory = true;
  bool departurOrArrival = true;
  bool _editMode = false;
  bool _editShow = false;
  int tripId = 0;
  Color blueColors = Color.fromARGB(255, 101, 90, 169);

  GoogleMapController? mapController;

  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _distance = TextEditingController();

  LatLng _departureCoord = LatLng(0, 0);
  LatLng _arrivalCoord = LatLng(0, 0);
  void getNorme() async {
    print('**************++++++++++++++++++');
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAQX2iFEPh2ZaX5ks8JHbHpzc5K8GD6G08",
      PointLatLng(_departureCoord.latitude, _departureCoord.longitude),
      PointLatLng(_arrivalCoord.latitude, _arrivalCoord.longitude),
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

      _distance.text = (totalDistance / 1000).toStringAsFixed(2);
    } else {
      print('Erreur lors du calcul de l\'itinéraire');
    }
  }

  late GoogleMapController? _mapController;
  void _getSearchPage() {
    setState(() {
      _fullTrajectory = false;
      if (_editShow) {
        dynamic data = widget.data;
        _departureCoord = LatLng(double.parse(data["d_latitude"].toString()),
            double.parse(data["d_longitude"].toString()));
        _arrival.text = data["arrival"];
        _arrivalCoord = LatLng(double.parse(data["a_latitude"].toString()),
            double.parse(data["a_longitude"].toString()));
      }
    });
  }

  Future<void> _updateCoordinate() async {
    print('********************************');
    final data = {
      "user_client_id": _userConnected['id'],
      "departure": _departure.text,
      "d_latitude": _departureCoord.latitude,
      "d_longitude": _departureCoord.longitude,
      "arrival": _arrival.text,
      "a_latitude": _arrivalCoord.latitude,
      "a_longitude": _arrivalCoord.longitude,
      "distance": _distance.text,
    };
    await DataHelperDriverTrip.updateData(tripId, data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverTrips()),
    );
  }

  Future<void> _saveCoordinate() async {
    print('********************************');
    final data = {
      "user_client_id": _userConnected['id'],
      "departure": _departure.text,
      "d_latitude": _departureCoord.latitude,
      "d_longitude": _departureCoord.longitude,
      "arrival": _arrival.text,
      "a_latitude": _arrivalCoord.latitude,
      "a_longitude": _arrivalCoord.longitude,
      "distance": _distance.text,
    };
    await DataHelperDriverTrip.createDataBack(data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverTrips()),
    );
  }

  Future<void> _checkMenu() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverMenu()),
    );
  }

  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    if (data.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    setState(() {
      _userConnected = jsonDecode(data[0]['information']);
      _isLoading = false;
    });
  }

  LatLng points = LatLng(-18.8791902, 47.5079055);
  void oneCoordonate(data) {
    print("***************************");
    print(data);
    try {
      final jsonData = jsonDecode(data);
      final latitude = jsonData['Latitude'];
      final longitude = jsonData['Longitude'];
      final value = jsonData['Value'];
      if (value == "0") {
        if (latitude is! num && longitude is! num) {
          setState(() {
            points = LatLng(double.parse(latitude), double.parse(longitude));
            if (departurOrArrival == true) {
              _departure.text = jsonData['Adress'];
              _departureCoord = points;
            } else {
              _arrival.text = jsonData['Adress'];
              _arrivalCoord = points;
            }
            print('xxxxxxxxxxx');
            print(jsonData['Value']);
          });
        } else {
          print("Latitude or Longitude is not a valid number.");
        }
      } else {
        setState(() {
          _fullTrajectory = true;
        });
      }
    } catch (e) {
      print("Error decoding JSON data: $e");
    }
    getNorme();
  }

  void setValue(data) {
    setState(() {
      _editMode = true;
      _editShow = true;
      tripId = data['id'];
      _departure.text = data["departure"];
      // _departureCoord = LatLng(double.parse(data["d_latitude"].toString()),
      //     double.parse(data["d_longitude"].toString()));
      _arrival.text = data["arrival"];
      _distance.text = (data["distance"]).toString();
      // _arrivalCoord = LatLng(double.parse(data["a_latitude"].toString()),
      //     double.parse(data["a_longitude"].toString()));
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();
    if (widget.data != null && widget.data != {}) {
      // Access the data passed from the previous screen
      dynamic data = widget.data;

      _departure.text = "";
      _arrival.text = "";
      print('********************');
      print(data);
      setValue(data);
      print('*********************');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 255),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight,
                child: MapsOnlyScreen(_departureCoord, _arrivalCoord, 0.40),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: !_fullTrajectory
                    ? LocationSearchDialog(
                        editOne: oneCoordonate, mapController: _mapController)
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              width: 500,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(0, 3), // Offset(x, y)
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 120,
                                    margin: EdgeInsets.only(top: 25),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(Icons.menu),
                                        iconSize: 40,
                                        onPressed: () async {
                                          _checkMenu();
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 120,
                                    margin: EdgeInsets.only(top: 30),
                                    child: Center(
                                      child: Image.asset(
                                          'web/icons/agogoliness.png',
                                          width: 200,
                                          height: 30,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 120,
                                    margin: EdgeInsets.only(top: 25),
                                    child: Center(
                                      child: ClipOval(
                                        child: Image.network(
                                            GlobalUrl.getGlobalImageUrl() +
                                                _userConnected['profil'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 350,
                              margin: EdgeInsets.only(top: 150),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(0, 3), // Offset(x, y)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Center(
                                      child: Image.asset(
                                          'web/icons/src_dest.png',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          _editMode
                                              ? Text(
                                                  "Modifier trajet",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Text(
                                                  "Nouveau trajet",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    width: 300,
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  //b
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 200,
                                          child: Center(
                                            child: Transform.translate(
                                              offset: Offset(0, -15),
                                              child: Image.asset(
                                                  'web/icons/departdestination.png',
                                                  width: 40,
                                                  height: 150,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          child: Transform.translate(
                                            offset: Offset(0, -2),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "DÉPART",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .location_pin,
                                                              size: 25,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              _mapController =
                                                                  await mapController;
                                                              _getSearchPage();
                                                              setState(() {
                                                                departurOrArrival =
                                                                    true;
                                                              });
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          _departure.text,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  width: 300,
                                                  height: 0.5,
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  width: 250,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "ARRIVÉÉ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .location_pin,
                                                                    size: 25,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    _mapController =
                                                                        await mapController;
                                                                    _getSearchPage();
                                                                    setState(
                                                                        () {
                                                                      departurOrArrival =
                                                                          false;
                                                                    });
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                _arrival.text,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Text(
                                                      _distance.text + " km",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (_editMode) {
                                                          _updateCoordinate();
                                                        } else {
                                                          _saveCoordinate();
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          "Enregistrer",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ]),
    );
  }
}
