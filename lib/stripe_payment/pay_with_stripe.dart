import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_screen/maps_background.dart';
import '../global_screen/trajectory_direction.dart';
import '../passenger_menu/passenger_top_menu.dart';
import 'package:http/http.dart' as http;

import '../payment/paymentChoiseBg.dart';
import '../waiting_driver/waiting_driver.dart';

// ignore: must_be_immutable
class PayWithStripe extends StatefulWidget {
  // {'type': 1|5, 'rent':100}
  dynamic parametter;
  dynamic trajectory;
  dynamic userData;
  PayWithStripe({
    required this.trajectory,
    required this.userData,
    required this.parametter,
  });
  @override
  State<PayWithStripe> createState() => _PayWithStripe();
}

class _PayWithStripe extends State<PayWithStripe> {
  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  Map<String, dynamic>? paymentIntent;

  @override
  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "FR",
        currencyCode: "EUR",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.light,
        merchantDisplayName: "Agogolines",
        googlePay: gpay,
      ));
      displayPaymentSheet();
    } catch (e) {}
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('tato am mety *******************');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingDriver(
              trajectoryId: widget.trajectory['id'], userData: widget.userData),
        ),
      );
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentChoiseBg(
              trajectory: widget.trajectory, userData: widget.userData),
        ),
      );
    }
  }

  createPaymentIntent() async {
    print('tonga tato');
    String secretKey =
        "sk_test_51NrQZXJC30b6QnikqSNLbFmb81gjgBbzlxkXECIFukcoS2aHSRuq3sHaY8t7ZMCve8fXaCIIgjla8ZufHteYthYU00L84nFQ2A";
    try {
      Map<String, dynamic> body = {
        'amount': widget.parametter['rent'],
        "currency": "EUR",
      };
      http.Response response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void initState() {
    super.initState();
    makePayment();
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
            GestureDetector(
              onTap: () {
                // makePayment();
              },
              child: Container(
                height: screenHeight,
                width: screenWidth,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
