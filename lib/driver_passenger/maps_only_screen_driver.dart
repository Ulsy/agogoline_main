import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../global_url.dart';
import '../location/location_controller.dart';

class MapsOnlyScreenDriver extends StatefulWidget {
  LatLng departure;
  LatLng arrival;
  double _zoom;
  double markerPosition;
  int stopPlayAlg;
  Function sendPosition;

  MapsOnlyScreenDriver(
    this.departure,
    this.arrival,
    this.markerPosition,
    this._zoom,
    this.stopPlayAlg, {
    required this.sendPosition,
  });

  @override
  State<MapsOnlyScreenDriver> createState() => _MapsOnlyScreenDriverState();
  void addMarker(type, latitude, longitude) {
    _MapsOnlyScreenDriverState().newMarke(type, latitude, longitude);
  }
}

class _MapsOnlyScreenDriverState extends State<MapsOnlyScreenDriver> {
  late CameraPosition _cameraPosition;

  LatLng sourceLocation = LatLng(45.521563, -122.677433);
  LatLng destination = LatLng(45.521563, -122.677433);
  LocationData? _currentLocation;
  List<LatLng> polylineCoordinates = [];
  bool _isMapCreated = false;
  bool _departure = false;
  bool _arrival = false;
  double otherZoom = 10;
  late GoogleMapController _controller;
  late Position _currentPosition;
  bool playAlg = true;
  @override
  void didUpdateWidget(MapsOnlyScreenDriver oldWidget) {
    if (widget.departure != oldWidget.departure) {
      setState(() {
        sourceLocation = widget.departure;
      });
      getPolyPoint();
    }
    if (widget.arrival != oldWidget.arrival) {
      print("La valeur de points a été mise à jour : ${widget.arrival}");
      setState(() {
        otherZoom = widget._zoom;
        destination = widget.arrival;
      });

      getPolyPoint();
    }
    if (widget.stopPlayAlg != oldWidget.stopPlayAlg) {
      setState(() {
        playAlg = false;
      });
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<void> _get_currentLocation() async {
    Location location = Location();

    LocationData? instant_currentLocation;
    location.getLocation().then((location) {
      _currentLocation = location;
    });

    location.onLocationChanged.listen((newLoc) {
      if (playAlg) {
        setState(() {
          _currentLocation = newLoc;
        });
        centerMarkersOnMap(
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            0.0);
        dynamic position = {
          'latitude': _currentLocation!.latitude!,
          'longitude': _currentLocation!.longitude!
        };
        widget.sendPosition(position);
      }
    });
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

  void oneCoordonate(data) {
    setState(() {
      sourceLocation =
          LatLng(jsonDecode(data)['Latitude'], jsonDecode(data)['Longitude']);
    });
    getPolyPoint();
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
  void dispose() {
    playAlg = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    addCustomIconDep();
    getPolyPoint();
    _cameraPosition = CameraPosition(target: sourceLocation, zoom: otherZoom);
    _get_currentLocation();
  }

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
          body: _currentLocation == null
              ? Center(
                  child: Text('Loading'),
                )
              : Stack(
                  children: <Widget>[
                    FutureBuilder<BitmapDescriptor>(
                      future: customIcon,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Attendez que l'icône personnalisée soit chargée
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'Erreur de chargement de l\'icône personnalisée'),
                          );
                        } else {
                          return FutureBuilder<BitmapDescriptor>(
                              future: customIconDep,
                              builder: (context, snapshotDep) {
                                if (snapshotDep.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshotDep.hasError) {
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
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            _currentLocation!.latitude!,
                                            _currentLocation!.longitude!),
                                        zoom: 13.5),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId("source"),
                                        position: sourceLocation,
                                        icon: snapshotDep.data ??
                                            BitmapDescriptor.defaultMarker,
                                      ),
                                      Marker(
                                        markerId: const MarkerId("position"),
                                        position: LatLng(
                                            _currentLocation!.latitude!,
                                            _currentLocation!.longitude!),
                                        icon: BitmapDescriptor.defaultMarker,
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
