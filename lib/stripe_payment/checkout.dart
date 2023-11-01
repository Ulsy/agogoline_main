import 'package:agogolines/stripe_payment/stripe_service.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Stripe checkout",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              var items = [
                {
                  "productPrice": 4,
                  "productName": "Apple",
                  "qty": 5,
                },
                {
                  "productPrice": 5,
                  "productName": "Pineapple",
                  "qty": 10,
                }
              ];
              await StripeService.stripePaymentCheckout(
                items,
                500,
                context,
                mounted,
                onSuccess: () {
                  print('Success');
                },
                onCancel: () {
                  print('Cancel');
                },
                onError: (e) {
                  print('Error' + e.toString());
                },
              );
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                )),
            child: Text("CHECKOUT"),
          ),
        ));
  }
}
