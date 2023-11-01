import 'package:flutter/material.dart';

import '../global_url.dart';
import '../passanger_trajectory/passenger_trajectory.dart';
import 'comment_service.dart';

class CommentByPassenger extends StatefulWidget {
  dynamic userData;
  List<dynamic> trajectoryData;
  @override
  CommentByPassenger({required this.userData, required this.trajectoryData});
  State<CommentByPassenger> createState() => _CommentByPassenger();
}

class _CommentByPassenger extends State<CommentByPassenger> {
  dynamic _userData = {};
  dynamic _driverData = {};
  List<dynamic> _trajectory = [];
  int _starNumber = 0;
  bool _isLoading = true;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  final TextEditingController _comment = TextEditingController();
  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();

  Future<void> _addData() async {
    final body = {
      'driver_id': _trajectory[0]['driver_id'],
      'passenger_id': _trajectory[0]['passenger_id'],
      'trajectory_id': _trajectory[0]['id'],
      'star_number': _starNumber,
      'comment': _comment.text
    };
    var response = await CommnentService.createData(body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerTrajectory(null)),
    );
  }

  void _giveStarNumber(number) {
    setState(() {
      _starNumber = number;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _trajectory = widget.trajectoryData;
      _userData = widget.userData;
      _driverData = _trajectory[0]['driver'];
      _isLoading = false;
      _departure.text = _trajectory[0]['departure'];
      _arrival.text = _trajectory[0]['arrival'];
    });
    print(_driverData);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: <Widget>[
                  //compartiment validation ou annulation
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade100,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white
                          ], // Vous pouvez ajuster les couleurs du dégradé ici
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight / 16,
                    left: screenWidth / 12,
                    child: SingleChildScrollView(
                      child: Container(
                          width: 5 * screenWidth / 6,
                          height: 5 * screenHeight / 6,
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.09),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView(
                            children: <Widget>[
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // children: [
                              Container(
                                width: 5 * screenWidth / 6,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 60),
                                    width: 5 * screenWidth / 6,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 5 * screenWidth / 6,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              _driverData['name'] +
                                                  " " +
                                                  _driverData['last_name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 2 * (screenWidth / 1.11) / 6,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 3),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'web/icons/car_left.png',
                                              width: 45,
                                              height: 18,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
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
                                      width: 7 * screenWidth / 12,
                                      child: Transform.translate(
                                        offset: Offset(0, -2),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "DÉPART",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        _departure.text,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Montserrat-Meddium',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              width: 8 * screenWidth / 12,
                                              height: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Container(
                                              width: 7 * screenWidth / 12,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "ARRIVÉE",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-Bold',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            _arrival.text,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Montserrat-Meddium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
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
                                  ],
                                ),
                              ),
                              Container(
                                width: 9 * screenWidth / 12,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: 1,
                                color: Colors.grey,
                              ),
                              Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          _giveStarNumber(1);
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          color: _starNumber == 0
                                              ? Colors.grey
                                              : Colors.yellow[700],
                                          size: 30.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          _giveStarNumber(2);
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          color: _starNumber < 2
                                              ? Colors.grey
                                              : Colors.yellow[700],
                                          size: 30.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          _giveStarNumber(3);
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          color: _starNumber < 3
                                              ? Colors.grey
                                              : Colors.yellow[700],
                                          size: 30.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          _giveStarNumber(4);
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          color: _starNumber < 4
                                              ? Colors.grey
                                              : Colors.yellow[700],
                                          size: 30.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          _giveStarNumber(5);
                                        },
                                        icon: Icon(
                                          Icons.star,
                                          color: _starNumber < 5
                                              ? Colors.grey
                                              : Colors.yellow[700],
                                          size: 30.0,
                                        ),
                                      ),
                                    ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: screenWidth,
                                child: Center(
                                  child: Container(
                                    width: 9 * screenWidth / 12,
                                    child: Text(
                                      "Comment était votre trajet avec " +
                                          _driverData['name'] +
                                          " ?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Montserrat-Bold',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 5 * screenWidth / 6,
                                margin: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Container(
                                    width: 9 * screenWidth / 12,
                                    child: Text(
                                      "Merci de noter votre conducteur et de nous aider à améliorer nos services.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'Montserrat-Meddium',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                height: 2 * screenHeight / 12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextField(
                                  controller: _comment,
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                  ),
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Container(
                                  width: 5 * screenWidth / 6,
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _addData();
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
                                          width: 3 * screenWidth / 12,
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Envoyer",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontFamily: 'Roboto-Bold',
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -13 * screenHeight / 32),
                    child: Container(
                      width: screenWidth,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 5.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: ClipOval(
                            child: Image.network(
                                GlobalUrl.getGlobalImageUrl() +
                                    _driverData['profil'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover),
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
