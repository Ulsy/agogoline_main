import 'dart:convert';

import 'package:flutter/material.dart';
import './data_helper.dart';
import '../home_page/home_screen.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isLoading = false;
  bool incorrectCode = false;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  final TextEditingController _code = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  Future<void> _login() async {
    final body = {
      "code": _code.text,
      "password": _newPassword.text,
    };
    final res = await DataHelperForgotPassword.resetPassword(body);
    print(res);
    if (res == '1') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      viderChamp();
    } else {
      setState(() {
        incorrectCode = true;
      });
    }
  }

  viderChamp() {
    _newPassword.clear();
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
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Container(
                              width: 9 * screenWidth / 12,
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                "Code de réinitialisation",
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
                              margin: EdgeInsets.only(bottom: 25),
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
                                controller: _code,
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
                            incorrectCode
                                ? Container(
                                    width: 9 * screenWidth / 12,
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "Code incorrect",
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
                              width: 9 * screenWidth / 12,
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                "Nouveau mot de passe",
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
                              margin: EdgeInsets.only(bottom: 25),
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
                                obscureText: true,
                                controller: _newPassword,
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
                                "RÉINITIALISER",
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
                        width: 500,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            "réinitialiser le mot de passe !",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.5,
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
