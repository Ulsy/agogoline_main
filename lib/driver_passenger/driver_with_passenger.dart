import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../driver_menu/driver_top_menu.dart';
import '../global_url.dart';
import '../passenger_menu/passenger_top_menu.dart';
import 'arrived_in_passenger.dart';
import 'comment_by_passenger.dart';
import 'driver_map_helper.dart';
import 'maps_only_screen.dart';

// ignore: must_be_immutable
class DriverWithPassenge extends StatefulWidget {
  List<dynamic> trajectory;
  dynamic userData;
  DriverWithPassenge({required this.trajectory, required this.userData});
  @override
  State<DriverWithPassenge> createState() => _DriverWithPassenge();
}

class _DriverWithPassenge extends State<DriverWithPassenge> {
  bool _isLoading = false;
  dynamic _clientData = {};
  dynamic _trajectoryData = {};
  int playAlg = 0;

  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  GoogleMapController? mapController;
  LatLng _departureCoord = LatLng(-18.8791902, 47.5079055);
  LatLng _arrivalCoord = LatLng(-18.7791902, 47.5079055);
  LocationData? _currentPosition;
  int tripId = 0;
  int dataType = 0;
  bool goWithClient = false;

  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  Future<void> _arrived(status) async {
    final body = {'status': status, 'type': 1};
    var response = await DriverPassengerHelper.updateData(tripId, body);
    setState(() {
      goWithClient = true;
    });
    if (status == 6 && dataType == 0) {
      setState(() {
        playAlg = 1;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentByPassenger(
                userData: widget.userData, trajectoryData: widget.trajectory)),
      );
    } else if (status == 6 && dataType == 1) {
      setState(() {
        playAlg = 1;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArrivedInPassenger(
                userData: widget.userData,
                trajectoryData: widget.trajectory,
                withPassenger: true)),
      );
    }
  }

  void _goToMappy() async {
    var coordinate = (widget.trajectory[0]['d_latitude']).toString() +
        ',' +
        (widget.trajectory[0]['d_latitude']).toString() +
        ',' +
        (widget.trajectory[0]['a_latitude']).toString() +
        ',' +
        (widget.trajectory[0]['a_longitude']).toString();
    String url =
        "https://fr.mappy.com/itineraire#/voiture/" + coordinate + "/car/16";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

  setClientData(data, type, idTrip) async {
    setState(() {
      tripId = idTrip;
      dataType = type;
      _trajectoryData = data;
      _departure.text = data['departure'];
      _arrival.text = data['arrival'];
      if (type == 0) {
        _clientData = data['driver'];
      } else {
        _clientData = data['passenger'];
      }
    });

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _departureCoord =
          LatLng(_trajectoryData['d_latitude'], _trajectoryData['d_longitude']);
      _arrivalCoord =
          LatLng(_trajectoryData['a_latitude'], _trajectoryData['a_longitude']);
    });
  }

  _sendPosition() {}

  @override
  void dispose() {
    playAlg = 1;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.trajectory);
    setClientData(
        widget.trajectory?[0], widget.trajectory?[1], widget.trajectory?[2]);
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
          child: Container(
            child: dataType == 1
                ? Container(
                    height: 80,
                    child: DriverTopMenu(),
                  )
                : Container(
                    height: 80,
                    child: PassengerTopMenu(),
                  ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Stack(children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: screenHeight - 100,
                    child: MapsOnlyScreen(
                      _departureCoord,
                      _arrivalCoord,
                      0.0,
                      14,
                      playAlg,
                      sendPosition: _sendPosition,
                    ),
                  ),
                  goWithClient
                      ? Positioned(
                          bottom: 40,
                          child: Container(
                            width: screenWidth,
                            child: Center(
                              child: Container(
                                width: 10 * screenWidth / 12,
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
                                child: Center(
                                    child: Column(
                                  children: [
                                    Row(children: [
                                      Container(
                                        width: 10 * screenWidth / 12,
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 3 * screenWidth / 24,
                                                height: 70,
                                                child: Center(
                                                  child: ClipOval(
                                                    child: Image.network(
                                                        GlobalUrl
                                                                .getGlobalImageUrl() +
                                                            _clientData[
                                                                'profil'],
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 9 * screenWidth / 24,
                                                height: 60,
                                                color: Colors.white,
                                                child: Center(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        _clientData[
                                                                'last_name'] +
                                                            ' ' +
                                                            _clientData['name'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Roboto-Bold',
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _goToMappy();
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
                                              child: Container(
                                                width: 5 * screenWidth / 12,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Naviguer vers Mappy",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Roboto-Bold',
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Image.asset(
                                                        'web/icons/go_mappy.png',
                                                        width: 15,
                                                        height: 15,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 8 * screenWidth / 12,
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 8 * screenWidth / 12,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      "En route vers...",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Montserrat-Mix',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 8 * screenWidth / 12,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      _arrival.text,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Montserrat-Bold',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 5 * screenWidth / 12,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _arrived(6);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                  "Arrivé",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto-Bold',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ]),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: screenWidth,
                          margin: EdgeInsets.only(top: screenHeight / 4),
                          child: Center(
                            child: Container(
                              width: 9 * screenWidth / 12,
                              height: 240,
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
                              child: Column(
                                children: [
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    margin: EdgeInsets.only(top: 10),
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'web/icons/car_left.png',
                                            width: 50,
                                            height: 20,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              dataType == 0
                                                  ? "Cliquez sur 'OK' lorsque vous avez trouvé votre conducteur. !"
                                                  : "Attendez le client, cliquez sur 'OK' lorsqu'il arrive !",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                fontFamily:
                                                    'Montserrat-Meddium',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 8 * screenWidth / 12,
                                      color: Colors.grey,
                                      height: 0.5,
                                    ),
                                  ),
                                  Row(children: [
                                    Container(
                                      width: 9 * screenWidth / 12,
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 3 * screenWidth / 24,
                                              height: 70,
                                              child: Center(
                                                child: ClipOval(
                                                  child: Image.network(
                                                      GlobalUrl
                                                              .getGlobalImageUrl() +
                                                          _clientData['profil'],
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 9 * screenWidth / 24,
                                              height: 60,
                                              color: Colors.white,
                                              child: Center(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      _clientData['last_name'] +
                                                          ' ' +
                                                          _clientData['name'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Roboto-Bold',
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Container(
                                              width: 6 * screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(
                                                        right: 3),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: appTheme,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.mail_outline,
                                                      color: appTheme,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: appTheme,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 80,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _arrived(5);
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
                                                "OK",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                ]),
              ),
            ),
    );
  }
}
