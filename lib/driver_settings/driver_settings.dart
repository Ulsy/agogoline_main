import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../confirmation/confirm_screen.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import 'data_helper.dart';

class DriverSettings extends StatefulWidget {
  dynamic userData;
  @override
  DriverSettings({required this.userData});
  State<DriverSettings> createState() => _DriverSettings();
}

class _DriverSettings extends State<DriverSettings> {
  bool _isLoading = false;
  bool _onlinePayment = false;
  bool _defaultOnlinePayment = false;
  bool _needStripeLink = false;
  bool _cashPayment = false;
  bool _editMode = false;
  int _parameterId = 0;

  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  final TextEditingController _kmPrice = TextEditingController();
  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  void _createLinkStripe() async {
    var response =
        await DataHelperDriverSetting.createLink(widget.userData['id']);
    if (response == 1) {
      if (_editMode) {
        Navigator.pop(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmScreen()),
        );
      }
    }
  }

  Future<void> _addData() async {
    final body = {
      "id": 0,
      "user_client_id": widget.userData['id'],
      "km_price": _kmPrice.text,
      "online_payment": _onlinePayment,
      "cash_payment": _cashPayment,
    };
    var response = await DataHelperDriverSetting.createDataBack(body);
    if (_onlinePayment) {
      setState(() {
        _needStripeLink = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmScreen()),
      );
    }
  }

  Future<void> _updateData() async {
    final body = {
      "id": 0,
      "user_client_id": widget.userData['id'],
      "km_price": _kmPrice.text,
      "online_payment": _onlinePayment,
      "cash_payment": _cashPayment,
    };
    await DataHelperDriverSetting.updateData(_parameterId, body);
    if (_onlinePayment && !_defaultOnlinePayment) {
      setState(() {
        _needStripeLink = true;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _getData(int id) async {
    final data = await DataHelperDriverSetting.getOneData(id);
    setState(() {
      _parameterId = data[0]['id'];
      _kmPrice.text = data[0]['km_price'];
      _onlinePayment = data[0]['online_payment'] == '1' ? true : false;
      _defaultOnlinePayment = data[0]['online_payment'] == '1' ? true : false;
      _cashPayment = data[0]['cash_payment'] == '1' ? true : false;
      _editMode = true;
      _isLoading = false;
    });
  }

  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    if (data.length != 0) {
      _getData(widget.userData['id']);
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
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
                              height: screenHeight - 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: _needStripeLink
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            margin: EdgeInsets.only(top: 100.0),
                                            child: Text(
                                              "Pour transférer vos gains, veuillez finaliser la configuration de votre compte Stripe en utilisant le lien que nous vous allons envoyé par email",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Medium',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 25),
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  _createLinkStripe();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(
                                                    "ENVOYER LE LIEN",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'Montserrat-Bold',
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 80),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  backgroundColor: appTheme,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //brand
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            padding: EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Prix / km (€) *",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            width: 9 * screenWidth / 12,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: TextField(
                                              controller: _kmPrice,
                                              style: TextStyle(
                                                fontSize: 13,
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                              decoration: new InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 0.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 0.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //brand
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 25),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            width: 9 * screenWidth / 12,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Espèce',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                      Checkbox(
                                                        value: _cashPayment,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            _cashPayment =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'En ligne',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                      Checkbox(
                                                        value: _onlinePayment,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            _onlinePayment =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            width: 3 * screenWidth / 6,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: Text(
                                              "* Champs obligatoires",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Medium',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 25),
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_editMode) {
                                                    _updateData();
                                                  } else {
                                                    _addData();
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(
                                                    "ENREGISTRER",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'Montserrat-Bold',
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 80),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  backgroundColor: appTheme,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 100,
                        margin: EdgeInsets.symmetric(vertical: 50),
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            'PARAMÈTRES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(vertical: 50),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
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
