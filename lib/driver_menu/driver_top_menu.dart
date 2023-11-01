import 'dart:convert';

import 'package:flutter/material.dart';
import '../global_screen/app_menu.dart';
import '../global_url.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import './driver_profil.dart';

class DriverTopMenu extends StatefulWidget {
  @override
  State<DriverTopMenu> createState() => _DriverTopMenu();
}

class _DriverTopMenu extends State<DriverTopMenu> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  Map<String, dynamic> _userConnected = {};
  bool _isLoading = true;
  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    if (data.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    setState(() {
      _userConnected = jsonDecode(data[0]['information']);
      _isLoading = false;
    });
  }

  myProfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverProfile()),
    );
  }

  Future<void> _checkMenu() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppMenu()),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Container()
        : Container(
            width: screenWidth,
            height: 80,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: screenWidth / 6,
                  height: 80,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      color: appTheme,
                      iconSize: 30,
                      onPressed: () async {
                        _checkMenu();
                      },
                    ),
                  ),
                ),
                Container(
                  width: 4 * screenWidth / 6,
                  height: 80,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Image.asset('web/icons/agogoliness.png',
                        width: 119, height: 18, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: screenWidth / 6,
                  margin: EdgeInsets.only(top: 30),
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      myProfil();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ClipOval(
                            child: Image.network(
                                GlobalUrl.getGlobalImageUrl() +
                                    _userConnected['profil'],
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
