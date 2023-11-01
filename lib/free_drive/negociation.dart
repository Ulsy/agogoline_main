import 'package:flutter/material.dart';
import '../driver_passenger/driver_with_passenger.dart';
import '../global_screen/quiestion_page.dart';
import '../global_url.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import 'data_helper.dart';

// ignore: must_be_immutable
class Negociation extends StatefulWidget {
  List<dynamic> initialData;
  List<dynamic> tripAndDriver;
  Function validRate;
  dynamic statusAndRate;
  int tripId;
  int status;
  double newRate;
  int tripStatus;
  dynamic userData;
  Negociation(
      {required this.initialData,
      required this.newRate,
      required this.status,
      required this.tripStatus,
      required this.validRate,
      required this.tripId,
      required this.tripAndDriver,
      required this.userData});
  @override
  State<Negociation> createState() => _Negociation();
}

class _Negociation extends State<Negociation> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  List<dynamic>? _allData = [];
  double _refinedRate = 0;
  double _distance = 0;
  double _temps = 0;
  int _passengerNbr = 1;
  bool validateWaiting = false;
  int _status = 0;
  int _tripStatus = 0;
  double _newRate = 0.0;
  int _waiting = 0;
  bool diverProposition = false;
  int _trajectoryId = 0;
  bool questionPage = false;

  @override
  void didUpdateWidget(Negociation oldWidget) {
    if (widget.status != oldWidget.status) {
      setState(() {
        _status = widget.status;
      });
      if (_status == 1) {
        validateWaiting = false;
      }
      if (_status == 5) {
        diverProposition = true;
      }
    }
    if (widget.newRate != oldWidget.newRate) {
      setState(() {
        _newRate = widget.newRate;
      });
    }
    if (widget.tripStatus != oldWidget.tripStatus) {
      setState(() {
        _tripStatus = widget.tripStatus;
        if (_tripStatus == 4) {
          _goWithDriver();
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  void refineRate(value) {
    setState(() {
      if (value == 0) {
        _refinedRate--;
      } else {
        _refinedRate++;
      }
    });
  }

  void addPassenger(value) {
    setState(() {
      if (value == 0) {
        if (_passengerNbr > 1) {
          _passengerNbr--;
        }
      } else {
        _passengerNbr++;
      }
    });
  }

  Future<void> _validate(data, secondStatus) async {
    final body = {
      "status": data,
      "second_status": secondStatus,
      "rafined_rate": _refinedRate.toStringAsFixed(2),
    };
    var response = await DataHelperDriverFree.updateData(body, _trajectoryId);
    if (response == 1 && data == 5 && secondStatus == 0) {
      widget.validRate(_trajectoryId);
      setState(() {
        validateWaiting = true;
      });
    } else if (data == 2 || secondStatus == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
      );
    }
  }

  Future<void> _addData() async {
    final body = {
      "driver_id": _allData?[0]['id'],
      "passenger_id": _allData?[1]['passenger_id'],
      "status": 0,
      "second_status": 0,
      "departure": _allData?[1]['departure'],
      "d_latitude": _allData?[1]['d_latitude'],
      "d_longitude": _allData?[1]['d_longitude'],
      "driver_departure": _allData?[0]['driver_departure'],
      "driver_d_latitude": _allData?[0]['driver_d_latitude'],
      "driver_d_longitude": _allData?[0]['driver_d_longitude'],
      "arrival": _allData?[1]['arrival'],
      "a_latitude": _allData?[1]['a_latitude'],
      "a_longitude": _allData?[1]['a_longitude'],
      "datetime": _allData?[1]['datetime'],
      "price": (double.parse(_allData?[1]['price'])).toStringAsFixed(2),
      "distance": _distance,
      "rafined_rate": _refinedRate.toStringAsFixed(2),
      "passenge_nbr": _passengerNbr
    };
    var response = await DataHelperDriverFree.addData(body);
    if (response != {}) {
      widget.validRate(response['id']);
      setState(() {
        _trajectoryId = response['id'];
        validateWaiting = true;
      });
    }
  }

  _questionResponse(response) {
    if (response == 1) {
      if (_trajectoryId != 0) {
        _validate(2, 0);
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

  void _canceledByDriver() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
    );
  }

  void _goWithDriver() async {
    var data = [widget.tripAndDriver?[0], 0, widget.tripId];
    if (data[2] > 0 && data[1] == 0) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverWithPassenge(
                userData: widget.userData, trajectory: data)),
      );
    } else {
      await Future.delayed(Duration(seconds: 2));
      _goWithDriver();
    }
  }

  void _cancel() {
    setState(() {
      questionPage = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _allData = widget.initialData;
      _distance = double.parse(_allData?[1]['distance']);
      _refinedRate =
          double.parse(_allData?[0]['settings']['km_price']) * _distance;
      _temps = ((_distance / 30) * 60);
      _waiting = _allData?[1]['waitingDuration'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      // 1er bloc *******************************************
      Container(
        width: 10 * screenWidth / 12,
        padding: EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Container(
                width: 3 * screenWidth / 24,
                height: 50,
                child: Center(
                  child: ClipOval(
                    child: Image.network(
                        GlobalUrl.getGlobalImageUrl() + _allData?[0]['profil'],
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                width: 11 * screenWidth / 24,
                height: 50,
                color: Colors.white,
                child: Column(children: [
                  Container(
                    height: 16,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _allData?[0]['last_name'] +
                              ' ' +
                              _allData?[0]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Montserrat-Bold',
                          ),
                        )),
                  ),
                  _allData?[0]['star_number'] > 0
                      ? Container(
                          width: 11 * screenWidth / 24,
                          height: 16,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (_allData?[0]['star_number']),
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 15.0,
                              );
                            },
                          ),
                        )
                      : Container(),
                  Container(
                    width: 11 * screenWidth / 24,
                    height: 16,
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth / 6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'web/icons/car_left.png',
                              width: 30,
                              height: 12,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Container(
                width: 4.7 * screenWidth / 24,
                height: 50,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        Icons.mail_outline,
                        color: appTheme,
                        size: 22.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: appTheme,
                        borderRadius: BorderRadius.circular(50.0),
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
        ),
      ),
      // 1er bloc *******************************************
      // 2em bloc *******************************************
      Container(
        width: 10 * screenWidth / 12,
        height: 400,
        margin: EdgeInsets.only(top: 80),
        padding: EdgeInsets.all(10),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 18.75 * screenWidth / 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        alignment: Alignment.centerLeft,
                        width: 2 * screenWidth / 48,
                        child: Icon(
                          Icons.access_time_rounded,
                          color: appTheme,
                          size: 30.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 14 * screenWidth / 48,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "TEMPS TRAJET",
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
                              child: Row(
                                children: [
                                  Text(
                                    _temps.toStringAsFixed(0) + " min",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat-Medium',
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
                Container(
                  width: 18.75 * screenWidth / 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        alignment: Alignment.centerLeft,
                        width: 1 * screenWidth / 24,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: appTheme,
                          size: 30.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 14 * screenWidth / 48,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "DISTANCE",
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
                              child: Row(
                                children: [
                                  Text(
                                    _distance.toStringAsFixed(2) + " km",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat-Medium',
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
              ],
            ),
            //###############TARIFS#############
            validateWaiting
                ? Container()
                : Row(
                    children: [
                      Container(
                        width: 18.75 * screenWidth / 48,
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              alignment: Alignment.centerLeft,
                              width: 3 * screenWidth / 48,
                              child: Container(
                                  child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: appTheme,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.euro_symbol,
                                  color: appTheme,
                                  size: 10.0,
                                ),
                              )),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 14 * screenWidth / 48,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "TARIF",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 14 * screenWidth / 48,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          (_distance *
                                                  double.parse(_allData?[0]
                                                      ['settings']['km_price']))
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(int.parse("FFB406",
                                                    radix: 16))
                                                .withAlpha(255),
                                            fontFamily: 'Montserrat-Medium',
                                          ),
                                        ),
                                        Icon(
                                          Icons.euro_symbol,
                                          color: Color(int.parse("FFB406",
                                                  radix: 16))
                                              .withAlpha(255),
                                          size: 14.0,
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
                        width: 18.75 * screenWidth / 48,
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _status == 0
                                ? Container(
                                    width: 17 * screenWidth / 48,
                                    height: 70,
                                    margin: EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 17 * screenWidth / 48,
                                          padding:
                                              EdgeInsets.only(top: 15, left: 7),
                                          alignment: Alignment.centerLeft,
                                          color: Colors.white,
                                          child: Text(
                                            "AFFINER LE TARIF?",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Montserrat-Bold',
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (17 * screenWidth / 48) - 15,
                                          alignment: Alignment.centerLeft,
                                          height: 40,
                                          child: Center(
                                            child: Container(
                                              width: 15 * screenWidth / 48,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      width:
                                                          3 * screenWidth / 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            refineRate(0);
                                                          },
                                                          child: Text(
                                                            "-",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Montserrat-Medium',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        8.7 * screenWidth / 48,
                                                    child: Center(
                                                      child: Text(
                                                        _refinedRate
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat-Medium',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 3 *
                                                            screenWidth /
                                                            48,
                                                        child: Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              refineRate(1);
                                                            },
                                                            child: Text(
                                                              "+",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-Medium',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 17 * screenWidth / 48,
                                    height: 60,
                                    padding: EdgeInsets.only(left: 10),
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "TARIF ACCEPTÉ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Montserrat-Bold',
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Text(
                                                (_newRate).toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: appTheme,
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
                    ],
                  ),
            //###############TARIFS#############
            //###############PASSAGERS#############
            validateWaiting
                ? Container(
                    child: diverProposition
                        ? Container(
                            width: 10 * screenWidth / 12,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    width: 300,
                                    child: Text(
                                      (_tripStatus == 0
                                          ? "Votre conducteur est en route il arrivera dans " +
                                              _waiting.toString() +
                                              " min"
                                          : (_tripStatus == 4
                                              ? "Votre conducteur est en route il arrivera dans " +
                                                  _waiting.toString() +
                                                  " min"
                                              : "Le conducteur a annulé la course")),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: 10 * screenWidth / 12,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 10 * screenWidth / 12,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Icon(
                                      Icons.timer,
                                      size: 25.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    width: 9 * screenWidth / 12,
                                    child: Text(
                                      "Tarif en attente de validation du  conducteur...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat-Medium',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                : Row(
                    children: [
                      Container(
                        width: screenWidth / 2,
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Container(
                            //   padding: EdgeInsets.only(top: 5),
                            //   alignment: Alignment.topLeft,
                            //   width: 3 * screenWidth / 48,
                            //   height: 60,
                            //   child: Container(
                            //     child: Container(
                            //       padding: EdgeInsets.all(5),
                            //       decoration: BoxDecoration(
                            //         border: Border.all(
                            //           color: appTheme,
                            //           width: 2.0,
                            //         ),
                            //         borderRadius: BorderRadius.circular(50.0),
                            //       ),
                            //       child: Icon(
                            //         Icons.people,
                            //         color: appTheme,
                            //         size: 10.0,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: 8 * screenWidth / 24,
                              height: 60,
                              padding: EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "PASSAGERS",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                  _status == 1
                                      ? Container(
                                          width: 8 * screenWidth / 24,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _passengerNbr.toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat-Medium',
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 8 * screenWidth / 24,
                                          height: 40,
                                          child: Center(
                                            child: Container(
                                              width: 8 * screenWidth / 24,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      width:
                                                          3 * screenWidth / 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            addPassenger(0);
                                                          },
                                                          child: Text(
                                                            "-",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Montserrat-Medium',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 9 * screenWidth / 48,
                                                    child: Center(
                                                      child: Text(
                                                        _passengerNbr
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat-Medium',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      width:
                                                          3 * screenWidth / 48,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 3 *
                                                            screenWidth /
                                                            48,
                                                        child: Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              addPassenger(1);
                                                            },
                                                            child: Text(
                                                              "+",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-Medium',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
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
                    ],
                  ),
            //###############PASSAGERS#############

            //###############BOUTON ACION######
            Container(
              width: 10 * screenWidth / 12,
              child: Align(
                alignment: Alignment.center,
                // child: Center(
                child: Row(
                  children: [
                    Container(
                      width: validateWaiting
                          ? 18.75 * screenWidth / 24
                          : screenWidth / 2.35,
                      margin: EdgeInsets.only(top: 15),
                      child: Center(
                        child: diverProposition
                            ? ElevatedButton(
                                onPressed: () {
                                  _tripStatus == 0
                                      ? _validate(5, 3)
                                      : (_tripStatus == 4
                                          ? _validate(5, 3)
                                          : _canceledByDriver());
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
                                  width: _tripStatus == 0
                                      ? 200
                                      : (_tripStatus == 4 ? 100 : 50),
                                  child: Text(
                                    _tripStatus == 0
                                        ? "ANNULER LA COURSE"
                                        : (_tripStatus == 4
                                            ? "ANNULER LA COURSE"
                                            : "Ok"),
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
                            : Container(
                                alignment: validateWaiting
                                    ? Alignment.center
                                    : Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                  bottom: 2,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _cancel();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.white),
                                  child: Container(
                                    width: 11 * screenWidth / 48,
                                    child: Text(
                                      "ANNULER",
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
                    ),
                    validateWaiting
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: 16),
                            width: 4.3 * screenWidth / 12,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  _status == 1 ? _validate(5, 0) : _addData();
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
                                child: _status == 1
                                    ? Container(
                                        width: 11 * screenWidth / 48,
                                        child: Text(
                                          "Ok",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 11 * screenWidth / 48,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "VALIDER ",
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
                                              child: Image.asset(
                                                  'web/icons/validate.png',
                                                  width: 20,
                                                  height: 14,
                                                  fit: BoxFit.cover),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              // ),
            ),
            //###############BOUTON ACTION#####
          ],
        ),
      ),
      // 2em bloc *******************************************
      questionPage
          ? QuestionPage(
              parametter: {
                'text': "Êtes-vous sûr(e) de vouloir annuler la course ?",
                'type': 1,
              },
              response: _questionResponse,
            )
          : Container(),
    ]);
  }
}
