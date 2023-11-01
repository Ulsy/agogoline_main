import 'package:flutter/material.dart';

import '../home_page/home_screen.dart';

class ConfirmScreen extends StatefulWidget {
  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  void _connexion() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      body: Container(
        child: Stack(
          children: [
            // Positioned(
            //   top: -90,
            //   left: -10,
            //   child: Container(
            //     width: screenWidth,
            //     child: Image.asset(
            //       'web/icons/background.png',
            //       height: screenHeight / 3,
            //       width: screenWidth + 100,
            //     ),
            //   ),
            // ),
            Center(
              child: Container(
                height: screenHeight / 2,
                width: 9 * screenWidth / 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenHeight / 6,
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Image.asset(
                              'web/icons/congratulation.png',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "FÉLICITATIONS !",
                            style: TextStyle(
                              fontSize: 15,
                              color: appTheme,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Votre compte a été créé avec succès !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Nous venons de vous envoyer un e-mail pour valider votre adresse de messagerie. Cliquez sur le lien indiqué dans l'e-mail et commencez à utiliser l'application.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                _connexion();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: appTheme,
                              ),
                            ),
                          ),
                        ),
                      ],
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
