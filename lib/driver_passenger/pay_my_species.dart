import 'package:flutter/material.dart';

import '../driver_trajectory/driver_trajectory.dart';
import '../global_url.dart';
import 'driver_map_helper.dart';
import 'driver_with_passenger.dart';

class PayMySpecies extends StatefulWidget {
  dynamic userData;
  List<dynamic> trajectoryData;
  @override
  PayMySpecies({
    required this.userData,
    required this.trajectoryData,
  });
  State<PayMySpecies> createState() => _PayMySpecies();
}

class _PayMySpecies extends State<PayMySpecies> {
  dynamic _userData = {};
  dynamic _clientData = {};
  List<dynamic> _trajectory = [];

  bool _isLoading = true;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  Future<void> _arrived(status) async {
    final body = {'status': status, 'type': 0};
    var response = await DriverPassengerHelper.updateData(_trajectory[2], body);
    if (status == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverWithPassenge(
                trajectory: _trajectory, userData: widget.userData)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DriverTrajectory(null)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _trajectory = widget.trajectoryData;
      _userData = widget.userData;
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
                    margin: EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        Container(
                          width: (screenWidth / 1.11) / 6,
                          height: 70,
                          child: Center(
                              child: Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                GlobalUrl.getGlobalImageUrl() +
                                    _clientData['profil'],
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: screenWidth,
                          child: Text(
                            _clientData['name'] +
                                " " +
                                _clientData['last_name'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      ],
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
                            margin: EdgeInsets.symmetric(vertical: 30),
                            width: screenWidth,
                            // alignment: Alignment.center,
                            child: Center(
                              child: Container(
                                width: 8 * screenWidth / 12,
                                child: Text(
                                  "a choisi le mode de paiement suivant: ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: appTheme,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 9 * screenWidth / 12,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: Image.asset(
                                    'web/icons/coins.png',
                                    width: 35,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Espèces",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat-Medium',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            width: screenWidth,
                            child: Center(
                              child: Container(
                                width: 8 * screenWidth / 12,
                                child: Text(
                                  "Pensez à luidemander de vous reverser: ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth,
                            child: Center(
                              child: Container(
                                width: 8 * screenWidth / 12,
                                child: Text(
                                  (widget.trajectoryData[0]['rafined_rate'])
                                          .toString() +
                                      " €",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: appTheme,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 8 * screenWidth / 12,
                            child: Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    _arrived(5);
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
                                      "Ok, c'est fait !",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: 8 * screenWidth / 12,
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _arrived(8);
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
                                  width: 8 * screenWidth / 12,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Il n'a pas payé",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 8 * screenWidth / 12,
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _arrived(9);
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
                                  width: 8 * screenWidth / 12,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Il n'a pas payé la totalité",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
    );
  }
}
