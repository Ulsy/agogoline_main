import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../home_page/data_helper.dart';
import '../home_page/home_screen.dart';
import '../users/data_helper.dart';
import 'data_helper.dart';
import '../global_url.dart';

class UpdateProfil extends StatefulWidget {
  dynamic userData;
  @override
  UpdateProfil({required this.userData});
  State<UpdateProfil> createState() => _UpdateProfil();
}

class _UpdateProfil extends State<UpdateProfil> {
  bool _isLoading = true;
  dynamic _userConnected = {};
  Color appTheme = Color.fromARGB(255, 90, 72, 203);
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  String base64String = "";
  File? _image;
  bool askDeletion = false;
  bool updateData = false;

  int _deconnectionValue = 0;

  Future<void> _closeMenu() async {
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PassengerTrajectory()),
    // );
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  bool nameEdit = false;
  bool lastNameEdit = false;
  bool emailEdit = false;
  bool phoneEdit = false;
  FocusNode _nameEdit = FocusNode();
  FocusNode _lastNameEdit = FocusNode();
  FocusNode _emailEdit = FocusNode();
  FocusNode _phoneEdit = FocusNode();

  updateOneInput(data) {
    setState(() {
      updateData = true;
    });
    switch (data) {
      case 'nameEdit':
        setState(() {
          nameEdit = true;
          _nameEdit.requestFocus();
        });
        break;
      case 'lastNameEdit':
        setState(() {
          lastNameEdit = true;
          _lastNameEdit.requestFocus();
        });
        break;
      case 'emailEdit':
        setState(() {
          emailEdit = true;
          _emailEdit.requestFocus();
        });
        break;
      case 'phoneEdit':
        setState(() {
          phoneEdit = true;
          _phoneEdit.requestFocus();
        });
        break;
    }
  }

