import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_url.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../passanger_trajectory/passenger_trajectory.dart';

// ignore: must_be_immutable
class FreeDriverList extends StatefulWidget {
  List<dynamic> initialData;
  int index;
  String distance;
  Function(int) chooseData;
  FreeDriverList(
      {required this.initialData,
      required this.distance,
      required this.index,
      required this.chooseData});

  @override
  State<FreeDriverList> createState() => _FreeDriverList();
}

class _FreeDriverList extends State<FreeDriverList> {
  bool _isLoading = true;
  int index = 0;
  bool departurOrArrival = true;
  int tripId = 0;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  GoogleMapController? mapController;

  List<dynamic> _allData = [];
  final TextEditingController _distance = TextEditingController();

  List<dynamic> negociationData = [];

  void getNegociationPage(data) {
    widget.chooseData(data);
  }

  getSearchInput(dataType, type) {
    setState(() {
      departurOrArrival = dataType;
    });
  }

  Future<int> _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    if (data.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    setState(() {
      // _userConnected = jsonDecode(data[0]['information']);
    });
    return 0;
  }

  void cancel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();

    setState(() {
      _allData = widget.initialData;
      _distance.text = widget.distance;
      index = widget.index;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: [
        Container(
          child: Row(
            children: [
              Container(
                width: 3 * screenWidth / 24,
                alignment: Alignment.centerLeft,
                child: Container(
                  child: ClipOval(
                    child: Image.network(
                        GlobalUrl.getGlobalImageUrl() + _allData[0]['profil'],
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                width: 11 * screenWidth / 24,
                height: 50,
                child: Column(children: [
                  Container(
                    height: 16,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _allData[0]['last_name'] + ' ' + _allData[0]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Montserrat-Bold',
                          ),
                        )),
                  ),
                  _allData[0]['star_number'] > 0
                      ? Container(
                          height: 16,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (_allData[0]['star_number']),
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 15.0,
                              );
                            },
                          ),
                        )
                      : Container(),
                  Container(
                    width: 5 * screenWidth / 12,
                    height: 16,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'web/icons/car_left.png',
                      width: 30,
                      height: 12,
                      fit: BoxFit.cover,
                    ),
                  )
                ]),
              ),
              Container(
                width: 19 * screenWidth / 96,
                height: 50,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        Icons.mail_outline,
                        color: appTheme,
                        size: 22.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: appTheme,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: 8 * screenWidth / 12,
          height: 0.8,
          color: Colors.grey,
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: 4 * screenWidth / 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      alignment: Alignment.centerLeft,
                      width: 3 * screenWidth / 48,
                      height: 25,
                      child: Image.asset(
                        'web/icons/map_icon.png',
                        width: 20,
                        height: 25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 4 * screenWidth / 24,
                      child: Column(
                        children: [
                          Container(
                            width: 4 * screenWidth / 24,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "DISTANCE",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 4 * screenWidth / 24,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  (_allData[0]['driver_passenger_distance'])
                                          .toString() +
                                      " km",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat-Medium',
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
              Container(
                width: 13 * screenWidth / 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      alignment: Alignment.centerLeft,
                      width: 3 * screenWidth / 48,
                      child: Container(
                          child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appTheme,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Icon(
                          Icons.euro_symbol,
                          color: appTheme,
                          size: 8.0,
                        ),
                      )),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 5 * screenWidth / 24,
                            child: Text(
                              "TARIF",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 5 * screenWidth / 24,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  (double.parse(_allData[0]['settings']
                                              ['km_price']) *
                                          double.parse(_distance.text))
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(int.parse("FFB406", radix: 16))
                                        .withAlpha(255),
                                    fontFamily: 'Montserrat-Medium',
                                  ),
                                ),
                                Icon(
                                  Icons.euro_symbol,
                                  color: Color(int.parse("FFB406", radix: 16))
                                      .withAlpha(255),
                                  size: 14.0,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ElevatedButton(
                  onPressed: () {
                    getNegociationPage(index);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: appTheme,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: appTheme),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Choisir",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
