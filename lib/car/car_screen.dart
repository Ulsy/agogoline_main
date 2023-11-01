import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../driver_settings/driver_settings.dart';
import '../global_url.dart';
import 'brand_search_dialogue.dart';
import 'car_list.dart';
import 'data_helper.dart';
import 'package:flutter/services.dart';

class Car extends StatefulWidget {
  dynamic userData;
  dynamic? carData;
  int userStatus;

  Car(
      {required this.userData,
      required this.carData,
      required this.userStatus});
  @override
  State<Car> createState() => _Car();
}

class _Car extends State<Car> {
  bool _isLoading = false;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int carId = 0;
  bool editMode = false;
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _registrationNumber = TextEditingController();
  final TextEditingController _numberOfSeats = TextEditingController();
  final TextEditingController years = TextEditingController();
  final TextEditingController color = TextEditingController();
  String image1 = "";
  String image2 = "";
  File? _imageCar1;
  PickedFile? _pickedFileCar1;
  final _pickerCar1 = ImagePicker();
  String base64StringCar1 = "";

  void setValue(data) {
    setState(() {
      carId = data['id'];
      _brand.text = data['brand'];
      _type.text = data['type'];
      _model.text = data['model'];
      _registrationNumber.text = data['registration_number'];
      _numberOfSeats.text = (data['number_of_seats']).toString();
      years.text = (data['years']).toString();
      color.text = data['color'];
      image1 = data['front_registrement'];
      image2 = data['front_side_registrement'];
      editMode = true;
    });
  }

