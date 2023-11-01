import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../global_url.dart';
import 'location_controller.dart';

class LocationSearchDialog extends StatefulWidget {
  final GoogleMapController? mapController;
  final Map<String, String> finalPoints = {
    'Latitude': "",
    'Longitude': "",
    'Adress': "dada",
    'Value': "0",
  };
  Function(String) editOne;
  LocationSearchDialog({
    required this.mapController,
    required this.editOne,
  });
  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialog(
        mapController: mapController,
        editOne: editOne,
      );
}

class _LocationSearchDialog extends State<LocationSearchDialog> {
  final GoogleMapController? mapController;
  Function(String) editOne;
  _LocationSearchDialog({
    required this.mapController,
    required this.editOne,
  });

  void _validateAdresse(value) {
    setState(() {
      // value == '1' ? _searchValue.text = "" : ();
      widget.finalPoints['Value'] = value;
      editOne(jsonEncode(widget.finalPoints));
    });
  }

  final TextEditingController _searchValue = TextEditingController();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GlobalUrl.apiKey);

  void _getPlaceDetails(suggestion) async {
    PlacesDetailsResponse response =
        await _places.getDetailsByPlaceId(suggestion.placeId);
    if (response.status == 'OK') {
      double latitude = response.result.geometry?.location.lat ?? 0.0;
      double longitude = response.result.geometry?.location.lng ?? 0.0;
      setState(() {
        _searchValue.text = suggestion.description;
        widget.finalPoints['Latitude'] = latitude.toString();
        widget.finalPoints['Longitude'] = longitude.toString();
        widget.finalPoints['Adress'] = suggestion.description;
        _validateAdresse('1');
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      height: 20,
      alignment: Alignment.center,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            child: TypeAheadField(
          suggestionsCallback: (pattern) async {
            return await Get.find<LocationController>()
                .searchLocation(context, pattern);
          },
          noItemsFoundBuilder: (BuildContext context) {
            return Text(
              "Aucun résultat trouvé",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Montserrat-Medium',
                color: Colors.black,
              ),
            );
          },
          itemBuilder: (context, Prediction suggestion) {
            return Container(
                child: Row(
              children: [
                Icon(Icons.location_on),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      suggestion.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ));
          },
          onSuggestionSelected: (Prediction suggestion) {
            _getPlaceDetails(suggestion);
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: _searchValue,
            textInputAction: TextInputAction.search,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Tapez l'adresse recherchée",
              border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).disabledColor,
                  ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        )),
      ),
    );
  }
}
