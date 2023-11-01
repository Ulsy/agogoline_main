import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DriverResponse extends StatefulWidget {
  dynamic initialData;

  Function validateConfirmation;
  DriverResponse({
    required this.initialData,
    required this.validateConfirmation,
  });
  @override
  State<DriverResponse> createState() => _DriverResponse();
}

class _DriverResponse extends State<DriverResponse> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  int _tripStatus = 0;

  final TextEditingController _temps = TextEditingController();
  final TextEditingController _status = TextEditingController();

  _validateConfiramtion(data) {
    widget.validateConfirmation(data);
  }

  void giveValue() {
    dynamic data = widget.initialData;
    setState(() {
      _temps.text = data['temps'];
      _status.text = (data['status']).toString();
    });
  }

  @override
  void initState() {
    super.initState();

    giveValue();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return _status.text == "5"
        ? Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 9 * screenWidth / 12,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: appTheme,
                          width: 10.0,
                        ),
                        color: appTheme,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "RÉSERVATION CONFIRMÉE",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: appTheme,
                          fontFamily: 'Montserrat-Bold',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Votre réservation est confirmée. Votre conducteur arrivera dans " +
                          _temps.text +
                          " min.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontFamily: 'Montserrat-Medium',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _validateConfiramtion(1);
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
                      child: Text(
                        "Ok",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 9 * screenWidth / 12,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 10.0,
                        ),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "RÉSERVATION REFUSÉE",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          fontFamily: 'Montserrat-Bold',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Votre réservation est refusée. Voulez vous partir au tarif normal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontFamily: 'Montserrat-Bold',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            _validateConfiramtion(4);
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
                          child: Text(
                            "Annuler",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            _validateConfiramtion(5);
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
                          child: Text(
                            "Ok",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
