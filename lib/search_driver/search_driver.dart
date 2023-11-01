import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../free_drive/data_helper.dart';
import '../free_drive/free_drive.dart';
import '../global_screen/loading_page.dart';
import '../global_screen/maps_background.dart';
import '../global_screen/trajectory_direction.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import '../passenger_menu/passenger_top_menu.dart';

// ignore: must_be_immutable
class SearchDriver extends StatefulWidget {
  dynamic trajectory;
  dynamic userData;
  SearchDriver({required this.trajectory, required this.userData});
  @override
  State<SearchDriver> createState() => _SearchDriver();
}

class _SearchDriver extends State<SearchDriver> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  bool driveerList = true;
  int paymentMode = 0;
  bool waitingSearch = false;
  List<dynamic>? trajectoryData;
  bool loading = true;
  cancel() {
    Navigator.pop(context);
  }

  void freeDriver() async {
    setState(() {
      waitingSearch = true;
    });
    final journey = {
      "lat_departure": widget.trajectory['lat_departure'],
      "log_departure": widget.trajectory['log_departure'],
      "lat_arrival": widget.trajectory['lat_arrival'],
      "log_arrival": widget.trajectory['log_arrival'],
      "adress_dep": widget.trajectory['departure'],
      "adress_arr": widget.trajectory['arrival'],
      "distance": widget.trajectory['distance']
    };

    List<dynamic> data =
        await DataHelperDriverFree.getAllData(widget.trajectory);
    if (data.length > 0) {
      setState(() {
        trajectoryData = data;
        loading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FreeDriver({"journey": journey, "data": data})),
      );
    } else {
      setState(() {
        waitingSearch = false;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    freeDriver();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          margin: EdgeInsets.only(top: 25),
          height: 80,
          child: PassengerTopMenu(),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Container(
                height: screenHeight,
                width: screenWidth,
                child: MapsBG(
                  departure: sourceLocation,
                  arrival: destination,
                  markerPostion: 0.0,
                  zoom: 14,
                ),
              ),
              Positioned(
                top: 20,
                child: Container(
                  child: TrajectoryDirection(trajectory: widget.trajectory),
                ),
              ),
              Positioned(
                top: 150 + screenHeight / 6,
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: Container(
                    width: 9 * screenWidth / 12,
                    height: 190,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'web/icons/car_left.png',
                            width: 39,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "RECHERCHE D'UN ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat-Bold',
                                ),
                              ),
                              Text(
                                "CONDUCTEUR...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: appTheme,
                                  fontFamily: 'Montserrat-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading
                            ? Container(
                                alignment: Alignment.center,
                                width: 9 * screenWidth / 12,
                                height: 20,
                                child: LoadingPage(bgColor: 0),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              cancel();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white),
                            child: Container(
                              width: 5 * screenWidth / 24,
                              child: Text(
                                "ANNULER",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Roboto-Bold',
                                ),
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
      ),
    );
  }
}
