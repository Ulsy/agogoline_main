import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_screen/quiestion_page.dart';
import '../passenger_menu/passenger_top_menu.dart';
import '../payment/paymentChoiseBg.dart';
import './driver_response.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../location/maps_only_screen.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import 'data_helper.dart';
import 'free_driver_list.dart';
import 'negociation.dart';

class FreeDriver extends StatefulWidget {
  Map<String, dynamic>? initialData;
  FreeDriver(this.initialData);
  @override
  State<FreeDriver> createState() => _FreeDriver();
}

class _FreeDriver extends State<FreeDriver> {
  Map<String, dynamic> _userConnected = {};
  bool _isLoading = true;
  bool departurOrArrival = true;
  bool _driverResponse = false;
  int _tripId = 0;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  GoogleMapController? mapController;

  List<dynamic> _allData = [];
  List<dynamic> _tripAndDriver = [];
  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _distance = TextEditingController();
  final TextEditingController _temps = TextEditingController();
  final TextEditingController _price = TextEditingController();
  int _status = 0;
  int _tripStatus = -1;
  double _newRate = 0.0;
  double positionY = 0.0;
  double dragValue = 0.0;
  int waiting = 0;
  int trajectoryId = 0;
  LatLng _departureCoord = LatLng(-18.8791902, 47.5079055);
  LatLng _arrivalCoord = LatLng(-18.7791902, 47.5079055);
  bool _negociation = false;
  bool questionPage = false;
  List<dynamic> negociationData = [];

  bool playAlg = true;
  void dispose() {
    playAlg = false;
    super.dispose();
  }