  Future<void> _pickImageCar1() async {
    _pickedFileCar1 = await _pickerCar1.getImage(source: ImageSource.gallery);
    if (_pickedFileCar1 != null) {
      String imagePath = _pickedFileCar1!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileCar1!.path);
      base64StringCar1 = await imageToBase64(pickedFile);
      setState(() {
        _imageCar1 = imageFile;
      });
    }
  }

  File? _imageCar2;
  PickedFile? _pickedFileCar2;
  final _pickerCar2 = ImagePicker();
  String base64StringCar2 = "";

  Future<void> _pickImageCar2() async {
    _pickedFileCar2 = await _pickerCar2.getImage(source: ImageSource.gallery);
    if (_pickedFileCar2 != null) {
      String imagePath = _pickedFileCar2!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileCar2!.path);
      base64StringCar2 = await imageToBase64(pickedFile);
      setState(() {
        _imageCar2 = imageFile;
      });
    }
  }

  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _addData() async {
    print('tato add');
    final body = {
      "id": 0,
      "user_client_id": widget.userData['id'],
      "brand": _brand.text,
      "type": _type.text,
      "model": _model.text,
      "registration_number": _registrationNumber.text,
      "number_of_seats": _numberOfSeats.text,
      "front_registrement": base64StringCar1,
      "front_side_registrement": base64StringCar2,
      "years": years.text,
      "color": color.text
    };
    var response = await DataHelperCar.createDataBack(body);
    if (response == 1) {
      if (widget.userStatus == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CarList(userData: widget.userData)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DriverSettings(userData: widget.userData)),
        );
      }
    }
  }

  Future<void> _editData() async {
    final body = {
      "id": carId,
      "user_client_id": widget.userData['id'],
      "brand": _brand.text,
      "type": _type.text,
      "model": _model.text,
      "registration_number": _registrationNumber.text,
      "number_of_seats": _numberOfSeats.text,
      "front_registrement": base64StringCar1,
      "front_side_registrement": base64StringCar2,
      "years": years.text,
      "color": color.text
    };
    var response = await DataHelperCar.updateData(body, carId);
    if (response == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CarList(userData: widget.userData)),
      );
    }
  }

  GoogleMapController? _mapController;
  void oneBrand(data) {
    setState(() {
      _brand.text = (data.split(' - '))[0];
      _model.text = (data.split(' - '))[1];
    });
  }

  Timer? _timer;

  void _startOrRestartTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: 2), () {
      getBrand();
    });
  }

  getBrand() {
    print(
        "###########################L'utilisateur a arrêté de taper sur le clavier pendant 3 secondes" +
            _brand.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.carData != null) {
      setValue(widget.carData);
    }
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin: EdgeInsets.symmetric(vertical: 25),
                                    child: Center(
                                      child: Text(
                                        "Merci d'importer les documents suivants (obligatoire)",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat-Bold',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: Text(
                                        "CARTE GRISE DU VÉHICULE",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat-Bold',
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _pickImageCar1();
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 2),
                                                width: 2 * screenWidth / 6,
                                                child: Center(
                                                  child: Column(children: [
                                                    (image1 != "" &&
                                                            _pickedFileCar1 ==
                                                                null)
                                                        ? Image.network(
                                                            GlobalUrl
                                                                    .getGlobalImageUrl() +
                                                                image1,
                                                            width: 2 *
                                                                screenWidth /
                                                                6,
                                                            height: 90,
                                                            fit: BoxFit.cover)
                                                        : (_pickedFileCar1 !=
                                                                null
                                                            ? Image.file(
                                                                File(
                                                                    _pickedFileCar1!
                                                                        .path),
                                                                width: 2 *
                                                                    screenWidth /
                                                                    6,
                                                                height: 90,
                                                                fit:
                                                                    BoxFit.fill)
                                                            : Image.asset(
                                                                'web/icons/plus.png',
                                                              )),
                                                    Text(
                                                      "Recto",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'Montserrat-Bold',
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _pickImageCar2();
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 2),
                                                width: 2 * screenWidth / 6,
                                                child: Center(
                                                  child: Column(children: [
                                                    (image2 != "" &&
                                                            _pickedFileCar2 ==
                                                                null)
                                                        ? Image.network(
                                                            GlobalUrl
                                                                    .getGlobalImageUrl() +
                                                                image2,
                                                            width: 2 *
                                                                screenWidth /
                                                                6,
                                                            height: 90,
                                                            fit: BoxFit.cover)
                                                        : (_pickedFileCar2 !=
                                                                null
                                                            ? Image.file(
                                                                File(
                                                                    _pickedFileCar2!
                                                                        .path),
                                                                width: 2 *
                                                                    screenWidth /
                                                                    6,
                                                                height: 90,
                                                                fit:
                                                                    BoxFit.fill)
                                                            : Image.asset(
                                                                'web/icons/plus.png',
                                                              )),
                                                    Text(
                                                      "Verso",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'Montserrat-Bold',
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    width: 5 * screenWidth / 6,
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  //brand
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Marque *",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    child: Stack(
                                      children: [
                                        Center(
                                          // width: screenWidth,
                                          // color: Colors.white,
                                          child: Container(
                                            width: 5 * screenWidth / 6,
                                            height: 50,
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
                                            child: RawKeyboardListener(
                                              focusNode: FocusNode(),
                                              onKey: (RawKeyEvent event) {
                                                if (event is RawKeyDownEvent) {
                                                  _startOrRestartTimer();
                                                }
                                              },
                                              child: TextField(
                                                controller: _brand,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                decoration: new InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 0.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 0.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: screenWidth / 12,
                                          child: Container(
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
                                              width: 10 * screenWidth / 12,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              child: BrandSearchDialog(
                                                  brandAndModel: _brand.text +
                                                      " - " +
                                                      _model.text,
                                                  setBrand: oneBrand)),
                                        )
                                      ],
                                    ),
                                  ),

                                  //model
                                  // Container(
                                  //   width: 5 * screenWidth / 6,
                                  //   margin:
                                  //       EdgeInsets.symmetric(vertical: 20.0),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.transparent,
                                  //   ),
                                  //   child: Text(
                                  //     "Modèle",
                                  //     style: TextStyle(
                                  //       fontSize: 13,
                                  //       color: Colors.black,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontFamily: 'Montserrat-Bold',
                                  //       decoration: TextDecoration.none,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width: 5 * screenWidth / 6,
                                  //   height: 50,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(15.0),
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //         color: Colors.black.withOpacity(0.1),
                                  //         blurRadius: 10.0,
                                  //         spreadRadius: 2.0,
                                  //         offset: Offset(0, 4),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   child: TextField(
                                  //     controller: _model,
                                  //     style: TextStyle(
                                  //       fontSize: 13,
                                  //       color: Colors.black,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontFamily: 'Montserrat-Medium',
                                  //       decoration: TextDecoration.none,
                                  //     ),
                                  //     decoration: new InputDecoration(
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //             color: Colors.transparent,
                                  //             width: 0.0),
                                  //       ),
                                  //       enabledBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(
                                  //             color: Colors.transparent,
                                  //             width: 0.0),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //model
                                  //Année
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Année de mise en circulation",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5 * screenWidth / 6,
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
                                      controller: years,
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                    ),
                                  ),
                                  //Année
                                  //Couleur
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Couleur",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5 * screenWidth / 6,
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
                                      controller: color,
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
                                  //Couleur
                                  //registerNumber
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Matricule *",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5 * screenWidth / 6,
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
                                      controller: _registrationNumber,
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
                                  //registerNumber
                                  //numberOfSeats
                                  Container(
                                    width: 5 * screenWidth / 6,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Nombre de place *",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Bold',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5 * screenWidth / 6,
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
                                      controller: _numberOfSeats,
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                    ),
                                  ),
                                  //numberOfSeats

                                  Container(
                                    width: screenWidth / 2,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Text(
                                      "* Champs obligatoires",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          editMode ? _editData() : _addData();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Text(
                                            "ENREGISTRER",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Montserrat-Bold",
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 80),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                  ),
                  Container(
                    width: screenWidth,
                    height: 200,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        'MA VOITURE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Montserrat-Bold",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 200,
                    color: Colors.transparent,
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
    );
  }
}
