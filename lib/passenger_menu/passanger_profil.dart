import 'dart:convert';

import 'package:flutter/material.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import 'data_helper.dart';
import '../global_url.dart';
import 'update_profile.dart';

class PassengerProfil extends StatefulWidget {
  @override
  State<PassengerProfil> createState() => _PassengerProfil();
}

class _PassengerProfil extends State<PassengerProfil> {
  bool _isLoading = true;
  Map<String, dynamic> _userConnected = {};
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  int _deconnectionValue = 0;

  Future<void> _closeMenu() async {
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PassengerTrajectory()),
    // );
  }

  updateProfile() {
    print("tato kosa e");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateProfil(userData: _userConnected)),
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
    _deconnectionValue = data[0]['id'];
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
      body: _isLoading
          ? CustomScrollView()
          : Container(
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
                                      width: screenWidth / 1.74,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 25),
                                      padding: EdgeInsets.only(top: 40),
                                      child: Center(
                                        child: Text(
                                          _userConnected['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: appTheme,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Montserrat-Meddium',
                                          ),
                                        ),
                                      ),
                                    ),
                                    //profile
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 19 * screenWidth / 24,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 12),
                                            height: 0.5,
                                            color: Colors.grey,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              updateProfile();
                                            },
                                            child: Container(
                                              width: 5 * screenWidth / 6,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    child: Image.asset(
                                                        'web/icons/user.png',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  Container(
                                                    width:
                                                        33 * screenWidth / 48,
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "Mon profile",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          Icons
                                                              .arrow_forward_ios,
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
                                    // Container(
                                    //   child: Column(
                                    //     children: [
                                    //       Container(
                                    //         width: 19 * screenWidth / 24,
                                    //         margin: EdgeInsets.symmetric(
                                    //             vertical: 12),
                                    //         height: 0.5,
                                    //         color: Colors.grey,
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {},
                                    //         child: Container(
                                    //           width: 5 * screenWidth / 6,
                                    //           padding: EdgeInsets.symmetric(
                                    //               vertical: 5),
                                    //           child: Row(
                                    //             children: [
                                    //               Container(
                                    //                 width: 25,
                                    //                 child: Image.asset(
                                    //                     'web/icons/setting.png',
                                    //                     width: 22,
                                    //                     height: 23,
                                    //                     fit: BoxFit.cover),
                                    //               ),
                                    //               Container(
                                    //                 width:
                                    //                     33 * screenWidth / 48,
                                    //                 margin: EdgeInsets.only(
                                    //                     left: 5),
                                    //                 child: Text(
                                    //                   "Paramètre",
                                    //                   style: TextStyle(
                                    //                     fontSize: 16,
                                    //                     color: Colors.grey,
                                    //                     fontWeight:
                                    //                         FontWeight.w500,
                                    //                     fontFamily:
                                    //                         'Montserrat-Medium',
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               Container(
                                    //                 width: screenWidth / 24,
                                    //                 child: Row(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.end,
                                    //                   children: [
                                    //                     Icon(
                                    //                       Icons
                                    //                           .arrow_forward_ios,
                                    //                       size: 16.0,
                                    //                       color: Colors.grey,
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // //profile
                                    //profile
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 19 * screenWidth / 24,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 12),
                                            height: 0.5,
                                            color: Colors.grey,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _deconnection();
                                            },
                                            child: Container(
                                              width: 5 * screenWidth / 6,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    child: Image.asset(
                                                        'web/icons/deconnexion.png',
                                                        width: 20,
                                                        height: 22,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  Container(
                                                    width:
                                                        33 * screenWidth / 48,
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "Déconnexion",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          Icons
                                                              .arrow_forward_ios,
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
                                  'PROFIL',
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
                              alignment: Alignment.topRight,
                              height: 100,
                              color: Colors.transparent,
                              padding: EdgeInsets.only(right: 15),
                              margin: EdgeInsets.symmetric(vertical: 63),
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
                        Container(
                          width: screenWidth,
                          child: Center(
                            child: Transform.translate(
                              offset: Offset(0, -100),
                              child: ClipOval(
                                child: Image.network(
                                    GlobalUrl.getGlobalImageUrl() +
                                        _userConnected['profil'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover),
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
    );
  }
}
