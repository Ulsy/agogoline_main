import 'package:flutter/material.dart';

class GoodDeal extends StatefulWidget {
  @override
  State<GoodDeal> createState() => _GoodDeal();
}

class _GoodDeal extends State<GoodDeal> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appTheme,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 100),
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight - 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              "10% DE REMISE !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: appTheme,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "LOREM IMPSUM AT VERO EOS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: appTheme,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: 9 * screenWidth / 12,
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('web/icons/gooDeal1.png',
                                  width: 9 * screenWidth / 12,
                                  height: 30,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "CODE PROMO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 6 * screenWidth / 12,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "ZV617E",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Meddium',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            height: 0.5,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(vertical: 20),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.only(bottom: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(children: [
                              Container(
                                width: 10 * screenWidth / 12,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: appTheme,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "JUSQU'À - 50%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                width: 9 * screenWidth / 12,
                                height: 180,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset('web/icons/goodDeal2.png',
                                      width: 9 * screenWidth / 12,
                                      height: 30,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                width: 10 * screenWidth / 12,
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "LOREM IMPSUM AT VERO EOS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: appTheme,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ),
                              Container(
                                width: 10 * screenWidth / 12,
                                margin: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Text(
                                  "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat-Meddium',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: ElevatedButton(
                                  onPressed: () {},
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
                                    width: 6 * screenWidth / 12,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "BIENTÔT DISPONIBLE!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat-Bold',
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
            ),
            Container(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        width: screenWidth,
                        height: 180,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            'BONS PLANS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat-bold"),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        alignment: Alignment.topLeft,
                        height: 100,
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.symmetric(vertical: 63),
                        child: IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          iconSize: 30,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
