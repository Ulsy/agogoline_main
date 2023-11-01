import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../global_url.dart';
import 'location_controller.dart';

class MapsOnlyScreen extends StatefulWidget {
  LatLng departure;
  LatLng arrival;
  double markerPosition;

  MapsOnlyScreen(this.departure, this.arrival, this.markerPosition);

  @override
  State<MapsOnlyScreen> createState() => _MapsOnlyScreenState();
  void addMarker(type, latitude, longitude) {
    _MapsOnlyScreenState().newMarke(type, latitude, longitude);
  }
}

class _MapsOnlyScreenState extends State<MapsOnlyScreen> {
  late CameraPosition _cameraPosition;

  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  List<LatLng> polylineCoordinates = [];
  bool _isMapCreated = false;
  bool _departure = false;
  bool _arrival = false;

  @override
  void didUpdateWidget(MapsOnlyScreen oldWidget) {
    if (widget.departure != oldWidget.departure) {
      setState(() {
        sourceLocation = widget.departure;
      });

      centerMarkersOnMap(sourceLocation, widget.markerPosition);
      getPolyPoint();
    }
    if (widget.arrival != oldWidget.arrival) {
      setState(() {
        destination = widget.arrival;
      });

      centerMarkersOnMap(destination, widget.markerPosition);
      getPolyPoint();
    }
    super.didUpdateWidget(oldWidget);
  }

  void newMarke(type, latitude, longitude) {
    setState(() {
      sourceLocation = LatLng(double.parse(latitude), double.parse(longitude));
    });

    markers.add(
      Marker(
        markerId: MarkerId("marker_$type"),
        position: LatLng(double.parse(latitude), double.parse(longitude)),
      ),
    );
    _cameraPosition = CameraPosition(
        target: LatLng(double.parse(latitude), double.parse(longitude)));
  }

  List<Marker> markers = [];
  // void deletePolyPoint() async {
  //   PolylinePoints polylinePoints = PolylinePoints();

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyAQX2iFEPh2ZaX5ks8JHbHpzc5K8GD6G08",
  //     PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //     PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach(
  //       (PointLatLng point) =>
  //           polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
  //     );
  //   }
  //   setState(() {});

  //   // centerMarkersOnMap();
  // }

  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();
    polylineCoordinates.clear();
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
  }

  void oneCoordonate(data) {
    setState(() {
      sourceLocation =
          LatLng(jsonDecode(data)['Latitude'], jsonDecode(data)['Longitude']);
    });
    getPolyPoint();
    _cameraPosition = CameraPosition(target: sourceLocation, zoom: 10);
  }

  void centerMarkersOnMap(targetLocation, markerPosition) {
    LatLng position = LatLng(
        targetLocation.latitude + markerPosition, targetLocation.longitude);
    if (_mapController != null) {
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(position, 10);
      _mapController.animateCamera(cameraUpdate);
    }
  }

  late Future<BitmapDescriptor> customIcon;
  late Future<BitmapDescriptor> customIconDep;
  Future<void> addCustomIcon() async {
    customIcon = BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'web/icons/pin.png',
    );
  }

  Future<void> addCustomIconDep() async {
    customIconDep = BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'web/icons/ogris.png',
    );
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    addCustomIconDep();
    // getCustomMarkerIcon();
    getPolyPoint();
    _cameraPosition = CameraPosition(target: sourceLocation, zoom: 10);
  }

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
          body: Stack(
        children: <Widget>[
          FutureBuilder<BitmapDescriptor>(
            future: customIcon,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Attendez que l'icône personnalisée soit chargée
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Erreur de chargement de l\'icône personnalisée'),
                );
              } else {
                return FutureBuilder<BitmapDescriptor>(
                    future: customIconDep,
                    builder: (context, snapshotDep) {
                      if (snapshotDep.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshotDep.hasError) {
                        return Center(
                          child: Text(
                              'Erreur de chargement de l\'icône personnalisée'),
                        );
                      } else {
                        return GoogleMap(
                          onMapCreated: (GoogleMapController mapController) {
                            _mapController = mapController;
                            _isMapCreated = true;
                          },
                          initialCameraPosition: _cameraPosition,
                          markers: {
                            Marker(
                              markerId: MarkerId("source"),
                              position: sourceLocation,
                              icon: snapshotDep.data ??
                                  BitmapDescriptor.defaultMarker,
                            ),
                            Marker(
                              markerId: MarkerId("destination"),
                              position: destination,
                              icon: snapshot.data ??
                                  BitmapDescriptor.defaultMarker,
                            ),
                          },
                          polylines: {
                            Polyline(
                              polylineId: PolylineId("route"),
                              color: Colors.indigo,
                              width: 5,
                              points: polylineCoordinates,
                            ),
                          },
                        );
                      }
                    });
              }
            },
          ),
        ],
      ));
    });
  }
}
