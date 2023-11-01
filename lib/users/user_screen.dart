import 'dart:convert';
import 'dart:io';

import 'package:agogolines/users/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../message/send_message.dart';
import '../users/data_helper.dart';

import '../confirmation/confirm_screen.dart';
import '../driver_doc/driver_doc_screen.dart';
import '../home_page/home_screen.dart';

class Screen extends StatefulWidget {
  @override
  State<Screen> createState() => _Screen();
}

class _Screen extends State<Screen> {
  File? _image;
  PickedFile? _pickedFile;
  bool _isLoading = false;
  bool cameraOption = false;
  bool verifyCode = false;
  final _picker = ImagePicker();
  String base64String = "";

  Future<void> _pickImage() async {
    // _pickedFile = await _picker.getImage(source: ImageSource.camera);
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      print('tonga tatp');
      String imagePath = _pickedFile!.path;
      base64String = await imageToBase64(File(imagePath));
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int _selectedValue = 0;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _sponsorshipCode = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  bool uncorrectPhoneNumber = false;
  bool uncorrectEmail = false;
  FocusNode _focusNodePhone = FocusNode();
  FocusNode _focusNodeEmail = FocusNode();
  String _code = "";
  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  _updateInfo(value) {
    setState(() {
      verifyCode = false;
    });
  }

  testPhoneNumber() {
    var res = MessageService.sendMessage(_phoneNumber.text);
    print(res);
  }

  Future<void> _handleRadioValueChanged(int value) async {
    setState(() {
      _selectedValue = value;
    });
  }

  Future<void> _addData(value) async {
    final body = {
      "id": 0,
      "name": _name.text,
      "last_name": _lastName.text,
      "email": _email.text,
      "password": _password.text,
      'profil': base64String,
      "sponsorShipCode": 123, //_sponsorshipCode.text,
      "phone_number": "+33" + _phoneNumber.text,
      "state": 1,
      "type": _selectedValue
    };
    var response = await DataHelperUser.createDataBack(body);
    if (response['id'] > 0) {
      if (_selectedValue == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DriverDoc(userData: response)),
        );
      }
    } else {
      setState(() {
        verifyCode = false;
      });
    }
  }

  testPhone(value) async {
    var res = await DataHelperUser.generateOtpCode(
        {'phone_number': _phoneNumber.text});
    if (res == false) {
      setState(() {
        uncorrectPhoneNumber = true;
      });
    } else if (res['otp'] != 0) {
      setState(() {
        _code = (res['otp']).toString();
        verifyCode = true;
        uncorrectPhoneNumber = false;
      });
    }
  }

  testEmail() async {
    var res = await DataHelperUser.testEmail({'email': _email.text});
    if (res == 0) {
      setState(() {
        _focusNodeEmail.requestFocus();
        uncorrectEmail = true;
      });
    } else {
      setState(() {
        uncorrectEmail = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _focusNodePhone.addListener(() {
    //   if (!_focusNodePhone.hasFocus) {
    //     testPhone();
    //   }
    // });
    _focusNodeEmail.addListener(() {
      if (!_focusNodeEmail.hasFocus) {
        testEmail();
      }
    });
  }

  @override
  void dispose() {
    _focusNodePhone.dispose();
    _focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 255),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: verifyCode
                  ? Container(
                      height: screenHeight,
                      child: Center(
                          child: PhoneVerification(
                        code: _code,
                        resendCode: testPhone,
                        updateInfo: _updateInfo,
                        verify: _addData,
                      )),
                    )
                  : Container(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth,
                                margin: EdgeInsets.only(top: 60.0),
                                child: Center(
                                  child: Text(
                                    "Inscription",
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
                                width: screenWidth,
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: ClipOval(
                                    child: _pickedFile != null
                                        ? Image.file(File(_pickedFile!.path),
                                            width: 2 * screenWidth / 6,
                                            height: 2 * screenWidth / 6,
                                            fit: BoxFit.cover)
                                        : Image.asset('web/icons/Path.png',
                                            width: 2 * screenWidth / 6,
                                            height: 2 * screenWidth / 6,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () async {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Image.asset(
                                              'web/icons/add_picture.png',
                                              width: 16,
                                              height: 14,
                                              fit: BoxFit.cover),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: GestureDetector(
                                            onTap: () => _pickImage(),
                                            child: Text(
                                              "AJOUTER UNE PHOTO",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            color: Colors.grey, width: 2.0),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 253, 253, 255),
                                    ),
                                  ),
                                ),
                              ),
                              //driverOrClient

                              Container(
                                height: 40,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Passager',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 15, 15, 14),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    0, 156, 154, 154),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Radio(
                                              value: 0,
                                              groupValue: _selectedValue,
                                              onChanged: (value) {
                                                _handleRadioValueChanged(
                                                    value!);
                                              },
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              activeColor: Colors.white,
                                              visualDensity: VisualDensity(
                                                  horizontal: VisualDensity
                                                      .minimumDensity,
                                                  vertical: VisualDensity
                                                      .minimumDensity),
                                            ),
                                          ),
                                          Radio(
                                            value: 1,
                                            groupValue: _selectedValue,
                                            onChanged: (value) {
                                              _handleRadioValueChanged(value!);
                                            },
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            activeColor: Colors.white,
                                            visualDensity: VisualDensity(
                                                horizontal: VisualDensity
                                                    .minimumDensity,
                                                vertical: VisualDensity
                                                    .minimumDensity),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Conducteur',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //driverOrClient
                              //name
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
                                        "Nom *",
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
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: _name,
                                        style: TextStyle(
                                          fontSize: 13,
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
                              //name
                              //lastName
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
                                        "Prénom",
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
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: _lastName,
                                        style: TextStyle(
                                          fontSize: 13,
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
                              //lastName
                              //email
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
                                        "Email *",
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
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                        focusNode: _focusNodeEmail,
                                      ),
                                    ),
                                    uncorrectEmail
                                        ? Container(
                                            width: 9 * screenWidth / 12,
                                            margin: EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "Email inconnu.",
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
                                  ],
                                ),
                              ),
                              //email

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Téléphone *",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            height: 50,
                                            padding: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
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
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    child: Image.asset(
                                                        'web/icons/33.png',
                                                        width: 30,
                                                        height: 18,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        uncorrectPhoneNumber =
                                                            false;
                                                      });
                                                    },
                                                    child: TextField(
                                                      controller: _phoneNumber,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'Montserrat-Mix',
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                      decoration:
                                                          new InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0,
                                                          ),
                                                        ),
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      focusNode:
                                                          _focusNodePhone,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          uncorrectPhoneNumber
                                              ? Container(
                                                  width: 9 * screenWidth / 12,
                                                  margin:
                                                      EdgeInsets.only(top: 5.0),
                                                  child: Text(
                                                    "Numéro inconnu.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Montserrat-Medium',
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //phonNumber
                              //password
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
                                        "Mot de passe *",
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
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        obscureText: true,
                                        controller: _password,
                                        style: TextStyle(
                                          fontSize: 13,
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
                              //password
                              //champObligatoire
                              Container(
                                width: 9 * screenWidth / 12,
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  "* Champs obligatoires",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto-Bold',
                                  ),
                                ),
                              ),
                              Container(
                                width: 9 * screenWidth / 12,
                                height: 50,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      testPhone("");
                                      // _addData();
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 9 * screenWidth / 12,
                                        child: Text(
                                          "ENREGISTRER",
                                          style: TextStyle(
                                            fontSize: 16,
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
                              Container(
                                width: screenWidth,
                                margin: EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                    },
                                    child: Text(
                                      "Vous avez déjà un compte ?",
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
                              Container(
                                width: screenWidth,
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Text(
                                    "Connecter-vous !",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Mix',
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
    );
  }
}
