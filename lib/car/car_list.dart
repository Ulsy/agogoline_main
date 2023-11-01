import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../driver_menu/driver_menu.dart';
import '../driver_trajectory/driver_trajectory.dart';
import '../global_screen/quiestion_page.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import 'car_screen.dart';
import 'data_helper.dart';

class CarList extends StatefulWidget {
  dynamic userData;
  @override
  CarList({required this.userData});
  State<CarList> createState() => _CarList();
}

class _CarList extends State<CarList> {
  Map<String, dynamic> _userConnected = {};
  List<dynamic> _allData = [];

  bool _isLoading = true;
  bool _editMode = false;
  bool _listData = true;
  int carId = 0;
  bool questionPage = false;
  String questionContent = "";
  int questionType = 0;

  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  _changeOrDelete(data) {
    setState(() {
      questionContent = "Êtes-vous sûr(e) de vouloir supprimer cette voiture ?";
      questionPage = true;
      carId = data;
    });
  }

  void deleteCar() async {
    final res = await DataHelperCar.deleteData(carId);
    setState(() {
      questionPage = false;
    });
    _refreshUser();
  }

  _questionResponse(response) {
    if (response == 1) {
      deleteCar();
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  void editOneChild(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Car(
                userData: _userConnected,
                carData: data,
                userStatus: 1,
              )),
    );
  }

  void _closeForm() {
    setState(() {
      _listData = true;
    });
  }

  void addNewCar(int data) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Car(
                userData: _userConnected,
                carData: null,
                userStatus: 1,
              )),
    );
  }

  void getAllData(int id) async {
    final data = await DataHelperCar.getAllData(id);
    setState(() {
      _allData = data;
      _isLoading = false;
    });
    _listData = true;
  }

  void _refreshUser() async {
    final user = await DataHelperlogin.getUserConnected();
    print(user);
    if (user.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      getAllData(jsonDecode(user[0]['information'])['id']);
    }
    setState(() {
      _userConnected = jsonDecode(user[0]['information']);
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                _listData
                    ? ListPage(
                        allData: _allData,
                        editOne: editOneChild,
                        newCar: addNewCar,
                        reloadList: _refreshUser,
                        changeOrDelete: _changeOrDelete,
                      )
                    : Container(),
                Container(
                  width: screenWidth,
                  height: 200,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'MES VÉHICULES',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                        _listData ? Navigator.pop(context) : _closeForm();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                questionPage
                    ? QuestionPage(
                        parametter: {
                          'text': questionContent,
                          'type': 1,
                        },
                        response: _questionResponse,
                      )
                    : Container(),
              ],
            ),
    );
  }
}

class ListPage extends StatelessWidget {
  List<dynamic> allData;
  final Color appTheme = Color.fromARGB(255, 90, 72, 203);
  Function(Map<String, dynamic>) editOne;
  Function(int) newCar;
  Function() reloadList;
  Function changeOrDelete;
  ListPage({
    required this.allData,
    required this.editOne,
    required this.newCar,
    required this.reloadList,
    required this.changeOrDelete,
  });
  void _editData(data) {
    editOne(data);
  }

  void _newCar() {
    newCar(0);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      children: [
        SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight - 157,
            color: appTheme,
            margin: EdgeInsets.only(top: 157),

            // Positioned(
            //   bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: ListView.builder(
                  itemCount: allData.length + 1,
                  itemBuilder: (context, index) => index < allData.length
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white,
                                width: 0.0,
                              ),
                            ),
                          ),

                          //************************************************ */
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 25),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: screenWidth / 1.21,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: Offset(0, 5),
                                              blurRadius: 10.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    width: 7 * screenWidth / 12,
                                                    height: 50,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'web/icons/car_left.png',
                                                              width: 35,
                                                              height: 15,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  allData[index]
                                                                          [
                                                                          'brand'] +
                                                                      " - " +
                                                                      allData[index]
                                                                          [
                                                                          'model'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Montserrat-Bold',
                                                                  ),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 11 * screenWidth / 48,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _editData(
                                                              allData[index]);
                                                        },
                                                        child: Container(
                                                          height: 20,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 25),
                                                            child: Image.asset(
                                                              'web/icons/edit-square.png',
                                                              width: 20,
                                                              height: 20,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 25),
                                                        child: Image.asset(
                                                          'web/icons/tick.png',
                                                          width: 20,
                                                          height: 20,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    width: screenWidth / 2,
                                                    height: 25,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "ANNÉE",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    width: screenWidth / 4,
                                                    height: 25,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        (allData[index]
                                                                ['years'])
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    width: screenWidth / 2,
                                                    height: 25,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "IMMATRICULATION",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    width: screenWidth / 4,
                                                    height: 25,
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        allData[index][
                                                            'registration_number'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    width: screenWidth / 2,
                                                    height: 25,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "COULEUR",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    width: screenWidth / 4,
                                                    height: 25,
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        allData[index]['color'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    width: screenWidth / 2,
                                                    height: 25,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "PLACES PASSAGERS",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    width: screenWidth / 4,
                                                    height: 25,
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        (allData[index][
                                                                'number_of_seats'])
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Roboto-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    offset: Offset(0, 5),
                                                    blurRadius: 10.0,
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.only(top: 5),
                                              margin: EdgeInsets.only(left: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  changeOrDelete(
                                                      allData[index]['id']);
                                                },
                                                child: Image.asset(
                                                  'web/icons/garbage.png',
                                                  width: 18,
                                                  height: 25,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: screenWidth / 2,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                _newCar();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _newCar();
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "AJOUTER UN VÉHICULE",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: appTheme,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),

          // ),
        ),
      ],
    ));
  }
}
