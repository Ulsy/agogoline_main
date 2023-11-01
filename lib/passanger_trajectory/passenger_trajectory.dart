import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../location/location_search_dialogue.dart';
import '../location/maps_only_screen.dart';
import '../passenger_menu/passenger_top_menu.dart';
import '../search_driver/search_driver.dart';

// ignore: must_be_immutable
class PassengerTrajectory extends StatefulWidget {
  Map<String, dynamic>? data;
  PassengerTrajectory(this.data);
  @override
  State<PassengerTrajectory> createState() => _PassengerTrajectory();
}

class _PassengerTrajectory extends State<PassengerTrajectory> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  Map<String, dynamic> _userConnected = {};
  bool _isLoading = true;
  bool _fullTrajectory2 = true;
  bool _fullTrajectory1 = true;
  bool departurOrArrival = true;
  bool champOnly = true;
  bool waitingSearch = false;
  int tripId = 0;
  bool recherchbtn = false;

  GoogleMapController? _mapController;
  GoogleMapController? mapController;

  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _distance = TextEditingController();
  final TextEditingController _temps = TextEditingController();
  double _distanceInfo = 150;

  LatLng _departureCoord = LatLng(-18.8791902, 47.5079055);
  LatLng _arrivalCoord = LatLng(-18.7791902, 47.5079055);
  void getNorme() async {
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
      setState(() {
        _distance.text = (totalDistance / 1000).toStringAsFixed(2);
        _temps.text = "Temps: " +
            ((double.parse(_distance.text) / 30) * 60).toStringAsFixed(0) +
            "min";
      });
    } else {}
  }

  void freeDriver() async {
    setState(() {
      waitingSearch = true;
    });
    final journey = {
      "lat_departure": _departureCoord.latitude,
      "log_departure": _departureCoord.longitude,
      "lat_arrival": _arrivalCoord.latitude,
      "log_arrival": _arrivalCoord.longitude,
      "departure": _departure.text,
      "arrival": _arrival.text,
      "distance": _distance.text
    };
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SearchDriver(trajectory: journey, userData: _userConnected)),
    );
  }

  getSearchInput(dataType, type) {
    setState(() {
      departurOrArrival = dataType;
      if (type == 1) {
        _fullTrajectory1 = false;
      } else {
        _fullTrajectory2 = false;
      }
    });
  }

  openCloseForm(data) {
    setState(() {
      champOnly = data;
      _fullTrajectory2 = true;
      _fullTrajectory1 = true;
    });
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

  void testCordinate() {
    if (((_departure.text).length) > 0 && ((_arrival.text).length) > 0) {
      setState(() {
        recherchbtn = true;
        _distanceInfo = 250;
      });
    } else {
      setState(() {
        recherchbtn = false;
        _distanceInfo = 150;
      });
    }
  }

  LatLng points = LatLng(-18.8791902, 47.5079055);
  void oneCoordonate(data) {
    try {
      final jsonData = jsonDecode(data);
      final latitude = jsonData['Latitude'];
      final longitude = jsonData['Longitude'];
      if (latitude is! num && longitude is! num) {
        setState(() {
          points = LatLng(double.parse(latitude), double.parse(longitude));
          if (departurOrArrival) {
            _departure.text = jsonData['Adress'];
            _departureCoord = points;
          } else {
            _arrival.text = jsonData['Adress'];
            _arrivalCoord = points;
          }
        });
      } else {}
    } catch (e) {
      print("Error decoding JSON data: $e");
    }
    testCordinate();
    getNorme();
  }

  void setValue(data) {
    setState(() {
      tripId = data['id'];
      _departure.text = data["departure"];
      _arrival.text = data["arrival"];
      _distance.text = (data["distance"]).toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();
    if (widget.data != null && widget.data != {}) {
      dynamic data = widget.data;
      setValue(data);
    }
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
              child: Stack(children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight + 100,
                  child: MapsOnlyScreen(_departureCoord, _arrivalCoord, 0.30),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        champOnly
                            ? Stack(children: [
                                // 1er bloc *******************************************
                                Container(
                                  width: 10 * screenWidth / 12,
                                  margin: EdgeInsets.only(top: 10),
                                  height: _distanceInfo,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: _distanceInfo,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                  width: 10 * screenWidth / 12,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 10 *
                                                            screenWidth /
                                                            24,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            _temps.text,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    "Roboto-Medium"),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 10 *
                                                            screenWidth /
                                                            24,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            "Distance: " +
                                                                _distance.text +
                                                                "km",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    "Roboto-Medium"),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                // 1er bloc *******************************************
                                // 2er bloc *******************************************
                                Container(
                                  width: 10 * screenWidth / 12,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 10 * screenWidth / 12,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width:
                                                          7 * screenWidth / 12,
                                                      child: Text(
                                                        "Quel trajet souhaitez-vous effectuer?",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 15,
                                                color: appTheme,
                                              ),
                                              onPressed: () async {
                                                openCloseForm(false);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: 8 * screenWidth / 12,
                                        height: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      'web/icons/departure.png',
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Image.asset(
                                                      'web/icons/line_blue.png',
                                                      width: 2,
                                                      height: 5,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Image.asset(
                                                      'web/icons/line_blue.png',
                                                      width: 2,
                                                      height: 5,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Image.asset(
                                                      'web/icons/line_blue.png',
                                                      width: 2,
                                                      height: 5,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Image.asset(
                                                      'web/icons/pin.png',
                                                      width: 25,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 15 * screenWidth / 24,
                                              child: Transform.translate(
                                                offset: Offset(0, 0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          15 * screenWidth / 24,
                                                      height: 20,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "DÉPART",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                    ),
                                                    !_fullTrajectory1
                                                        ? LocationSearchDialog(
                                                            editOne:
                                                                oneCoordonate,
                                                            mapController:
                                                                _mapController)
                                                        : Container(
                                                            width: 8 *
                                                                screenWidth /
                                                                12,
                                                            height: 20,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                mapController =
                                                                    await mapController;
                                                                getSearchInput(
                                                                    true, 1);
                                                              },
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Text(
                                                                  "12 boulevard Jean Moulin,1745 Moulin,1745",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Montserrat-Medium',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      width:
                                                          9 * screenWidth / 12,
                                                      height: 0.5,
                                                      color: Colors.grey,
                                                    ),
                                                    Container(
                                                      width:
                                                          15 * screenWidth / 24,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 15 *
                                                                screenWidth /
                                                                24,
                                                            height: 20,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "ARRIVÉE",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-Bold',
                                                              ),
                                                            ),
                                                          ),
                                                          !_fullTrajectory2
                                                              ? LocationSearchDialog(
                                                                  editOne:
                                                                      oneCoordonate,
                                                                  mapController:
                                                                      _mapController)
                                                              : Container(
                                                                  width: 15 *
                                                                      screenWidth /
                                                                      24,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      mapController =
                                                                          await mapController;
                                                                      getSearchInput(
                                                                          false,
                                                                          0);
                                                                    },
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Text(
                                                                        "12 boulevard Jean Moulin,1745 Moulin,1745",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontFamily:
                                                                              'Montserrat-Medium',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      recherchbtn
                                          ? Container(
                                              child: waitingSearch
                                                  ? CircularProgressIndicator()
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 5),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          freeDriver();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                backgroundColor:
                                                                    appTheme),
                                                        child: Text(
                                                          "RECHERCHER UN CONDUCTEUR",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat-Bold',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                                // 2er bloc *******************************************
                              ])
                            : Container(
                                width: screenWidth,
                                height: screenHeight,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 150,
                                      child: Container(
                                        width: screenWidth,
                                        alignment: Alignment.bottomCenter,
                                        child: FloatingActionButton(
                                          onPressed: () async {
                                            openCloseForm(true);
                                          },
                                          child: Icon(Icons.map),
                                        ),
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
            ),
    );
  }
}