  void testState(data, response) {
    if (response.length > 0) {
      var status = response[0]['status'];
      setState(() {
        _tripAndDriver = response;
      });
      switch (status) {
        case 0:
          RefreshRate(data);
          break;
        case 1:
          setState(() {
            _newRate = double.parse((response[0]['rafined_rate'].toString()));
            _status = 1;
          });
          break;
        case 2:
          setState(() {
            playAlg = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
          );
          break;
        case 4:
          setState(() {
            trajectoryId = response[0]['id'];
            _status = 4;
            _driverResponse = true;
          });
          RefreshRate(data);
          break;
        case 3:
          setState(() {
            playAlg = false;
          });
          setState(() {
            _status = 4;
            _driverResponse = true;
          });
          break;
        case 5:
          setState(() {
            playAlg = false;
          });
          setState(() {
            _status = 5;
            _driverResponse = true;
          });
          break;
      }
    }
  }

  void RefreshRate(data) async {
    await Future.delayed(Duration(seconds: 3));
    var response = await DataHelperDriverFree.getOneDiscussion(data);
    print(response);
    if (playAlg == true) {
      testState(data, response);
    }
  }

  Future<void> _validate(data, secondStatus) async {
    final body = {
      "status": data,
      "second_status": secondStatus,
      "rafined_rate": _newRate.toStringAsFixed(2),
    };
    await DataHelperDriverFree.updateData(body, trajectoryId);
    if (data == 4 && secondStatus == 1) {
      setState(() {
        playAlg = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (data == 5 && secondStatus == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentChoiseBg(
              trajectory: _tripAndDriver[0], userData: _userConnected),
        ),
      );
    }
  }

  _validateConfirmation(data) {
    if (data == 5) {
      _validate(5, 0);
    } else if (data == 4) {
      setState(() {
        questionPage = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentChoiseBg(
              trajectory: _tripAndDriver[0], userData: _userConnected),
        ),
      );
    }
  }

  void getNegociationPage(index) {
    setState(() {
      waiting = int.parse(
          ((_allData[index][0]['driver_passenger_distance'] / 30) * 60)
              .toStringAsFixed(0));
    });
    DateTime maintenant = DateTime.now();
    setState(() {
      negociationData = [];
      negociationData.add(_allData[index][0]);
      negociationData.add({
        "passenger_id": _userConnected['id'],
        "departure": _departure.text,
        "d_latitude": _departureCoord.latitude,
        "d_longitude": _departureCoord.longitude,
        "arrival": _arrival.text,
        "a_latitude": _arrivalCoord.latitude,
        "a_longitude": _arrivalCoord.longitude,
        "datetime": maintenant.toIso8601String(),
        "distance": _distance.text,
        "price": _price.text,
        "temps": _temps.text,
        "waitingDuration": waiting,
      });
      _negociation = true;
    });
  }

  closeNegociation() {
    setState(() {
      _negociation = false;
    });
  }

  getSearchInput(dataType, type) {
    setState(() {
      departurOrArrival = dataType;
    });
  }

  Future<int> _refreshUser() async {
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
    return 0;
  }

  void changePlace(instantIndex) async {
    List<dynamic> index = _allData;
    dynamic thirdElement = index[instantIndex];
    setState(() {
      index.removeAt(instantIndex);
      _allData = [];
    });

    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        index.add(thirdElement);
        _allData = index;
      });
    });
  }

  void changePlaceGesture(data) async {
    positionY = 0;
    List<dynamic> thirdElement = data[2];
    data.removeAt(2);
    await Future.delayed(Duration.zero);
    setState(() {
      data.insert(0, thirdElement);
      _allData = data;
    });
  }

  Future<void> _addData() async {
    DateTime maintenant = DateTime.now();
    final body = {
      "driver_id": _allData?[0]['id'],
      "passenger_id": _userConnected['id'],
      "departure": _departure.text,
      "d_latitude": widget.initialData?['departure'].latitude,
      "d_longitude": widget.initialData?['departure'].longitude,
      "arrival": _arrival.text,
      "a_latitude": widget.initialData?['arrival'].latitude,
      "a_longitude": widget.initialData?['arrival'].longitude,
      "datetime": maintenant.toIso8601String(),
      "distance": double.parse(_distance.text),
      "price": double.parse(_price.text)
    };
    await DataHelperDriverFree.addData(body);
  }

  _questionResponse(response) {
    if (response == 1) {
      if (trajectoryId != 0) {
        _validate(4, 1);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
        );
      }
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  void cancel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
    );
  }

  void testCoordinate() async {
    final data = widget.initialData;
    setState(() {
      _departureCoord = LatLng(
          data?['journey']['lat_departure'], data?['journey']['log_departure']);
      _arrivalCoord = LatLng(
          data?['journey']['lat_arrival'], data?['journey']['log_arrival']);
    });
  }

  void setValue(data) {
    setState(() {
      _departure.text = data['adress_dep'];
      _arrival.text = data['adress_arr'];
      _distance.text = data['distance'];
      _temps.text =
          ((double.parse(data['distance']) / 30) * 60).toStringAsFixed(2) +
              " min";
    });
  }

  void treatPrice(driverInfo) async {
    final price = await double.parse(driverInfo[0]['settings']['km_price']);
    setState(() {
      _price.text = (price * double.parse(_distance.text)).toStringAsFixed(2);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 2), () {
          testCoordinate();
        });
      });
    });
  }

  void _refreshData(initialData) async {
    List<dynamic> data = await DataHelperDriverFree.getAllData(initialData);
    setState(() {
      _allData = data;
      _isLoading = false;
      treatPrice(data?[0]);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();
    if (widget.initialData != null && widget.initialData != {}) {
      dynamic data = widget.initialData;
      setValue(data['journey']);
      setState(() {
        _allData = data['data'];
        treatPrice(data?['data'][0]);
      });
      // _refreshData(data);
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
              child: Stack(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: MapsOnlyScreen(_departureCoord, _arrivalCoord, 0.0),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight,
                      child: Column(
                        children: [
                          Container(
                              width: 10 * screenWidth / 12,
                              height: screenHeight / 1.2,
                              child: Stack(children: [
                                Positioned(
                                  top: _negociation ? null : 80,
                                  bottom: _negociation ? 10 : null,
                                  child: SingleChildScrollView(
                                    child: _negociation
                                        ? Center(
                                            child: Container(
                                              width: screenWidth / 1.175,
                                              height: 350,
                                              child: Negociation(
                                                  initialData: negociationData,
                                                  tripAndDriver: _tripAndDriver,
                                                  newRate: _newRate,
                                                  status: _status,
                                                  tripStatus: _tripStatus,
                                                  tripId: _tripId,
                                                  userData: _userConnected,
                                                  validRate: RefreshRate),
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            width: 10 * screenWidth / 12,
                                            height: 5 * screenHeight / 10,
                                            child: ListView.builder(
                                              itemCount: _allData.length,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: FreeDriverList(
                                                    initialData:
                                                        _allData[index],
                                                    index: index,
                                                    distance: _distance.text,
                                                    chooseData:
                                                        getNegociationPage),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),

                                // 1er bloc *******************************************
                                // 3er bloc *******************************************
                                // Container(
                                //   width: screenWidth / 1.175,
                                //   height: 125,
                                //   margin: EdgeInsets.only(top: 30),
                                //   padding: EdgeInsets.only(top: 2),
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(15),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.grey.withOpacity(0.1),
                                //         spreadRadius: 5,
                                //         blurRadius: 10,
                                //         offset: Offset(0, 3),
                                //       ),
                                //     ],
                                //   ),
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         child: Row(
                                //           children: [
                                //             Container(
                                //               width: 70,
                                //               height: 120,
                                //               child: Center(
                                //                 child: Transform.translate(
                                //                   offset: Offset(0, -4),
                                //                   child: Image.asset(
                                //                       'web/icons/departdestination.png',
                                //                       width: 25,
                                //                       height: 100,
                                //                       fit: BoxFit.cover),
                                //                 ),
                                //               ),
                                //             ),
                                //             Container(
                                //               width: 250,
                                //               child: Transform.translate(
                                //                 offset: Offset(0, -2),
                                //                 child: Column(
                                //                   children: [
                                //                     Container(
                                //                       child: Column(
                                //                         children: [
                                //                           Row(
                                //                             mainAxisAlignment:
                                //                                 MainAxisAlignment
                                //                                     .start,
                                //                             children: [
                                //                               Text(
                                //                                 "DÉPART",
                                //                                 style: TextStyle(
                                //                                   fontSize: 15,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .w500,
                                //                                   color: Colors
                                //                                       .black,
                                //                                   fontFamily:
                                //                                       'Roboto-Bold',
                                //                                 ),
                                //                               ),
                                //                             ],
                                //                           ),
                                //                           SingleChildScrollView(
                                //                             scrollDirection:
                                //                                 Axis.horizontal,
                                //                             child: Align(
                                //                               alignment: Alignment
                                //                                   .centerLeft,
                                //                               child: Text(
                                //                                 _departure.text,
                                //                                 style: TextStyle(
                                //                                   fontSize: 15,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .w500,
                                //                                   color:
                                //                                       Colors.grey,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     Container(
                                //                       margin:
                                //                           EdgeInsets.symmetric(
                                //                               vertical: 10,
                                //                               horizontal: 10),
                                //                       width: 300,
                                //                       height: 0.5,
                                //                       color: Colors.grey,
                                //                     ),
                                //                     Container(
                                //                       width: 250,
                                //                       child: Column(
                                //                         children: [
                                //                           Container(
                                //                             child: Column(
                                //                               children: [
                                //                                 Row(
                                //                                   mainAxisAlignment:
                                //                                       MainAxisAlignment
                                //                                           .start,
                                //                                   children: [
                                //                                     Text(
                                //                                       "ARRIVÉE",
                                //                                       style:
                                //                                           TextStyle(
                                //                                         fontSize:
                                //                                             15,
                                //                                         fontWeight:
                                //                                             FontWeight
                                //                                                 .w500,
                                //                                         color: Colors
                                //                                             .black,
                                //                                         fontFamily:
                                //                                             'Roboto-Bold',
                                //                                       ),
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                                 SingleChildScrollView(
                                //                                   scrollDirection:
                                //                                       Axis.horizontal,
                                //                                   child: Text(
                                //                                     _arrival.text,
                                //                                     style:
                                //                                         TextStyle(
                                //                                       fontSize:
                                //                                           15,
                                //                                       fontWeight:
                                //                                           FontWeight
                                //                                               .w500,
                                //                                       color: Colors
                                //                                           .grey,
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // )
                                // 3er bloc *******************************************
                              ])),
                        ],
                      ),
                    ),
                  ),
                  _driverResponse
                      ? Opacity(
                          opacity: 0.7,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            color: Colors.white,
                          ))
                      : Container(),
                  _driverResponse
                      ? Container(
                          width: screenWidth,
                          height: screenHeight,
                          child: Center(
                            child: DriverResponse(
                              initialData: {
                                'temps': waiting.toString(),
                                'status': _status,
                              },
                              validateConfirmation: _validateConfirmation,
                            ),
                          ),
                        )
                      : Container(),
                  questionPage
                      ? QuestionPage(
                          parametter: {
                            'text':
                                "Êtes-vous sûr(e) de vouloir annuler la course ?",
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
