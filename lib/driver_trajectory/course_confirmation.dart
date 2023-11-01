import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver_menu/driver_top_menu.dart';
import '../driver_passenger/driver_passenger_map.dart';
import '../free_drive/data_helper.dart';
import '../global_screen/quiestion_page.dart';
import '../global_url.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../location/maps_only_screen.dart';
import 'data_helper.dart';
import 'driver_trajectory.dart';

class CourseConfirmation extends StatefulWidget {
  @override
  State<CourseConfirmation> createState() => _CourseConfirmation();
}

class _CourseConfirmation extends State<CourseConfirmation> {
  Map<String, dynamic> _userConnected = {};
  List<dynamic> _allData = [];
  bool _isLoading = true;
  bool departurOrArrival = true;
  bool champOnly = true;
  bool _nowAsk = false;
  bool recherchbtn = false;
  bool driverProposition = false;
  bool validateWaiting = false;
  double _refinedRate = 0;
  double _defaultRate = 0;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  bool clientResponseWaiting = false;
  bool waitingDenied = false;
  int goToPassenger = 0;
  bool playAlg = true;
  bool questionPage = false;
  String questionContent = "";
  int cancelType = 0;

  GoogleMapController? mapController;

  final TextEditingController _distance = TextEditingController();
  final TextEditingController _temps = TextEditingController();

