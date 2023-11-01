import 'package:agogolines/driver_passenger/pay_my_species.dart';
import 'package:flutter/material.dart';

import '../driver_trajectory/driver_trajectory.dart';
import '../global_url.dart';
import 'driver_map_helper.dart';
import 'driver_with_passenger.dart';

class ArrivedInPassenger extends StatefulWidget {
  dynamic userData;
  List<dynamic> trajectoryData;
  bool withPassenger;
  @override
  ArrivedInPassenger(
      {required this.userData,
      required this.trajectoryData,
      required this.withPassenger});
  State<ArrivedInPassenger> createState() => _ArrivedInPassenger();
}

class _ArrivedInPassenger extends State<ArrivedInPassenger> {
  dynamic _userData = {};
  bool _withPassenger = false;
  dynamic _clientData = {};
  List<dynamic> _trajectory = [];

  bool _isLoading = true;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  void testPayment() async {
    var payment = await widget.trajectoryData[0]['payment_mode'];
    if (payment == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PayMySpecies(
                trajectoryData: _trajectory, userData: widget.userData)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverWithPassenge(
                trajectory: _trajectory, userData: widget.userData)),
      );
    }
  }

  Future<void> _arrived(status) async {
    final body = {'status': status, 'type': 0};
    var response = await DriverPassengerHelper.updateData(_trajectory[2], body);
    if (status == 5) {
      testPayment();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
      );
    }
    // if (status == 5) {
    //
    // } else {
    //
    // }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _trajectory = widget.trajectoryData;
      _userData = widget.userData;
      _withPassenger = widget.withPassenger;
      _clientData = _trajectory[0]['passenger'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appTheme,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight / 4,
                    child: Center(
                      child: Container(
                        width: 9 * screenWidth / 12,
                        child: Text(
                          _withPassenger
                              ? 'Confirmez-vous avoir déposé votre voyageur ?'
                              : 'Avez-vous récupéré votre voyageur ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Montserrat-Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //compartiment validation ou annulation
                Positioned(
                  bottom: 0,
                  child: Container(
                      width: screenWidth,
                      height: screenHeight * 3 / 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 80),
                            child: Container(
                              width: 5 * screenWidth / 6,
                              margin: EdgeInsets.only(top: 5),
                              child: Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      _arrived(_withPassenger ? 7 : 5);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: appTheme,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor: appTheme),
                                    child: Container(
                                      width: 4 * screenWidth / 6,
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        _withPassenger
                                            ? "Oui !"
                                            : "Oui, c'est parti !",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat-Bold',
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            width: screenWidth,
                            // alignment: Alignment.center,
                            child: Center(
                              child: Container(
                                width: 5 * screenWidth / 6,
                                child: Text(
                                  _withPassenger
                                      ? "En cliquant sur oui, vous confirmer avoir déposé votre passager et vous pourrez être payé du montant de la course"
                                      : "Si vous indiquez qu'il est absent, la course sera automatiquement annulée. tenter de joindre le passager par téléphone, s'il ne répond pas au bout de 5min, vous pouvez confimer ci-dessous son absence.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Container(
                              width: 5 * screenWidth / 6,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _arrived(_withPassenger ? 6 : 2);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.white),
                                  child: Container(
                                    width: 4 * screenWidth / 6,
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      _withPassenger
                                          ? "Non"
                                          : "Non, il est absent.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                //compartiment client
                Positioned(
                  top: (screenHeight / 4) - 35,
                  child: Container(
                    width: screenWidth,
                    child: Center(
                      child: Container(
                        width: screenWidth / 1.11,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: (screenWidth / 1.11) / 6,
                              height: 70,
                              child: Center(
                                child: ClipOval(
                                  child: Image.network(
                                      GlobalUrl.getGlobalImageUrl() +
                                          _clientData['profil'],
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                              width: 3 * (screenWidth / 1.11) / 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _clientData['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _clientData['last_name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2 * (screenWidth / 1.11) / 6,
                              child: Row(children: [
                                Container(
                                  width: 1 * (screenWidth / 1.11) / 6,
                                  child: Center(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: appTheme,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Icon(
                                        Icons.mail_outline,
                                        color: appTheme,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1 * (screenWidth / 1.11) / 6,
                                  child: Center(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: appTheme,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
