import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneVerification extends StatefulWidget {
  @override
  String code;
  Function resendCode;
  Function updateInfo;
  Function verify;

  PhoneVerification({
    super.key,
    required this.code,
    required this.resendCode,
    required this.updateInfo,
    required this.verify,
  });

  State<PhoneVerification> createState() => _PhoneVerification();
}

class _PhoneVerification extends State<PhoneVerification> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  bool uncorrectCode = false;
  final TextEditingController _code = TextEditingController();
  updateInfo() {
    widget.updateInfo("null");
  }

  verify() {
    if (_code.text == widget.code) {
      widget.verify("null");
      widget.verify;
    } else {
      print('code invalid');
    }
  }

  resendCode() {
    widget.resendCode("null");
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
      height: 350,
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: screenWidth,
              child: Center(
                child: Text(
                  "Votre code de validation",
                  style: TextStyle(
                    fontSize: 25,
                    color: appTheme,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat-Mix',
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //name
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: 9 * screenWidth / 12,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                              letterSpacing: 4.0,
                              decoration: TextDecoration.none,
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //name
                ],
              ),
            ),
            Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    updateInfo();
                  },
                  child: Text(
                    "Modifier les informations",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat-Mix',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 9 * screenWidth / 12,
              height: 50,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    verify();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      alignment: Alignment.center,
                      width: 6 * screenWidth / 12,
                      child: Text(
                        "VÉRIFIER",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: appTheme,
                  ),
                ),
              ),
            ),
            uncorrectCode
                ? Container(
                    width: 9 * screenWidth / 12,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Code invalidé.",
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
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: GestureDetector(
                  onDoubleTap: () {
                    resendCode();
                  },
                  child: Text(
                    "Renvoyer le code!",
                    style: TextStyle(
                      fontSize: 14,
                      color: appTheme,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat-Mix',
                    ),
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
