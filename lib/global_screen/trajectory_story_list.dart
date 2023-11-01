import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../global_url.dart';
import 'trajectory_story_service.dart';
import 'package:intl/intl.dart';

class TrajctoryStoryList extends StatefulWidget {
  @override
  dynamic data;
  TrajctoryStoryList({
    required this.data,
  });

  State<TrajctoryStoryList> createState() => _TrajctoryStoryList();
}

class _TrajctoryStoryList extends State<TrajctoryStoryList> {
  String trajectoryDate = "now";
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  getDate(date) {
    DateTime dateTime = DateTime.parse(date);

    String formattedDate = DateFormat('dd/MM/yy').format(dateTime);
    setState(() {
      trajectoryDate = formattedDate;
    });
  }

  @override
  void initState() {
    super.initState();
    getDate(widget.data['datetime']);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 9 * screenWidth / 12,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: screenWidth / 12,
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('web/icons/oval_departure.png',
                          width: 17, height: 17, fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset('web/icons/trait-gris.png',
                          width: 2, height: 6, fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset('web/icons/trait-gris.png',
                          width: 2, height: 6, fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset('web/icons/trait-gris.png',
                          width: 2, height: 6, fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset('web/icons/shape_gray.png',
                          width: 15, height: 23, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 35,
                    child: Row(
                      children: [
                        Container(
                          width: 6 * screenWidth / 12,
                          child: Text(
                            widget.data['departure'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 2 * screenWidth / 12,
                          child: Text(
                            trajectoryDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 6 * screenWidth / 12,
                          child: Text(
                            widget.data['arrival'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Medium',
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 2 * screenWidth / 12,
                          child: Text(
                            (widget.data['rafined_rate']).toString() + ' €',
                            style: TextStyle(
                              fontSize: 14,
                              color: appTheme,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Bold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            width: 17 * screenWidth / 24,
            height: 0.8,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
