import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../global_screen/quiestion_page.dart';
import '../global_url.dart';
import '../passanger_trajectory/passenger_trajectory.dart';

class DriverWaitingFrom extends StatefulWidget {
  String textContent;
  dynamic driver;
  Function cancelTrip;
  Function getWithDriver;
  Function goToMappy;
  int status;
  DriverWaitingFrom({
    super.key,
    required this.textContent,
    required this.driver,
    required this.cancelTrip,
    required this.goToMappy,
    required this.status,
    required this.getWithDriver,
  });
  @override
  State<DriverWaitingFrom> createState() => _DriverWaitingFromState();
}

class _DriverWaitingFromState extends State<DriverWaitingFrom> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int paymentMode = 1;
  bool questionPage = false;

  void getPaymentMode(value) {
    setState(() {
      paymentMode = value;
    });
  }

  _questionResponse(value) {
    if (value == 1) {
      widget.cancelTrip();
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  void _cancelTrip() {
    widget.cancelTrip(paymentMode);
  }

  goWithDriver() {
    widget.getWithDriver();
  }

  _goToMappy() {
    widget.goToMappy();
  }

  gotTonHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerTrajectory(null),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: questionPage
          ? QuestionPage(
              parametter: {
                'text': "Êtes-vous sûr(e) de vouloir annuler la course ?",
                'type': 1,
              },
              response: _questionResponse,
            )
          : Container(
              height: screenHeight,
              width: screenWidth,
              child: widget.status == 0
                  ? Stack(
                      children: [
                        Positioned(
                          bottom: 30,
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Container(
                              width: 10 * screenWidth / 12,
                              padding: EdgeInsets.all(10),
                              height: 220,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 7 * screenWidth / 48,
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Image.network(
                                                GlobalUrl.getGlobalImageUrl() +
                                                    widget.driver['profil'],
                                                width: 45,
                                                height: 45,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10 * screenWidth / 24,
                                        height: 50,
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 16,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                widget.driver['name'] +
                                                    " " +
                                                    widget.driver['last_name'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontFamily: 'Montserrat-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 16,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: (widget
                                                    .driver['star_number']),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Icon(
                                                    Icons.star,
                                                    color: Colors.yellow[700],
                                                    size: 15.0,
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: 16,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      'web/icons/car_left.png',
                                                      width: 30,
                                                      height: 12,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 5 * screenWidth / 24,
                                        height: 50,
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(right: 3),
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
                                                size: 22.0,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Container(
                              width: 10 * screenWidth / 12,
                              height: 150,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                                BorderRadius.circular(10.0),
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
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
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
                                    alignment: Alignment.center,
                                    width: 15 * screenWidth / 24,
                                    child: Text(
                                      widget.textContent,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            questionPage = true;
                                          });
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
                                          width: 5 * screenWidth / 12,
                                          child: Text(
                                            "ANNULER",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Roboto-Bold',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : widget.status == 4
                      ? Stack(
                          children: [
                            Positioned(
                              top: (screenHeight / 2) - 200,
                              child: Container(
                                width: screenWidth,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 9 * screenWidth / 12,
                                  height: 250,
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 9 * screenWidth / 12,
                                            child: Image.asset(
                                              'web/icons/car_left.png',
                                              width: 50,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        width: 15 * screenWidth / 24,
                                        child: Text(
                                          widget.textContent,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        width: 8 * screenWidth / 12,
                                        height: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 3 * screenWidth / 24,
                                              padding: EdgeInsets.all(10),
                                              child: ClipOval(
                                                child: Image.network(
                                                    GlobalUrl
                                                            .getGlobalImageUrl() +
                                                        widget.driver['profil'],
                                                    width: 50,
                                                    height: 35,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            Container(
                                              width: 9 * screenWidth / 24,
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                widget.driver['name'] +
                                                    " " +
                                                    widget.driver['last_name'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontFamily: 'Montserrat-Bold',
                                                ),
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
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              goWithDriver();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: appTheme,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: appTheme),
                                            child: Container(
                                              width: 3 * screenWidth / 12,
                                              child: Text(
                                                "OK",
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned(
                              bottom: 20,
                              child: Container(
                                width: screenWidth,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 9 * screenWidth / 12,
                                  height: 200,
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 3 * screenWidth / 24,
                                            margin: EdgeInsets.only(left: 45),
                                            child: ClipOval(
                                              child: Image.network(
                                                GlobalUrl.getGlobalImageUrl() +
                                                    widget.driver['profil'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 3 * screenWidth / 24,
                                            margin: EdgeInsets.only(right: 45),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'web/icons/cancel_red.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        width: 15 * screenWidth / 24,
                                        child: Text(
                                          widget.driver['name'] +
                                              " " +
                                              widget.driver['last_name'] +
                                              widget.textContent,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              gotTonHome();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: appTheme,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: appTheme),
                                            child: Container(
                                              width: 3 * screenWidth / 12,
                                              child: Text(
                                                "OK",
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
    );
  }
}
