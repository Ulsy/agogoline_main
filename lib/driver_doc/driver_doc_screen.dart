import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../car/car_screen.dart';
import 'data_helper.dart';

class DriverDoc extends StatefulWidget {
  dynamic userData;
  @override
  DriverDoc({
    required this.userData,
  });
  State<DriverDoc> createState() => _DriverDoc();
}

class _DriverDoc extends State<DriverDoc> {
  bool _isLoading = false;
  Color appTheme = Color.fromARGB(255, 90, 72, 203);

  File? _imageNic1;
  PickedFile? _pickedFileNic1;
  final _pickerNic1 = ImagePicker();
  String base64StringNic1 = "";

  Future<void> _pickImageNic1() async {
    _pickedFileNic1 = await _pickerNic1.getImage(source: ImageSource.gallery);
    if (_pickedFileNic1 != null) {
      String imagePath = _pickedFileNic1!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileNic1!.path);
      base64StringNic1 = await imageToBase64(pickedFile);
      setState(() {
        _imageNic1 = imageFile;
      });
    }
  }

  File? _imageNic2;
  PickedFile? _pickedFileNic2;
  final _pickerNic2 = ImagePicker();
  String base64StringNic2 = "";

  Future<void> _pickImageNic2() async {
    _pickedFileNic2 = await _pickerNic2.getImage(source: ImageSource.gallery);
    if (_pickedFileNic2 != null) {
      String imagePath = _pickedFileNic2!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileNic2!.path);
      base64StringNic2 = await imageToBase64(pickedFile);
      setState(() {
        _imageNic2 = imageFile;
      });
    }
  }

  File? _imageLicence1;
  PickedFile? _pickedFileLicence1;
  final _pickerLicence1 = ImagePicker();
  String base64StringLicence1 = "";

  Future<void> _pickImageLicence1() async {
    _pickedFileLicence1 =
        await _pickerLicence1.getImage(source: ImageSource.gallery);
    if (_pickedFileLicence1 != null) {
      String imagePath = _pickedFileLicence1!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileLicence1!.path);
      base64StringLicence1 = await imageToBase64(pickedFile);
      setState(() {
        _imageLicence1 = imageFile;
      });
    }
  }

  File? _imageLicence2;
  PickedFile? _pickedFileLicence2;
  final _pickerLicence2 = ImagePicker();
  String base64StringLicence2 = "";

  Future<void> _pickImageLicence2() async {
    _pickedFileLicence2 =
        await _pickerLicence2.getImage(source: ImageSource.gallery);
    if (_pickedFileLicence2 != null) {
      String imagePath = _pickedFileLicence2!.path;
      File imageFile = await File(imagePath);
      File pickedFile = File(_pickedFileLicence2!.path);
      base64StringLicence2 = await imageToBase64(pickedFile);
      setState(() {
        _imageLicence2 = imageFile;
      });
    }
  }

  Future<String> imageToBase64(File imageFile) async {
    final imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _addData() async {
    final body = {
      "id": 0,
      "user_client_id": widget.userData['id'],
      "user_name": widget.userData['name'],
      "front_nic": base64StringNic1,
      "front_side_nic": base64StringNic2,
      "front_drivers_licence": base64StringLicence1,
      "front_side_drivers_licence": base64StringLicence2
    };
    var response = await DataHelperDriver.createDataBack(body);
    if (response == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Car(userData: widget.userData, carData: null, userStatus: 0)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme,
        body: _isLoading
            ? CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: appTheme,
                    expandedHeight: 165,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: Center(
                          child: Container(
                            // Chan
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: screenWidth,
                                  height: 150,
                                  color: appTheme,
                                  child: Center(
                                    child: Text(
                                      'MES DOCUMENTS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenHeight / 4,
                                  height: 150,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
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
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          height: screenHeight,
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              )
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
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 4 * screenWidth / 6,
                                      margin: EdgeInsets.only(bottom: 25),
                                      child: Center(
                                        child: Text(
                                          "Merci d'importer les documents suivants (obligatoire)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: Text(
                                          "PIÈCE NATIONALE D'IDENTITÉ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 5 * screenWidth / 6,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _pickImageNic1();
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 2),
                                                  width: 2 * screenWidth / 6,
                                                  child: Center(
                                                    child: Column(children: [
                                                      (_pickedFileNic1 != null
                                                          ? Image.file(
                                                              File(
                                                                  _pickedFileNic1!
                                                                      .path),
                                                              width: 2 *
                                                                  screenWidth /
                                                                  6,
                                                              height: 90,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              'web/icons/plus.png',
                                                            )),
                                                      Text(
                                                        "Recto",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _pickImageNic2();
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 2),
                                                  width: 2 * screenWidth / 6,
                                                  child: Center(
                                                    child: Column(children: [
                                                      (_pickedFileNic2 != null
                                                          ? Image.file(
                                                              File(
                                                                  _pickedFileNic2!
                                                                      .path),
                                                              width: 2 *
                                                                  screenWidth /
                                                                  6,
                                                              height: 90,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              'web/icons/plus.png',
                                                            )),
                                                      Text(
                                                        "Verso",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: 4 * screenWidth / 6,
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: Text(
                                          "PERMIS DE CONDUIRE",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Montserrat-Bold',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 5 * screenWidth / 6,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _pickImageLicence1();
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 2),
                                                  width: 2 * screenWidth / 6,
                                                  child: Center(
                                                    child: Column(children: [
                                                      (_pickedFileLicence1 !=
                                                              null
                                                          ? Image.file(
                                                              File(
                                                                  _pickedFileLicence1!
                                                                      .path),
                                                              width: 2 *
                                                                  screenWidth /
                                                                  6,
                                                              height: 90,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              'web/icons/plus.png',
                                                            )),
                                                      Text(
                                                        "Recto",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _pickImageLicence2();
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 2),
                                                  width: 2 * screenWidth / 6,
                                                  child: Center(
                                                    child: Column(children: [
                                                      (_pickedFileLicence2 !=
                                                              null
                                                          ? Image.file(
                                                              File(
                                                                  _pickedFileLicence2!
                                                                      .path),
                                                              width: 2 *
                                                                  screenWidth /
                                                                  6,
                                                              height: 90,
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              'web/icons/plus.png',
                                                            )),
                                                      Text(
                                                        "Verso",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Montserrat-Bold',
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      margin: EdgeInsets.only(top: 25),
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            _addData();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "ENREGISTRER",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat-Bold',
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 80),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 200,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          'MES DOCUMENTS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Montserrat-Bold"),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 200,
                      color: Colors.transparent,
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
