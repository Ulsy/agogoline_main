import 'dart:convert';

import 'package:flutter/material.dart';
import '../driver_menu/data_helper.dart';
import '../global_screen/trajectory_story.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../info_page/good_deal.dart';
import '../info_page/how_it_work.dart';
import '../info_page/politique.dart';
import '../info_page/sponsor.dart';
import '../info_page/cgu_cgv.dart';
import '../passanger_trajectory/passenger_trajectory.dart';

class AppMenu extends StatefulWidget {
  @override
  State<AppMenu> createState() => _AppMenu();
}

class _AppMenu extends State<AppMenu> {
  dynamic _userConnected = {};
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  int _deconnectionValue = 0;

  Future<void> _closeMenu() async {
    Navigator.pop(context);
  }

  void trajectoryStory() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrajctoryStory(userData: _userConnected)),
    );
  }

  void howDoesItWork() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HowItDoesWork()),
    );
  }

  goToCguCgv() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CguCgv()),
    );
  }

  goPolitique() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Politique()),
    );
  }

  void goodDeal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoodDeal()),
    );
  }

  void sponsorFriend() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Sponsor()),
    );
  }

  Future<void> _deconnection() async {
    if (_deconnectionValue > 0) {
      await DataHelperMenu.deleteData(_deconnectionValue);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
        _deconnectionValue = data[0]['id'];
      });
    }
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
      backgroundColor: appTheme,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 100),
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight - 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Center(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 4 * screenWidth / 6,
                                height: 100,
                                margin: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                  child: Image.asset(
                                      'web/icons/agogolines_menu.png',
                                      width: 121,
                                      height: 96,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 12),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PassengerTrajectory(null)),
                                        );
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Image.asset(
                                                  'web/icons/car_left.png',
                                                  width: 20,
                                                  height: 10,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Réserver une course",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile

                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 11),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        trajectoryStory();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Image.asset(
                                                  'web/icons/history.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Historique des trajets",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 11),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        sponsorFriend();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Image.asset(
                                                  'web/icons/gift-box.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Parrainer des amis",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 11),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        goodDeal();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Image.asset(
                                                  'web/icons/sale.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Bons plans",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 11),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        goToCguCgv();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Image.asset(
                                                  'web/icons/document.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "CGU/CGV",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        howDoesItWork();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Image.asset(
                                                  'web/icons/info.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Comment ça marche ?",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        goPolitique();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              child: Image.asset(
                                                  'web/icons/closed.png',
                                                  width: 25,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Politique de confidentialité",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                              //profile
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 19 * screenWidth / 24,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 11),
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _deconnection();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18,
                                              child: Image.asset(
                                                  'web/icons/turn-off.png',
                                                  width: 10,
                                                  height: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            Container(
                                              width: 33 * screenWidth / 48,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Déconnexion",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth / 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.0,
                                                    color: Colors.grey,
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
                              //profile
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        width: screenWidth,
                        height: 180,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-bold"),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        alignment: Alignment.topLeft,
                        height: 100,
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(vertical: 62),
                        padding: EdgeInsets.only(left: 15),
                        child: IconButton(
                          onPressed: () async {
                            _closeMenu();
                          },
                          iconSize: 35,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