  setData(data) {
    setState(() {
      _userConnected = data;
      _name.text = data['name'];
      _lastName.text = data['last_name'];
      _email.text = data['email'];
      _phoneNumber.text = (data['phone_number']).substring(3);
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      print('tonga tatp');
      String imagePath = _pickedFile!.path;
      base64String = await imageToBase64(File(imagePath));
      setState(() {
        _image = File(imagePath);
        updateData = true;
      });
    }
  }

  void unableAccount() {
    updateProfile(0);
  }

  chekUnableAccount(value) {
    print(value);
    setState(() {
      askDeletion = value;
    });
  }

  Future<void> updateProfile(value) async {
    final body = {
      "name": _name.text,
      "last_name": _lastName.text,
      "email": _email.text,
      'profil': base64String,
      "phone_number": "+33" + _phoneNumber.text,
      "state": value,
    };
    await DataHelperUser.updateProfil(body, widget.userData['id']);
    _deconnection();
    setState(() {
      updateData = false;
      nameEdit = false;
      lastNameEdit = false;
      emailEdit = false;
      phoneEdit = false;
    });
  }

  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _deconnection() async {
    if (_deconnectionValue > 0) {
      await DataHelperMenu.deleteData(_deconnectionValue);
      await DataHelperlogin.createData(jsonEncode(_userConnected));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    }
  }

  void _refreshUser() async {
    final data = await DataHelperlogin.getUserConnected();
    setState(() {
      _deconnectionValue = data[0]['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    setData(widget.userData);
    _refreshUser();
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: ClipOval(
                                          child: _pickedFile != null
                                              ? Image.file(
                                                  File(_pickedFile!.path),
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover)
                                              : Image.network(
                                                  GlobalUrl
                                                          .getGlobalImageUrl() +
                                                      _userConnected['profil'],
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () async {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: Image.asset(
                                                    'web/icons/add_picture.png',
                                                    width: 16,
                                                    height: 14,
                                                    fit: BoxFit.cover),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: GestureDetector(
                                                  onTap: () => _pickImage(),
                                                  child: Text(
                                                    "Modifier",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Montserrat-Bold',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0),
                                            ),
                                            backgroundColor: Color.fromARGB(
                                                255, 253, 253, 255),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //name
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            margin:
                                                EdgeInsets.only(bottom: 5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Nom",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 8 * screenWidth / 12,
                                                    child: nameEdit
                                                        ? TextField(
                                                            controller: _name,
                                                            focusNode:
                                                                _nameEdit,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Montserrat-Medium',
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                            ),
                                                            decoration:
                                                                new InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            // color: Colors.red,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Text(
                                                              _name.text,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Montserrat-Medium',
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                            ),
                                                          )),
                                                Container(
                                                  width: screenWidth / 12,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      updateOneInput(
                                                          'nameEdit');
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      child: Image.asset(
                                                          'web/icons/edit-square.png',
                                                          width: 19,
                                                          height: 19,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //name
                                    //lastName
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Prénom",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 8 * screenWidth / 12,
                                                    child: lastNameEdit
                                                        ? TextField(
                                                            controller:
                                                                _lastName,
                                                            focusNode:
                                                                _lastNameEdit,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Montserrat-Medium',
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                            ),
                                                            decoration:
                                                                new InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            // color: Colors.red,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Text(
                                                              _lastName.text,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Montserrat-Medium',
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                            ),
                                                          )),
                                                Container(
                                                  width: screenWidth / 12,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      updateOneInput(
                                                          'lastNameEdit');
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      child: Image.asset(
                                                          'web/icons/edit-square.png',
                                                          width: 19,
                                                          height: 19,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //lastName
                                    //email
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Email ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 9 * screenWidth / 12,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 8 * screenWidth / 12,
                                                    child: emailEdit
                                                        ? TextField(
                                                            controller: _email,
                                                            focusNode:
                                                                _emailEdit,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Montserrat-Medium',
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                            ),
                                                            decoration:
                                                                new InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 0.0),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            // color: Colors.red,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Text(
                                                              _email.text,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Montserrat-Medium',
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                            ),
                                                          )),
                                                Container(
                                                  width: screenWidth / 12,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      updateOneInput(
                                                          'emailEdit');
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      child: Image.asset(
                                                          'web/icons/edit-square.png',
                                                          width: 19,
                                                          height: 19,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //phonNumber
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 9 * screenWidth / 12,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Text(
                                                    "Téléphone ",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Roboto-Bold',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 9 * screenWidth / 12,
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child: Image.asset(
                                                              'web/icons/33.png',
                                                              width: 30,
                                                              height: 20,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                              width: 15 *
                                                                  screenWidth /
                                                                  24,
                                                              child: phoneEdit
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20.0),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _phoneNumber,
                                                                        focusNode:
                                                                            _phoneEdit,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'Montserrat-Mix',
                                                                          decoration:
                                                                              TextDecoration.none,
                                                                        ),
                                                                        decoration:
                                                                            new InputDecoration(
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.transparent,
                                                                              width: 0.0,
                                                                            ),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.transparent,
                                                                              width: 0.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      // color: Colors.red,
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              18.0,
                                                                          bottom:
                                                                              20.0),
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              30),
                                                                      child:
                                                                          Text(
                                                                        _phoneNumber
                                                                            .text,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              'Montserrat-Mix',
                                                                          decoration:
                                                                              TextDecoration.none,
                                                                        ),
                                                                      ),
                                                                    )),
                                                          Container(
                                                            width: screenWidth /
                                                                12,
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                updateOneInput(
                                                                    'phoneEdit');
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20),
                                                                child: Image.asset(
                                                                    'web/icons/edit-square.png',
                                                                    width: 19,
                                                                    height: 19,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                updateData
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            updateProfile(1);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color:
                                                                          appTheme,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  backgroundColor:
                                                                      appTheme),
                                                          child: Container(
                                                            width: 6 *
                                                                screenWidth /
                                                                12,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Enregistrer la modification",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Montserrat-Bold',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          chekUnableAccount(
                                                              true);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 40),
                                                          width: screenWidth,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    'web/icons/garbage.png',
                                                                    width: 20,
                                                                    height: 23,
                                                                    fit: BoxFit
                                                                        .cover),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    "Supprimer mon compte",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          'Montserrat-Bold',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //phonNumber
                                  ],
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
                                  'MON PROFIL',
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
                                  _closeMenu();
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
                  askDeletion
                      ? Positioned(
                          bottom: 0,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            color: Colors.black.withOpacity(0.7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 9 * screenWidth / 12,
                                  child: Text(
                                    "Voulez-vous vraiment supprimer votre compte ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-bold"),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 9 * screenWidth / 12,
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Toutes vos données concernant votre compte seront définitivement supprimées.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-Light"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      unableAccount();
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
                                      width: 6 * screenWidth / 12,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "SUPPRIMER MON COMPTE",
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
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      chekUnableAccount(false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor: Colors.transparent),
                                    child: Container(
                                      width: 6 * screenWidth / 12,
                                      child: Text(
                                        "Annuler",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontFamily: 'Monsterrat-Bold',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
