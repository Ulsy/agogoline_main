import 'package:flutter/material.dart';

class Politique extends StatefulWidget {
  @override
  State<Politique> createState() => _Politique();
}

class _Politique extends State<Politique> {
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
                            width: 9 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Politique",
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
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun !",
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
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "1. Lorem impsum",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront.",
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
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "1. Lorem impsum",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront.",
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
                            margin: EdgeInsets.symmetric(vertical: 5),
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
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "1. Lorem impsum",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront.",
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
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "2. Lorem impsum",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront.",
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
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "3. Lorem impsum",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Bold',
                              ),
                            ),
                          ),
                          Container(
                            width: 10 * screenWidth / 12,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront et entreront le code ci-dessous, vous gagnerez 3 points chacun, Quand vos amis se connecteront.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat-Meddium',
                              ),
                            ),
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
                            'POLITIQUE DE CONFIDENTIALITÉ',
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
