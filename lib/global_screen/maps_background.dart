import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../global_url.dart';
import '../../location/location_controller.dart';

class MapsBG extends StatefulWidget {
  LatLng departure;
  LatLng arrival;
  double markerPostion;
  double zoom;

  MapsBG({
    required this.departure,
    required this.arrival,
    required this.markerPostion,
    required this.zoom,
  });

  @override
  State<MapsBG> createState() => _MapsBGState();
}

class _MapsBGState extends State<MapsBG> {
  late CameraPosition _cameraPosition;

  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];
  bool _isMapCreated = false;
  bool _departure = false;
  bool _arrival = false;
  double otherZoom = 10;
  late GoogleMapController _controller;
  late Position _currentPosition;

  @override
  void didUpdateWidget(MapsBG oldWidget) {
    if (widget.departure != oldWidget.departure) {
      setState(() {
        sourceLocation = widget.departure;
      });
    }
    if (widget.arrival != oldWidget.arrival) {
      setState(() {
        otherZoom = widget.zoom;
        destination = widget.arrival;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  List<Marker> markers = [];

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });

      centerMarkersOnMap(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!), 0.0);
    });
  }

  void oneCoordonate(data) {
    setState(() {
      sourceLocation =
          LatLng(jsonDecode(data)['Latitude'], jsonDecode(data)['Longitude']);
    });
    _cameraPosition = CameraPosition(target: sourceLocation, zoom: otherZoom);
  }

  void centerMarkersOnMap(targetLocation, markerPosition) {
    LatLng position = LatLng(
        targetLocation.latitude + markerPosition, targetLocation.longitude);
    if (_mapController != null) {
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(position, 16);
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
    _cameraPosition = CameraPosition(target: sourceLocation, zoom: otherZoom);
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
                            // Marker(
                            //   markerId: MarkerId("destination"),
                            //   position: destination,
                            //   icon: snapshot.data ??
                            //       BitmapDescriptor.defaultMarker,
                            // ),
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
