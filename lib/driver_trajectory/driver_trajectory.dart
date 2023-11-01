import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver_menu/driver_menu.dart';
import '../driver_menu/driver_top_menu.dart';
import '../driver_trips/data_helper.dart';
import '../driver_trips/driver_trips.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../location/location_search_dialogue.dart';
import '../location/maps_only_screen.dart';

class DriverTrajectory extends StatefulWidget {
  Map<String, dynamic>? data;
  DriverTrajectory(this.data);
  @override
  State<DriverTrajectory> createState() => _DriverTrajectory();
}

class _DriverTrajectory extends State<DriverTrajectory> {
  Map<String, dynamic> _userConnected = {};
  bool _isLoading = true;
  bool departurOrArrival = true;
  bool _editMode = false;
  bool _editShow = false;
  bool _fullTrajectory2 = true;
  bool _fullTrajectory1 = true;
  bool champOnly = true;
  bool recherchbtn = false;
  int tripId = 0;
  double _distanceInfo = 150;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  GoogleMapController? _mapController;
  GoogleMapController? mapController;

  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _distance = TextEditingController();
  final TextEditingController _temps = TextEditingController();

  LatLng _departureCoord = LatLng(0, 0);
  LatLng _arrivalCoord = LatLng(0, 0);
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
            " min";
      });
      // _distance.text = (totalDistance / 1000).toStringAsFixed(2);
    } else {}
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

  void _getSearchPage() {
    setState(() {
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

  Future<void> _updateCoordinate() async {
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
    try {
      final jsonData = jsonDecode(data);
      final latitude = jsonData['Latitude'];
      final longitude = jsonData['Longitude'];
      final value = jsonData['Value'];
      if (value == "1") {
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
          });
        } else {}
      } else {}
    } catch (e) {}
    testCordinate();
    getNorme();
  }

  openCloseForm(data) {
    setState(() {
      champOnly = data;
      _fullTrajectory2 = true;
      _fullTrajectory1 = true;
    });
  }

  void setValue(data) {
    setState(() {
      _editMode = true;
      _editShow = true;
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

      _departure.text = "";
      _arrival.text = "";
      setValue(data);
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
          : SingleChildScrollView(
              child: Stack(children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: MapsOnlyScreen(_departureCoord, _arrivalCoord, 0.30),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: 100,
                          child: DriverTopMenu(),
                        ),
                        champOnly
                            ? Stack(children: [
                                // 1er bloc *******************************************
                                Container(
                                  width: 10 * screenWidth / 12,
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.white],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.5, 0.5],
                                    ),
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
                                                  width: 9 * screenWidth / 12,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 9 *
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
                                                        width: 9 *
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
                                                                " km",
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
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
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
                                                        "Quel trajet souhaitez-vous proposer?",
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
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: 8 * screenWidth / 12,
                                        height: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        height: recherchbtn ? 150 : 100,
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: Container(
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
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child: Image.asset(
                                                        'web/icons/line_blue.png',
                                                        width: 2,
                                                        height: 5,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child: Image.asset(
                                                        'web/icons/line_blue.png',
                                                        width: 2,
                                                        height: 5,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
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
                                                              "DÉPART",
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
                                                                    onTap:
                                                                        () async {
                                                                      mapController =
                                                                          await mapController;
                                                                      getSearchInput(
                                                                          true,
                                                                          1);
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
                                                                )
                                                        ],
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
                                                              : GestureDetector(
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
                                                                    child: Text(
                                                                      "12 boulevard Jean Moulin,1745 Moulin,1745",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontFamily:
                                                                            'Montserrat-Medium',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                          // TextField(
                                                          //     onTap:
                                                          //         () async {
                                                          //       mapController =
                                                          //           await mapController;
                                                          //       getSearchInput(
                                                          //           false,
                                                          //           0);
                                                          //     },
                                                          //     controller:
                                                          //         _arrival,
                                                          //     decoration:
                                                          //         InputDecoration(
                                                          //       hintText:
                                                          //           "14 boulevard Jean Moulin,1745 Moulin,1745",
                                                          //       border:
                                                          //           InputBorder
                                                          //               .none,
                                                          //     ),
                                                          //     style:
                                                          //         TextStyle(
                                                          //       fontSize:
                                                          //           14,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w500,
                                                          //       color: Colors
                                                          //           .grey,
                                                          //       fontFamily:
                                                          //           'Montserrat-Medium',
                                                          //     ),
                                                          //   ),
                                                        ],
                                                      ),
                                                    ),
                                                    recherchbtn
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                if (_editMode) {
                                                                  _updateCoordinate();
                                                                } else {
                                                                  _saveCoordinate();
                                                                }
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      backgroundColor:
                                                                          appTheme),
                                                              child: Text(
                                                                "ENREGISTRER",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Montserrat-Bold',
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                              )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
    );
  }
}
