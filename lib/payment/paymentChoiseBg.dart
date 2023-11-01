import 'dart:convert';

import 'package:agogolines/payment/payment_choise.dart';
import 'package:agogolines/stripe_payment/pay_with_stripe.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_screen/maps_background.dart';
import '../global_screen/trajectory_direction.dart';
import '../passenger_menu/passenger_top_menu.dart';
import '../waiting_driver/waiting_driver.dart';

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

  void _validateChoice(data) {
    if (data == 1) {
      var rate = (widget.trajectory['rafined_rate'] * 100).toInt();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayWithStripe(
            trajectory: widget.trajectory,
            userData: widget.userData,
            parametter: {'type': 1, 'rent': rate.toString()},
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingDriver(
            trajectoryId: widget.trajectory['id'],
            userData: widget.userData,
          ),
        ),
      );
    }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 0),
          height: 30,
        ),
      ),
      body: Container(
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
              height: 100,
              color: Colors.white,
              child: PassengerTopMenu(),
            ),
            Positioned(
              top: 120,
              child: Container(
                child: TrajectoryDirection(trajectory: widget.trajectory),
              ),
            ),
            Container(
              child: PaymentChoise(
                parametter: {
                  'rent': (widget.trajectory['rafined_rate']).toString(),
                  'id': widget.trajectory['id'],
                },
                validateChoice: _validateChoice,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
