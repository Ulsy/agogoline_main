import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../global_url.dart';
import '../../location/location_controller.dart';

class MapsBGTracker extends StatefulWidget {
  LatLng departure;
  LatLng arrival;
  LatLng actullyPosition;
  double markerPostion;

  MapsBGTracker({
    required this.departure,
    required this.arrival,
    required this.actullyPosition,
    required this.markerPostion,
  });

  @override
  State<MapsBGTracker> createState() => _MapsBGTrackerState();
}

class _MapsBGTrackerState extends State<MapsBGTracker> {
  late CameraPosition _cameraPosition;

  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  LatLng actuallyPosition = LatLng(45.521563, -122.677433);
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];
  bool _isMapCreated = false;
  bool _departure = false;
  bool _arrival = false;
  double otherZoom = 5;
  late GoogleMapController _controller;
  late Position _currentPosition;

  @override
  void didUpdateWidget(MapsBGTracker oldWidget) {
    if (widget.departure != oldWidget.departure) {
      setState(() {
        sourceLocation = widget.departure;
        centerMarkersOnMap(
            LatLng(sourceLocation.latitude, sourceLocation.longitude), 0.0);
      });
    }
    if (widget.actullyPosition != oldWidget.actullyPosition) {
      setState(() {
        actuallyPosition = widget.actullyPosition;
      });
      centerMarkersOnMap(
          LatLng(actuallyPosition.latitude, actuallyPosition.longitude), 0.0);
    }
    if (widget.arrival != oldWidget.arrival) {
      setState(() {
        destination = widget.arrival;
      });
      getPolyPoint();
    }
    super.didUpdateWidget(oldWidget);
  }

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

  late Future<BitmapDescriptor> customIconAct;
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

  Future<void> addCustomIconAct() async {
    customIconAct = BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'web/icons/car_go.png',
    );
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    addCustomIconDep();
    addCustomIconAct();
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
                    child:
                        Text('Erreur de chargement de l\'icône personnalisée'),
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
                        return FutureBuilder<BitmapDescriptor>(
                          future: customIconAct,
                          builder: (context, snapshotAct) {
                            if (snapshotAct.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshotAct.hasError) {
                              return Center(
                                child: Text(
                                    'Erreur de chargement de l\'icône personnalisée'),
                              );
                            } else {
                              return GoogleMap(
                                onMapCreated:
                                    (GoogleMapController mapController) {
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
                                    markerId: MarkerId("position"),
                                    position: actuallyPosition,
                                    icon: snapshotAct.data ??
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
                          },
                        );
                      }
                    },
                  );
                }
              })
        ],
      ));
    });
  }
}
