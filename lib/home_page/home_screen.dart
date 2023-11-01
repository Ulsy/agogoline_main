import 'dart:convert';

import 'package:flutter/material.dart';

import '../driver_menu/data_helper.dart';
import '../driver_trajectory/driver_trajectory.dart';
import '../forgot_password/forgot_password.dart';
import '../global_screen/loading_page.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import '../users/user_screen.dart';
import './data_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _userConnected = [];
  bool _isLoading = true;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool mailVerification = false;
  bool passwordVerification = false;
  bool tryToConnect = false;
  bool obscurePassword = true;
  showPassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  Future<void> _login() async {
    setState(() {
      tryToConnect = true;
      mailVerification = false;
      passwordVerification = false;
    });
    final body = {
      "email": _email.text,
      "password": _password.text,
    };
    final res = await DataHelperlogin.connexion(body);
    setState(() {
      tryToConnect = false;
    });
    if (res == '0' || res == '1') {
      if (res == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
        );
      }
      viderChamp();
    } else {
      if (res == 'email') {
        setState(() {
          mailVerification = true;
        });
      } else {
        setState(() {
          passwordVerification = true;
        });
      }
    }
  }

  viderChamp() {
    _email.clear();
    _password.clear();
  }

  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    print(data);
    if (data.length > 0) {
      String type = jsonDecode(data[0]['information'])['type'];
      if (type == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
        );
      }
    } else {
      _isLoading = false;
    }
    setState(() {
      _userConnected = data;
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
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      body: _isLoading
          ? Container(
              width: screenWidth,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Stack(
                children: [
                  // Positioned(
                  //   top: -115,
                  //   left: -10,
                  //   child: Container(
                  //     width: screenWidth,
                  //     child: Image.asset(
                  //       'web/icons/background.png',
                  //       height: screenHeight / 3,
                  //       width: screenWidth,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    width: screenWidth,
                    height: screenHeight - 10,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Center(
                                child: Image.asset(
                                  'web/icons/logo.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            Text(
                              "Connectez-vous",
                              style: TextStyle(
                                fontSize: 25,
                                color: appTheme,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Medium',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Montserrat-Medium',
                                      ),
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            mailVerification
                                ? Container(
                                    width: 9 * screenWidth / 12,
                                    margin: EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "Adresse e-mail introuvable",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Medium',
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Mot de passe",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 9 * screenWidth / 12,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 5),
                                          width: 9 * screenWidth / 12,
                                          child: GestureDetector(
                                            onTap: () {
                                              showPassword();
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  color: obscurePassword
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  size: 24.0,
                                                ),
                                                Positioned(
                                                  top: 12.0,
                                                  child: Transform.rotate(
                                                    angle:
                                                        -45 * 3.14159265 / 180,
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 2.0,
                                                      color: obscurePassword
                                                          ? Colors.grey
                                                          : Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 8 * screenWidth / 12,
                                          child: TextField(
                                            obscureText: obscurePassword,
                                            controller: _password,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Montserrat-Medium',
                                              decoration: TextDecoration.none,
                                            ),
                                            decoration: new InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0.0),
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
                            passwordVerification
                                ? Container(
                                    width: 9 * screenWidth / 12,
                                    margin: EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "Mot de passe incorrect",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Medium',
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword()),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1.5,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat-Medium',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 9 * screenWidth / 12,
                              height: 50,
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _login();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Container(
                                      width: 9 * screenWidth / 12,
                                      padding: EdgeInsets.only(right: 20),
                                      alignment: Alignment.center,
                                      child: Stack(
                                        children: [
                                          tryToConnect
                                              ? Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: 9 * screenWidth / 12,
                                                  height: 20,
                                                  child:
                                                      LoadingPage(bgColor: 0),
                                                )
                                              : Container(),
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "CONNEXION",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: appTheme,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 9 * screenWidth / 12,
                              margin: EdgeInsets.only(top: 15.0),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Screen()),
                                    );
                                  },
                                  child: Text(
                                    "Vous n'avez pas encore de compte ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: appTheme,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Medium',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              child: Center(
                                child: Text(
                                  "Inscrivez-vous !",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.5,
                                    fontFamily: 'Montserrat-Medium',
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
