import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrajectoryDirection extends StatefulWidget {
  dynamic trajectory;
  TrajectoryDirection({
    super.key,
    required this.trajectory,
  });
  @override
  State<TrajectoryDirection> createState() => _TrajectoryDirectionState();
}

class _TrajectoryDirectionState extends State<TrajectoryDirection> {
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      child: Container(
        width: 10 * screenWidth / 12,
        height: 120,
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
        child: Container(
          child: Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'web/icons/departure.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'web/icons/line_blue.png',
                        width: 2,
                        height: 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'web/icons/line_blue.png',
                        width: 2,
                        height: 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'web/icons/line_blue.png',
                        width: 2,
                        height: 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'web/icons/line_blue.png',
                        width: 2,
                        height: 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Image.asset(
                        'web/icons/pin.png',
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                width: (9 * screenWidth / 12) - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "DÉPART",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.trajectory['departure'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat-Medium',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: 8 * screenWidth / 12,
                      height: 0.5,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "ARRIVÉE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.trajectory['arrival'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat-Medium',
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