  LatLng _departureCoord = LatLng(0, 0);
  LatLng _arrivalCoord = LatLng(0, 0);
  void getNorme(LatLng departure, LatLng arrival) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAQX2iFEPh2ZaX5ks8JHbHpzc5K8GD6G08",
      PointLatLng(departure.latitude, departure.longitude),
      PointLatLng(arrival.latitude, arrival.longitude),
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
        _temps.text =
            ((double.parse(_distance.text) / 30) * 60).toStringAsFixed(0);
      });
    }
  }

  unAccept(value) {
    if (value == 0) {
      setState(() {
        questionContent = "Êtes-vous sûr(e) de vouloir refuser la course ?";
        questionPage = true;
        cancelType = value;
      });
    } else {
      setState(() {
        questionContent = "Êtes-vous sûr(e) de vouloir annuler la course ?";
        questionPage = true;
        cancelType = value;
      });
    }
  }

  _questionResponse(response) {
    if (response == 1) {
      if (cancelType == 0) {
        setState(() {
          validateWaiting = true;
          clientResponseWaiting = true;
          questionPage = false;
        });
        _updateData(4, 1);
      } else {
        _updateData(3, 0);
      }
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  Map<String, dynamic>? temporaryClientInformation;
  gotToClient() async {
    if (goToPassenger == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverPassengerMap(
                initialData: temporaryClientInformation,
                userData: _userConnected)),
      );
    } else {
      setState(() {
        _allData = [];
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CourseConfirmation()),
      );
    }
  }

  void RefreshRate(data) async {
    if (playAlg) {
      await Future.delayed(Duration(seconds: 3));
      var response = await DataHelperDriverFree.getOneDiscussionDriver(data);
      if (response.length > 0) {
        var status = response[0]['status'];
        switch (status) {
          case 0:
            RefreshRate(data);
            break;
          case 2:
            setState(() {
              goToPassenger = 2;
            });
            break;
          case 1:
            RefreshRate(data);
            break;
          case 4:
            setState(() {
              if (response[0]['second_status'] == 3) {
                waitingDenied = true;
              } else {
                RefreshRate(data);
              }
            });
            break;
          case 5:
            setState(() {
              goToPassenger = 5;
              temporaryClientInformation = response[0];
            });

            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
            );
            break;
          default:
            RefreshRate(data);
            break;
        }
      }
    }
  }

  void refineRate(value) {
    setState(() {
      if (value == 0) {
        _refinedRate--;
      } else {
        _refinedRate++;
      }
      if (_refinedRate != _defaultRate) {
        driverProposition = true;
      } else {
        driverProposition = false;
      }
    });
  }

  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    if (data.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _userConnected = jsonDecode(data[0]['information']);
      });
      getOneData(_userConnected['id']);
    }
  }

  Future<void> _updateData(data, second) async {
    int id = _allData[0]['id'];
    final body = {
      "status": data,
      "second_status": second,
      "rafined_rate": _refinedRate.toStringAsFixed(2),
    };
    var response = await DataHelperDriverFree.updateData(body, id);
    if (second == 2 || second == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
      );
    }
    if (response == 1 && driverProposition == true) {
      setState(() {
        validateWaiting = true;
      });
      RefreshRate(_allData[0]['id']);
    } else {
      RefreshRate(_allData[0]['id']);
    }
  }

  void getOneData(int id) async {
    final data = await DataHelperCourseConfirmation.getOneData(id);
    setState(() {
      _allData = data;
      if (data.length == 0) {
        _isLoading = false;
        _nowAsk = true;
      } else {
        if (data[0]['status'] != 0) {
          setState(() {
            validateWaiting = true;
            clientResponseWaiting = data[0]['status'] == 4 ? true : false;
          });
          RefreshRate(data[0]['id']);
        }
        _refinedRate = double.parse((_allData[0]['rafined_rate']).toString());
        _defaultRate = double.parse((_allData[0]['rafined_rate']).toString());
        LatLng diverInstance = LatLng(_allData[0]['driver_d_latitude'],
            _allData[0]['driver_d_longitude']);
        LatLng passengerInstance =
            LatLng(_allData[0]['d_latitude'], _allData[0]['d_longitude']);
        getNorme(diverInstance, passengerInstance);
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _departureCoord = diverInstance;
            _arrivalCoord = passengerInstance;
          });
        });
        _isLoading = false;
      }
    });
  }

  @override
  void dispose() {
    playAlg = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();
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
              child: Stack(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: MapsOnlyScreen(_departureCoord, _arrivalCoord, 0.80),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            child: DriverTopMenu(),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            height: screenHeight,
                            child: _nowAsk
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10 * screenWidth / 12,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [appTheme, appTheme],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.5, 0.5],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "AUCUNE DEMANDE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontFamily:
                                                    "Montserrat-Medium"),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(children: [
                                    // 1er bloc *******************************************
                                    Positioned(
                                      bottom: 200,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: appTheme,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 10 * screenWidth / 12,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: appTheme,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        10 * screenWidth / 12,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      "NOUVELLE DEMANDE",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Montserrat-Medium"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                              ),
                                              width: 10 * screenWidth / 12,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        10 * screenWidth / 12,
                                                    height: 120,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Column(children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Container(
                                                                child: ClipOval(
                                                                  child: Image.network(
                                                                      GlobalUrl
                                                                              .getGlobalImageUrl() +
                                                                          _allData[0]['passenger']
                                                                              [
                                                                              'profil'],
                                                                      width: 45,
                                                                      height:
                                                                          45,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 20 *
                                                                  screenWidth /
                                                                  48,
                                                              height: 50,
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 20 *
                                                                          screenWidth /
                                                                          48,
                                                                      height:
                                                                          18,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          _allData[0]['passenger']['last_name'] +
                                                                              _allData[0]['passenger']['name'],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat-Bold',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 19 *
                                                                          screenWidth /
                                                                          48,
                                                                      height:
                                                                          20,
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                      child:
                                                                          Text(
                                                                        "À " +
                                                                            _temps.text +
                                                                            " min",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontFamily:
                                                                              'Motserrat-Medium',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Container(
                                                              width: 11.8 *
                                                                  screenWidth /
                                                                  48,
                                                              height: 50,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: Container(
                                                                        child: Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              appTheme,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50.0),
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .mail_outline,
                                                                        color:
                                                                            appTheme,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: Container(
                                                                        child: Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            appTheme,
                                                                        borderRadius:
                                                                            BorderRadius.circular(50.0),
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .call,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25.0,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 10 *
                                                                  screenWidth /
                                                                  24,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    width: 20,
                                                                    height: 40,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            1,
                                                                        vertical:
                                                                            3),
                                                                    child: Container(
                                                                        child: Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              appTheme,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50.0),
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .euro_symbol,
                                                                        color:
                                                                            appTheme,
                                                                        size:
                                                                            10.0,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                  Container(
                                                                    width: 8 *
                                                                        screenWidth /
                                                                        24,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                2),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "TARIF PROPOSÉ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                              fontFamily: 'Montserrat-Bold',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                (_allData[0]['rafined_rate']).toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: appTheme,
                                                                                  fontFamily: 'Montserrat-Bold',
                                                                                ),
                                                                              ),
                                                                              Icon(
                                                                                Icons.euro_symbol,
                                                                                color: appTheme,
                                                                                size: 20.0,
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
                                                            Container(
                                                                width: 1,
                                                                height: 30,
                                                                color: Colors
                                                                    .grey),
                                                            Container(
                                                              width: (8.7 *
                                                                  screenWidth /
                                                                  24),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    width: 20,
                                                                    height: 30,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                1),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    child:
                                                                        Container(
                                                                      width: 20,
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              10),
                                                                      child: Center(
                                                                          child: Container(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .account_circle_outlined,
                                                                          color:
                                                                              appTheme,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 6 *
                                                                        screenWidth /
                                                                        24,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 3),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "PASSAGER",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                              fontFamily: 'Montserrat-Bold',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 7 *
                                                                              screenWidth /
                                                                              24,
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          margin:
                                                                              EdgeInsets.only(left: 5),
                                                                          child:
                                                                              Text(
                                                                            (_allData[0]['passenge_nbr']).toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: appTheme,
                                                                              fontFamily: 'Montserrat-Bold',
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
                                                      )
                                                    ]),
                                                  ),
                                                  Container(
                                                    width:
                                                        10 * screenWidth / 12,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          spreadRadius: 5,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        goToPassenger != 0
                                                            ? Container(
                                                                width: (10 *
                                                                        screenWidth /
                                                                        12) -
                                                                    5,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(20),
                                                                        width: 10 *
                                                                            screenWidth /
                                                                            12,
                                                                        child:
                                                                            Text(
                                                                          goToPassenger == 5
                                                                              ? "tarif conclu, rejoindre le client..."
                                                                              : "tarif refusé par le client!",
                                                                          textAlign:
                                                                              TextAlign.center,
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
                                                                      Center(
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            gotToClient();
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: appTheme,
                                                                                  width: 2.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              backgroundColor: appTheme),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                150,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  goToPassenger == 5 ? "EN ROUTE!" : "AUTRE CLIENT",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'Roboto-Bold',
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              )
                                                            : validateWaiting
                                                                ? (clientResponseWaiting
                                                                    ? Container(
                                                                        height:
                                                                            120,
                                                                        child: Column(
                                                                            children: [
                                                                              Container(
                                                                                width: (10 * screenWidth / 12) - 5,
                                                                                child: Center(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: (10 * screenWidth / 12) - 5,
                                                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                                                        child: Icon(
                                                                                          Icons.timer,
                                                                                          size: 25.0,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.symmetric(horizontal: 25),
                                                                                        width: (10 * screenWidth / 12) - 5,
                                                                                        child: Text(
                                                                                          waitingDenied ? "Le client a annulé le trajet" : "attendre si le client accepte le tarif normal...",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.grey,
                                                                                            fontFamily: 'Montserrat-Medium',
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    _updateData(4, waitingDenied ? 3 : 2);
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        side: BorderSide(
                                                                                          color: appTheme,
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                                      ),
                                                                                      backgroundColor: appTheme),
                                                                                  child: Container(
                                                                                    width: 50,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          waitingDenied ? "OK" : "NON",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontSize: 15,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Montserrat-Bold',
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            120,
                                                                        child: Column(
                                                                            children: [
                                                                              Container(
                                                                                width: (10 * screenWidth / 12) - 5,
                                                                                child: Center(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: (9 * screenWidth / 12) - 5,
                                                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                                                        child: Icon(
                                                                                          Icons.timer,
                                                                                          size: 25.0,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.symmetric(horizontal: 25),
                                                                                        width: (10 * screenWidth / 12) - 5,
                                                                                        child: Text(
                                                                                          "Tarif en attente de validation du  client...",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.grey,
                                                                                            fontFamily: 'Montserrat-Medium',
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    unAccept(1);
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        side: BorderSide(
                                                                                          color: appTheme,
                                                                                          width: 2.0,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                                      ),
                                                                                      backgroundColor: appTheme),
                                                                                  child: Container(
                                                                                    width: 180,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          "ANNULER LA COURSE",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontSize: 15,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.white,
                                                                                            fontFamily: 'Roboto-Bold',
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ))
                                                                : Container(),
                                                        (!validateWaiting &&
                                                                goToPassenger !=
                                                                    5)
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 5 *
                                                                        screenWidth /
                                                                        12,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                3),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              120,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
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
                                                                                margin: EdgeInsets.only(top: 5),
                                                                                child: Image.asset(
                                                                                  'web/icons/line_blue.png',
                                                                                  width: 2,
                                                                                  height: 5,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 5),
                                                                                child: Image.asset(
                                                                                  'web/icons/line_blue.png',
                                                                                  width: 2,
                                                                                  height: 5,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 5),
                                                                                child: Image.asset(
                                                                                  'web/icons/line_blue.png',
                                                                                  width: 2,
                                                                                  height: 5,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 5),
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
                                                                          width:
                                                                              (6 * screenWidth / 24) - 2.5,
                                                                          child:
                                                                              Transform.translate(
                                                                            offset:
                                                                                Offset(0, -2),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.only(top: 15),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                          "DÉPART",
                                                                                          style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.black,
                                                                                            fontFamily: 'Montserrat-Bold',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                          _allData[0]['departure'],
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.grey,
                                                                                            fontFamily: 'Montserrat-Medium',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(top: 15),
                                                                                  width: (15 * screenWidth / 24) - 2.5,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Container(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                "ARRIVÉE",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: Colors.black,
                                                                                                  fontFamily: 'Montserrat-Bold',
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                _allData[0]['arrival'],
                                                                                                style: TextStyle(
                                                                                                  fontSize: 14,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: Colors.grey,
                                                                                                  fontFamily: 'Montserrat-Medium',
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
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    width: 4.5 *
                                                                        screenWidth /
                                                                        12,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          width:
                                                                              (19 * screenWidth / 48) - 2.5,
                                                                          margin:
                                                                              EdgeInsets.only(top: 5),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "AFFINER LE TARIF?",
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                    fontFamily: 'Montserrat-Medium',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 10 * screenWidth / 24,
                                                                                child: Container(
                                                                                  width: 8 * screenWidth / 24,
                                                                                  margin: EdgeInsets.only(top: 5),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                    border: Border.all(
                                                                                      color: Colors.grey,
                                                                                      width: 1.0,
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 3 * screenWidth / 48,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border(
                                                                                            right: BorderSide(
                                                                                              color: Colors.grey,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                refineRate(0);
                                                                                              },
                                                                                              child: Text(
                                                                                                "-",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 25,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: Colors.black,
                                                                                                  fontFamily: 'Montserrat-Medium',
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 19 * screenWidth / 96,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            _refinedRate.toStringAsFixed(2),
                                                                                            style: TextStyle(
                                                                                              fontSize: 15,
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: Colors.black,
                                                                                              fontFamily: 'Montserrat-Medium',
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                          width: 3 * screenWidth / 48,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border(
                                                                                              left: BorderSide(
                                                                                                color: Colors.grey,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          child: Container(
                                                                                            child: Center(
                                                                                              child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  refineRate(1);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "+",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 25,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    color: Colors.black,
                                                                                                    fontFamily: 'Montserrat-Medium',
                                                                                                  ),
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
                                                                        Container(
                                                                          width: 10 *
                                                                              screenWidth /
                                                                              24,
                                                                          margin:
                                                                              EdgeInsets.only(top: 5),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {
                                                                                driverProposition ? _updateData(1, 0) : _updateData(5, 0);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  backgroundColor: appTheme),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    driverProposition ? "PROPOSER" : "VALIDER",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.white,
                                                                                      fontFamily: 'Montserrat-Bold',
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(left: 2),
                                                                                    child: Image.asset('web/icons/validate.png', width: 20, height: 14, fit: BoxFit.cover),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        driverProposition
                                                                            ? Container(
                                                                                width: 10 * screenWidth / 24,
                                                                                margin: EdgeInsets.only(top: 5),
                                                                                child: Center(
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      _updateData(3, 0);
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Colors.black,
                                                                                            width: 1.0,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                        ),
                                                                                        backgroundColor: Colors.white),
                                                                                    child: Container(
                                                                                      width: 8 * screenWidth / 24,
                                                                                      child: Text(
                                                                                        "ANNULER",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 20,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black,
                                                                                          fontFamily: 'Roboto-Bold',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                width: 10 * screenWidth / 24,
                                                                                margin: EdgeInsets.only(top: 5),
                                                                                child: Center(
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      unAccept(0);
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        shape: RoundedRectangleBorder(
                                                                                          side: BorderSide(
                                                                                            color: Colors.black,
                                                                                            width: 1.0,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                        ),
                                                                                        backgroundColor: Colors.white),
                                                                                    child: Container(
                                                                                      width: 8 * screenWidth / 24,
                                                                                      child: Text(
                                                                                        "REFUSER",
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black,
                                                                                          fontFamily: 'Montserrat-Bold',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  questionPage
                      ? QuestionPage(
                          parametter: {
                            'text': questionContent,
                            'type': 1,
                          },
                          response: _questionResponse,
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
