import 'dart:convert';

import 'package:flutter/material.dart';
import '../car/car_list.dart';
import '../driver_settings/driver_settings.dart';
import '../driver_trajectory/course_confirmation.dart';
import '../driver_trips/driver_trips.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import 'data_helper.dart';
import '../global_url.dart';

class DriverMenu extends StatefulWidget {
  @override
  State<DriverMenu> createState() => _DriverMenu();
}

class _DriverMenu extends State<DriverMenu> {
  bool _isLoading = true;
  Map<String, dynamic> _userConnected = {};
  Color blueColors = Color.fromARGB(255, 101, 90, 169);

  int _selectedValue = 1;
  int _deconnectionValue = 0;

  Future<void> _closeMenu() async {
    Navigator.pop(context);
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

  Future<void> _handleRadioValueChanged(int value) async {
    setState(() {
      _selectedValue = value;
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
      backgroundColor: blueColors,
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
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
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
                                      width: screenWidth / 1.37,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 25),
                                      padding: EdgeInsets.only(top: 40),
                                      child: Center(
                                        child: Text(
                                          _userConnected['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: blueColors,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: 5 * screenWidth / 6,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 3 * screenWidth / 12,
                                            child: Text(
                                              "Ajourd'hui",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 3.5 * screenWidth / 6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Trajet(1) restant(s): 1/2",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //Mon profil
                                    GestureDetector(
                                      onTap: () {
                                        // _deconnection();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.account_circle_outlined,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Mon profil",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //Mon profil
                                    //Mes documents
                                    GestureDetector(
                                      onTap: () {
                                        // _deconnection();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.description,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                              // child: Image.asset(
                                              //   'web/icons/identification.png',
                                              //   width: 20,
                                              //   height: 10,
                                              //   fit: BoxFit.cover,
                                              // ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Mes documents",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //Mes documents
                                    //Mes véhicule
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CarList(
                                                  userData: _userConnected)),
                                        );
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.car_crash_rounded,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                              // child: Image.asset(
                                              //   'web/icons/car_left.png',
                                              //   width: 40,
                                              //   height: 20,
                                              //   fit: BoxFit.cover,
                                              // ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Mes véhicules",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //Mes documents

                                    //Proposer un trajet
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DriverTrips()),
                                        );
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.add_location_alt_outlined,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Mes trajets ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseConfirmation()),
                                        );
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.car_rental_rounded,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Réservation en cours",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               PassengerTrajectory(null)),
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     width: 5*screenWidth /6,
                                    //     margin:
                                    //         EdgeInsets.symmetric(vertical: 10),
                                    //     child: Row(
                                    //       children: [
                                    //         Container(
                                    //          width: 25,
                                    //           child: Icon(
                                    //             Icons.car_rental_rounded,
                                    //             size: 25.0,
                                    //             color: blueColors,
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //          width: 3*screenWidth /6,
                                    //           child: Text(
                                    //             "Réserver une course",
                                    //             style: TextStyle(
                                    //               fontSize: 18,
                                    //               color: Colors.grey,
                                    //               fontWeight: FontWeight.w500,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //          width: 3*screenWidth /12,
                                    //           child: Row(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.end,
                                    //             children: [
                                    //               Icon(
                                    //                 Icons.arrow_forward_ios,
                                    //                 size: 25.0,
                                    //                 color: Colors.grey,
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //rechercher un trajet
                                    //Parametre
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DriverSettings(
                                                      userData:
                                                          _userConnected)),
                                        );
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.settings_outlined,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Paramètres",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    //Parametre
                                    //deconnexion
                                    GestureDetector(
                                      onTap: () {
                                        _deconnection();
                                      },
                                      child: Container(
                                        width: 5 * screenWidth / 6,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              child: Icon(
                                                Icons.power_settings_new,
                                                size: 25.0,
                                                color: blueColors,
                                              ),
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Text(
                                                "Déconnexion",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto-Bold',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2 * screenWidth / 12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 25.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 5 * screenWidth / 6,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
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
                        // Row(
                        //   children: [
                        //     Container(
                        //       width: 25,
                        //       height: 200,
                        //       color: Colors.transparent,
                        //     ),
                        //     Container(
                        //       width: 9 * screenWidth / 12,
                        //       height: 200,
                        //       color: Colors.transparent,
                        //       child: Center(
                        //         child: Text(
                        //           'PROFIL',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 25,
                        //       height: 200,
                        //       color: Colors.transparent,
                        //       child: Center(
                        //         child: IconButton(
                        //           onPressed: () async {
                        //             _closeMenu();
                        //           },
                        //           iconSize: 35,
                        //           icon: Icon(
                        //             Icons.close,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: screenWidth,
                              height: 200,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  'PROFIL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              alignment: Alignment.topRight,
                              height: 100,
                              color: Colors.transparent,
                              margin: EdgeInsets.symmetric(vertical: 50),
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
                              offset: Offset(0, -80),
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
