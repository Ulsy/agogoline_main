import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePayment extends StatefulWidget {
  final String title;
  const StripePayment({super.key, required this.title});

  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  Map<String, dynamic>? paymentIntent;
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
    } catch (e) {
      print('***************************');
      print(e.toString());
      print('failed 2');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('Done');
    } catch (e) {
      print('***************************');
      print(e.toString());
      print('failed');
    }
  }

  createPaymentIntent() async {
    String secretKey =
        "sk_test_51NrQZXJC30b6QnikqSNLbFmb81gjgBbzlxkXECIFukcoS2aHSRuq3sHaY8t7ZMCve8fXaCIIgjla8ZufHteYthYU00L84nFQ2A";
    try {
      Map<String, dynamic> body = {
        'amount': "1000",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 40,
      child: ElevatedButton(
          onPressed: () {
            makePayment();
          },
          child: const Text("Pay Me!")),
    );
  }
}
