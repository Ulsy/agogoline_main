import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../passenger_menu/passenger_top_menu.dart';

class QuestionPage extends StatefulWidget {
  // parametter = {text: 'texte à afficher', type:0, }
  dynamic parametter;
  Function response;
  QuestionPage({
    super.key,
    required this.parametter,
    required this.response,
  });
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int paymentMode = 0;
  giveResponse(value) {
    widget.response(value);
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
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                widget.parametter['type'] == 0
                    ? 'web/icons/are_you_sure.png'
                    : 'web/icons/cancel.png',
                width: widget.parametter['type'] == 0 ? 78 : 50,
                height: widget.parametter['type'] == 0 ? 78 : 50,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 3 * screenWidth / 24),
              child: Text(
                widget.parametter['text'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(1);
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
                  width: 4 * screenWidth / 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OUI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Roboto-Bold',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {
                  giveResponse(0);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.transparent),
                child: Container(
                  width: 4 * screenWidth / 12,
                  child: Text(
                    "ANNULER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontFamily: 'Roboto-Bold',
                    ),
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
