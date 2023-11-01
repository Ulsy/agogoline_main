import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_screen/maps_background.dart';
import '../global_screen/trajectory_direction.dart';
import '../passenger_menu/passenger_top_menu.dart';

// ignore: must_be_immutable
class PaymentChoiseBg extends StatefulWidget {
  dynamic trajectory;
  dynamic userData;
  PaymentChoiseBg({required this.trajectory, required this.userData});
  @override
  State<PaymentChoiseBg> createState() => _PaymentChoiseBg();
}

class _PaymentChoiseBg extends State<PaymentChoiseBg> {
  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
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
              Container(
                height: 80,
                child: PassengerTopMenu(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 120,
                child: Container(
                  child: TrajectoryDirection(trajectory: widget.trajectory),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
