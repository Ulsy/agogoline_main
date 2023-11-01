import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../global_url.dart';
import 'location_search_dialogue.dart';

import 'location_controller.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late CameraPosition _cameraPosition;

  LatLng sourceLocation = LatLng(-18.8791902, 47.5079055);
  LatLng destination = LatLng(-18.7791902, 47.5079055);
  List<LatLng> polylineCoordinates = [];
  bool _isMapCreated = false;
  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalUrl.apiKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
    }
    setState(() {});

    centerMarkersOnMap();
  }

  void oneCoordonate(data) {
    setState(() {
      sourceLocation =
          LatLng(jsonDecode(data)['Latitude'], jsonDecode(data)['Longitude']);
    });
    getPolyPoint();
    _cameraPosition =
        CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
  }

  void centerMarkersOnMap() {
    if (_mapController != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: sourceLocation, // Remplacez par la position source
        northeast: destination, // Remplacez par la position destination
      );

      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
      _mapController.animateCamera(cameraUpdate);
    }
  }

  @override
  void initState() {
    super.initState();
    getPolyPoint();
    _cameraPosition =
        CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
  }

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Maps sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                _isMapCreated = true;
              },
              initialCameraPosition: _cameraPosition,
              markers: {
                Marker(markerId: MarkerId("source"), position: sourceLocation),
                Marker(
                    markerId: MarkerId("destination"), position: destination),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  color: Colors.indigo,
                  width: 5,
                  points: polylineCoordinates,
                  // points: [sourceLocation, destination],
                ),
              },
            ),
            Positioned(
              top: 100,
              left: 10,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10), // Coin arrondi
                ),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      width: 400,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Départ: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Couleur du texte
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Arrivé: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Couleur du texte
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.dialog(LocationSearchDialog(
                        //     editOne: oneCoordonate,
                        //     mapController: _mapController));
                      },
                      child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 25,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '${locationController.pickPlaceMark.name ?? ''}'
                                  ' ${locationController.pickPlaceMark.locality ?? ''}'
                                  ' ${locationController.pickPlaceMark.postalCode ?? ''}'
                                  ' ${locationController.pickPlaceMark.country ?? ''}',
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.search,
                                  size: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color)
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
