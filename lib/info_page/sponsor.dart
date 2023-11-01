import 'package:flutter/material.dart';

class Sponsor extends StatefulWidget {
  @override
  State<Sponsor> createState() => _Sponsor();
}

class _Sponsor extends State<Sponsor> {
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
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 8 * screenWidth / 12,
                          child: Image.asset('web/icons/sponsor.png',
                              width: 8 * screenWidth / 12,
                              height: 8 * screenWidth / 12,
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: 9 * screenWidth / 12,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "INVITE TES AMIS ET GAGNEZ 3 POINTS CHACUN!",
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
                          width: 9 * screenWidth / 12,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Meddium',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: 9 * screenWidth / 12,
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        Container(
                          width: 9 * screenWidth / 12,
                          margin: EdgeInsets.symmetric(vertical: 80),
                          child: Text(
                            "Bientôt disponible",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: appTheme,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      ],
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
                            'PARRAINER DES AMIS',
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
