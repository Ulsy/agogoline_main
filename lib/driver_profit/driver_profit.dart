import 'package:agogolines/driver_profit/profit_service.dart';
import 'package:flutter/material.dart';

class DriverProfit extends StatefulWidget {
  dynamic userData;
  DriverProfit({
    super.key,
    required this.userData,
  });
  @override
  State<DriverProfit> createState() => _DriverProfit();
}

class _DriverProfit extends State<DriverProfit> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  String speciesProfit = "";
  String blueCartProfit = "";
  String taotalProfit = "";
  String netProfit = "";
  String commissionAmount = "";
  double commission = 0.2;

  Future<dynamic> getProfit() async {
    final data = await ProfitService.getAllProfit(widget.userData['id']);
    print(data);
    getAmount(data);
  }

  getAmount(data) {
    setState(() {
      blueCartProfit = (data['blue_card']).toString();
      speciesProfit = (data['species']).toString();
      taotalProfit = (data['blue_card'] + data['species']).toString();
      netProfit = (data['blue_card'] +
              data['species'] -
              (data['blue_card'] * commission))
          .toString();
      commissionAmount = ((data['blue_card'] * commission)).toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getProfit();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 9 * screenWidth / 12,
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 300,
            child: Column(
              children: [
                Container(
                  width: 9 * screenWidth / 12,
                  height: 200,
                  decoration: BoxDecoration(
                    color: appTheme,
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
                        height: 150,
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
                            Row(
                              children: [
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Espèces",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    speciesProfit + " €",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 8 * screenWidth / 12,
                              height: 0.5,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Carte bleue",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: appTheme,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    blueCartProfit + " €",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: appTheme,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 15),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "TOTAL",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 9 * screenWidth / 24,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 15),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    taotalProfit + " €",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Bold',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 9 * screenWidth / 12,
                        child: Row(
                          children: [
                            Container(
                              width: 9 * screenWidth / 24,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Net",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Bold',
                                ),
                              ),
                            ),
                            Container(
                              width: 9 * screenWidth / 24,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                netProfit + " €*",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Bold',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 9 * screenWidth / 12,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: commissionAmount != "0.0"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total commissions: " + commissionAmount + " €",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Medium',
                                ),
                              ),
                              Text(
                                "* Ces chiffres ne tiennent pas compte",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Medium',
                                ),
                              ),
                              Text(
                                "d'éventuels ajustements",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Medium',
                                ),
                              )
                            ],
                          )
                        : Container()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
