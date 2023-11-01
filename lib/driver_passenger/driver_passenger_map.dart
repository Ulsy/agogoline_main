import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../driver_menu/driver_top_menu.dart';
import '../driver_trajectory/driver_trajectory.dart';
import '../global_screen/quiestion_page.dart';
import '../global_url.dart';
import 'arrived_in_passenger.dart';
import 'cancel_reason.dart';
import 'driver_map_helper.dart';
import 'maps_only_screen_driver.dart';

// ignore: must_be_immutable
class DriverPassengerMap extends StatefulWidget {
  Map<String, dynamic>? initialData;
  dynamic userData;
  DriverPassengerMap({required this.initialData, required userData});
  @override
  State<DriverPassengerMap> createState() => _DriverPassengerMap();
}

class _DriverPassengerMap extends State<DriverPassengerMap> {
  bool _isLoading = false;
  dynamic _clientData = {};
  dynamic _trajectoryData = {};
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  GoogleMapController? mapController;
  LatLng _departureCoord = LatLng(-18.8791902, 47.5079055);
  LatLng _arrivalCoord = LatLng(-18.7791902, 47.5079055);
  LocationData? _currentPosition;
  int goToClientId = 0;
  int playAlg = 0;
  bool updating = false;
  bool questionPage = false;
  bool cancelReason = false;

  Future<void> _addData() async {
    final body = {
      'trajectory_id': _trajectoryData['id'],
      'd_latitude': _trajectoryData['driver_d_latitude'],
      'd_longitude': _trajectoryData['driver_d_longitude'],
      'actually_latitude': _trajectoryData['driver_d_latitude'],
      'actually_longitude': _trajectoryData['driver_d_longitude'],
      'a_latitude': _trajectoryData['d_latitude'],
      'a_longitude': _trajectoryData['d_longitude'],
      'status': 0,
      'type': 0
    };
    var response = await DriverPassengerHelper.createData(body);
    if (response != {}) {
      goToClientId = response['id'];
    }
  }

  Future<void> updatePosition(position) async {
    setState(() {
      updating = true;
    });
    final body = {
      'actually_latitude': position['latitude'],
      'actually_longitude': position['longitude'],
    };
    var response =
        await DriverPassengerHelper.updatePosition(body, goToClientId);
    setState(() {
      updating = false;
    });
  }

  _cancel() {
    setState(() {
      questionPage = true;
    });
  }

  _beContinue(value) {
    if (value == 0) {
      setState(() {
        questionPage = false;
        cancelReason = false;
      });
    } else {
      _arrived(1);
    }
  }

  _questionResponse(response) {
    if (response == 1) {
      setState(() {
        cancelReason = true;
      });
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  _sendPosition(position) {
    if (!updating) {
      updatePosition(position);
    }
  }

  Future<void> _arrived(status) async {
    final body = {'status': status, 'type': 0};
    var response = await DriverPassengerHelper.updateData(goToClientId, body);
    if (status == 4) {
      var data = [widget.initialData, 1, goToClientId];
      setState(() {
        playAlg = 1;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArrivedInPassenger(
                userData: widget.userData,
                trajectoryData: data,
                withPassenger: false)),
      );
    } else {
      setState(() {
        playAlg = 1;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
      );
    }
  }

  @override
  void dispose() {
    playAlg = 1;
    super.dispose();
  }

  setClientData(data) async {
    setState(() {
      _trajectoryData = data;
      _clientData = data['passenger'];
    });

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _departureCoord = LatLng(_trajectoryData['driver_d_latitude'],
          _trajectoryData['driver_d_longitude']);
      _arrivalCoord =
          LatLng(_trajectoryData['d_latitude'], _trajectoryData['d_longitude']);
    });
    _addData();
  }

  @override
  void initState() {
    super.initState();
    setClientData(widget.initialData);
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
                  child: MapsOnlyScreenDriver(
                    _departureCoord,
                    _arrivalCoord,
                    0.0,
                    14,
                    playAlg,
                    sendPosition: _sendPosition,
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 100,
                    child: DriverTopMenu(),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  child: Container(
                    width: screenWidth,
                    child: Center(
                      child: Container(
                        width: screenWidth / 1.1,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Container(
                            width: screenWidth - (screenWidth / 4),
                            child: Column(children: [
                              Row(
                                children: [
                                  Container(
                                    width: screenWidth / 5.72,
                                    height: 70,
                                    child: Center(
                                      child: ClipOval(
                                        child: Image.network(
                                            GlobalUrl.getGlobalImageUrl() +
                                                _clientData['profil'],
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth / 2,
                                    height: 60,
                                    color: Colors.white,
                                    child: Column(children: [
                                      Container(
                                        height: 20,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "En route vers",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            )),
                                      ),
                                      Container(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _clientData['last_name'] +
                                                  ' ' +
                                                  _clientData['name'],
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            )),
                                      ),
                                      Container(
                                        height: 20,
                                        child: Row(children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.grey,
                                            size: 25.0,
                                          ),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _trajectoryData['departure'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              )),
                                        ]),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _cancel();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: Colors.white),
                                            child: Text(
                                              "ANNULER",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 120,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _arrived(4);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: appTheme,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: appTheme),
                                            child: Text(
                                              "ARRIVÉE",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Container(
                            width: screenWidth / 7,
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth / 10,
                                        margin: EdgeInsets.only(top: 5),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: appTheme,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                              size: 25.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: screenWidth / 10,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: appTheme,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Icon(
                                        Icons.mail_outline,
                                        color: appTheme,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: screenWidth / 10,
                                //   margin: EdgeInsets.only(bottom: 5),
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child: Container(
                                //       padding: EdgeInsets.all(5),
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //           color: appTheme,
                                //           width: 2.0,
                                //         ),
                                //         borderRadius:
                                //             BorderRadius.circular(50.0),
                                //       ),
                                //       child: Icon(
                                //         Icons.arrow_circle_up_sharp,
                                //         color: appTheme,
                                //         size: 20.0,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                questionPage
                    ? (cancelReason
                        ? CancelReason(
                            trajectoryId: widget.initialData?['id'],
                            beCOntinue: _beContinue,
                          )
                        : QuestionPage(
                            parametter: {
                              'text':
                                  "Êtes-vous sûr(e) de vouloir annuler la course ?",
                              'type': 1,
                            },
                            response: _questionResponse,
                          ))
                    : Container(),
              ]),
            ),
    );
  }
}
