import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../driver_trajectory/driver_trajectory.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import 'data_helper.dart';

class DriverTrips extends StatefulWidget {
  @override
  State<DriverTrips> createState() => _DriverTrips();
}

class _DriverTrips extends State<DriverTrips> {
  Map<String, dynamic> _userConnected = {};
  List<dynamic> allData = [];

  bool _isLoading = true;
  bool _editMode = false;
  bool _listData = true;
  int _tripId = 0;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  void editOneChild(Map<String, dynamic> data) {
    print('++++++++++++++');
    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverTrajectory(data)),
    );
    // setState(() {
    //   _listData = false;
    //   _tripId = data['id'];
    //   _departure.text = data['departure'];
    //   _arrival.text = data['arrival'];
    // });
    // _editMode = true;
  }

  void _closeForm() {
    setState(() {
      _listData = true;
    });
  }

  void newTrajectoryChild(int data) {
    setState(() {
      _listData = false;
      _tripId = 0;
      _departure.clear();
      _arrival.clear();
    });
  }

  Future<void> _addData() async {
    final body = {
      "id": _tripId,
      "user_client_id": _userConnected['id'],
      "departure": _departure.text,
      "arrival": _arrival.text,
    };
    await DataHelperDriverTrip.createDataBack(body);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ConfirmScreen()),
    // );
  }

  Future<void> _updateData() async {
    final body = {
      "id": _tripId,
      "user_client_id": _userConnected['id'],
      "departure": _departure.text,
      "arrival": _arrival.text,
    };
    await DataHelperDriverTrip.updateData(_tripId, body);
    setState(() {
      _listData = true;
      _editMode = false;
      _refreshUser();
    });
  }

  void getAllData(int id) async {
    final data = await DataHelperDriverTrip.getAllData(id);
    setState(() {
      allData = data;
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
                        allData: allData,
                        editOne: editOneChild,
                        newTrajectory: newTrajectoryChild,
                        reloadList: _refreshUser,
                      )
                    : Container(
                        width: 500,
                        height: 800,
                        color: Colors.transparent,
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 500,
                              height: 700,
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
                                      //departure
                                      Container(
                                        width: 370,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 25.0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Text(
                                          "Départ *",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        width: 370,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                          controller: _departure,
                                          style: TextStyle(
                                            fontSize: 20,
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
                                      //departure
                                      //arrival
                                      Container(
                                        width: 370,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 25.0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Text(
                                          "Arrivée *",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        width: 370,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                          controller: _arrival,
                                          style: TextStyle(
                                            fontSize: 20,
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
                                      //arrival
                                      Container(
                                        width: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Text(
                                          "* Champs obligatoires",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 600,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 25),
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
                                              padding: EdgeInsets.all(18),
                                              child: Text(
                                                "ENREGISTRER",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 80),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 500,
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 50),
                    color: appTheme,
                    child: Center(
                      child: Text(
                        'MES TRAJETS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat-bold"),
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
                        _listData ? Navigator.pop(context) : _closeForm();
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

      // _listData
      //     ? ListPage(allData: allData)
      //     : FormPage(),
    );
  }
}

class ListPage extends StatelessWidget {
  List<dynamic> allData;
  final Color appTheme = Color.fromARGB(255, 90, 72, 203);
  Function(Map<String, dynamic>) editOne;
  Function(int) newTrajectory;
  Function() reloadList;
  ListPage(
      {required this.allData,
      required this.editOne,
      required this.newTrajectory,
      required this.reloadList});
  void _editData(data) {
    editOne(data);
  }

  void _deleteData(id, context) async {
    await DataHelperDriverTrip.deleteDataBack(id);
    allData = await DataHelperDriverTrip.getAllData(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
    );
  }

  void _newTrajectory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
        width: 500,
        height: 710,
        color: appTheme,
        margin: EdgeInsets.only(top: 100),
        child: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 500,
              height: 650,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Center(
                child: ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 10),
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                  'web/icons/departdestination.png',
                                  width: 25,
                                  height: 70,
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: 200,
                              margin: EdgeInsets.only(left: 2),
                              child: Column(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            allData[index]['departure'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              fontFamily: 'Roboto-Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  allData[index]['arrival'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                    fontFamily: 'Roboto-Medium',
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
                          ],
                        ),
                        // child: Text(
                        //   allData[index]['departure'],
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //   ),
                        // ),
                      ),
                      // subtitle: Text(allData[index]['arrival']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editData(allData[index]);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: appTheme,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteData(allData[index]['id'], context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
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
        ),
      ),
      Container(
        width: 500,
        color: Colors.white,
        child: FloatingActionButton(
            onPressed: () => _newTrajectory(context), child: Icon(Icons.add)),
      ),
    ]));
  }
}
