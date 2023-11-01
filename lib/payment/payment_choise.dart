import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../free_drive/data_helper.dart';
import '../global_screen/quiestion_page.dart';
import '../home_page/home_screen.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import '../passenger_menu/passenger_top_menu.dart';
import 'payment_choise_service.dart';

class PaymentChoise extends StatefulWidget {
  dynamic parametter;
  Function validateChoice;
  PaymentChoise({
    super.key,
    required this.parametter,
    required this.validateChoice,
  });
  @override
  State<PaymentChoise> createState() => _PaymentChoiseState();
}

class _PaymentChoiseState extends State<PaymentChoise> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int paymentMode = 1;
  bool questionPage = false;

  void getPaymentMode(value) {
    setState(() {
      paymentMode = value;
    });
  }

  _questionResponse(response) {
    if (response == 1) {
      _validateChoice(4);
    } else {
      setState(() {
        questionPage = false;
      });
    }
  }

  void _validateChoice(data) async {
    final body = {
      "status": data,
      "payment_mode": paymentMode,
    };
    await PaymentChoiseService.choosePayment(body, widget.parametter['id']);
    if (data == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
      );
    } else if (data == 5) {
      widget.validateChoice(paymentMode);
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
    return Container(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white.withOpacity(0.8),
        child: Stack(
          children: [
            Positioned(
              bottom: screenHeight / 5,
              child: Container(
                width: screenWidth,
                alignment: Alignment.center,
                child: Container(
                  width: 9 * screenWidth / 12,
                  height: 400,
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
                        width: 9 * screenWidth / 12,
                        height: 60,
                        decoration: BoxDecoration(
                          color: appTheme,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(
                                'web/icons/hand_money.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              "MODE DE PAIEMENT",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Roboto-Bold',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 9 * screenWidth / 12,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.parametter['rent'] + " €",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: appTheme,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 15 * screenWidth / 24,
                        child: Text(
                          "Vous ne serez débité que si la course a lieu et du montant définitif négocié avec le conducteur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getPaymentMode(1);
                        },
                        child: Container(
                          width: 8 * screenWidth / 12,
                          height: 55,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: paymentMode == 1
                                    ? Colors.black.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.0),
                                spreadRadius: 5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  paymentMode == 1
                                      ? 'web/icons/card_blue.png'
                                      : 'web/icons/card.png',
                                  width: 25,
                                  height: 15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Carte bancaire",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      paymentMode == 1 ? appTheme : Colors.grey,
                                  fontFamily: 'Roboto-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getPaymentMode(2);
                        },
                        child: Container(
                          width: 8 * screenWidth / 12,
                          height: 55,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: paymentMode == 2
                                    ? Colors.black.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.0),
                                spreadRadius: 5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  paymentMode == 2
                                      ? 'web/icons/coins_blue.png'
                                      : 'web/icons/coins.png',
                                  width: 22,
                                  height: 15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Espèces",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      paymentMode == 2 ? appTheme : Colors.grey,
                                  fontFamily: 'Roboto-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 9 * screenWidth / 12,
                        height: 55,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    questionPage = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
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
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  _validateChoice(5);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: appTheme,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: appTheme),
                                child: Container(
                                  width: 3 * screenWidth / 12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ENREGISTRER ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontFamily: 'Roboto-Bold',
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Image.asset(
                                          'web/icons/next_page.png',
                                          width: 15,
                                          height: 15,
                                          fit: BoxFit.cover,
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
                    ],
                  ),
                ),
              ),
            ),
            questionPage
                ? QuestionPage(
                    parametter: {
                      'text': "Êtes-vous sûr(e) de vouloir annuler la course ?",
                      'type': 1,
                    },
                    response: _questionResponse,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
