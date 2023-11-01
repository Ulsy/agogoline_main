import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './location/location_controller.dart';
import 'home_page/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NrQZXJC30b6QnikDY7KAAvslnPvW9nL4RxZcby26ByrjxDsdl6qQZAMOiI6baDh9n0DOX6zAQiVaw7UKLOKMVUT00XYmz514n";
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

continuer(data) {
  print(data);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}
