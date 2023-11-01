import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../driver_profit/driver_profit.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../global_url.dart';
import 'trajectory_story_list.dart';
import 'trajectory_story_service.dart';

class TrajctoryStory extends StatefulWidget {
  @override
  dynamic userData;
  TrajctoryStory({
    required this.userData,
  });

  State<TrajctoryStory> createState() => _TrajctoryStory();
}

class _TrajctoryStory extends State<TrajctoryStory> {
  bool _isLoading = true;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  List<dynamic> _allData = [];

  void getAllData(int id, int type) async {
    final data = await TrajectoryStoryService.getAllData(id, type);
    print(data);
    setState(() {
      _isLoading = false;
      _allData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.userData);
    getAllData(widget.userData['id'], int.parse(widget.userData['type']));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appTheme,
      body: _isLoading
          ? CustomScrollView()
          : Container(
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
                          child: Center(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                child: Container(
                                  height: 10 * screenHeight / 13,
                                  child: ListView.builder(
                                    itemCount: _allData.length + 1,
                                    itemBuilder: (context, index) => index <
                                            _allData.length
                                        ? Container(
                                            width: screenWidth,
                                            alignment: Alignment.center,
                                            child: TrajctoryStoryList(
                                                data: _allData[index]),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 40),
                                            child: widget.userData['type'] ==
                                                    '1'
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        child: Text(
                                                          'MES GAINS',
                                                          style: TextStyle(
                                                              color: appTheme,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Montserrat-Bold"),
                                                        ),
                                                      ),
                                                      DriverProfit(
                                                          userData:
                                                              widget.userData),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                  ),
                                ),
                              ),
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
                                  'HISTORIQUE',
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
