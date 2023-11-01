import 'dart:convert';

import 'package:flutter/material.dart';
import '../forgot_password/reset_password.dart';
import '../home_page/home_screen.dart';

import '../users/user_screen.dart';
import './data_helper.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;

  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  final TextEditingController _email = TextEditingController();

  Future<void> _login() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    final body = {
      "email": _email.text,
    };
    final res = await DataHelperForgotPassword.forgotPassword(body);
    if (res == '0' || res == '1') {
      if (res == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPassword()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  viderChamp() {
    _email.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 255),
      body: _isLoading
          ? Container(
              width: 500,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25.0),
                        child: Center(
                          child: Image.asset(
                            'web/icons/logo.png',
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                      Text(
                        "Réinitialiser le mot de passe",
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
                              margin: EdgeInsets.symmetric(vertical: 10.0),
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
                                        color: Colors.transparent, width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 9 * screenWidth / 12,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          width: 9 * screenWidth / 12,
                          child: ElevatedButton(
                            onPressed: () async {
                              _login();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                "ENVOYER",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Bold',
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: appTheme,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(top: 20.0),
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
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            "réinitialiser le mot de passe !",
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
    );
  }
}
