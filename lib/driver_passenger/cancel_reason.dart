import 'package:agogolines/driver_trajectory/driver_trajectory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'driver_map_helper.dart';

class CancelReason extends StatefulWidget {
  // parametter = {text: 'texte à afficher', type:0, }
  int trajectoryId;
  Function beCOntinue;
  CancelReason({
    super.key,
    required this.trajectoryId,
    required this.beCOntinue,
  });
  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int paymentMode = 0;
  giveResponse(value) async {
    var body = {
      'cancel_reason': value,
    };
    var res =
        await DriverPassengerHelper.cancelReason(widget.trajectoryId, body);
    widget.beCOntinue(value);
  }

  void _continue() {
    widget.beCOntinue(0);
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
      width: screenWidth,
      height: screenHeight,
      color: Colors.black.withOpacity(0.9),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 3 * screenWidth / 24),
              child: Text(
                "Que s'est-il passé?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(1);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Passager injoignable",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(2);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Numéro de passager invalide",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(3);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Problème sur la route",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(4);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Problème avec l'application",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(5);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Problème avec le véhicule",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(6);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    "Mauvaise attitude du passager",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  _continue();
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
                  width: 9 * screenWidth / 12,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Je continue ma course",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
