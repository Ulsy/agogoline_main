import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'data_helper.dart';

class CustomSuggestion {
  final String description;
  final String someOtherData;

  CustomSuggestion({
    required this.description,
    required this.someOtherData,
  });
}

class BrandSearchDialog extends StatefulWidget {
  Function(String) setBrand;
  String brandAndModel;
  BrandSearchDialog({
    required this.setBrand,
    required this.brandAndModel,
  });

  @override
  State<BrandSearchDialog> createState() => _BrandSearchDialog(
        setBrand: setBrand,
      );
}

class _BrandSearchDialog extends State<BrandSearchDialog> {
  Function(String) setBrand;
  _BrandSearchDialog({
    required this.setBrand,
  });

  List<String> _propositions = [];

  Future<List<String>> treatData(data) async {
    List<String> res = [];
    for (var item in data) {
      res.add(item['marque'] + " - " + item['modele']);
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchValue.text = widget.brandAndModel;
    });
  }

  Future<List<dynamic>> fetchDatapropositions(String value) async {
    var brand =
        (value.split(' - ')).length > 1 ? (value.split(' - '))[0] : value;
    var model =
        (value.split(' - ')).length > 1 ? (value.split(' - '))[1] : value;
    final data = await DataHelperCar.searchBrand(brand, model);

    return treatData(data);
  }

  final TextEditingController _searchValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          child: TypeAheadField<CustomSuggestion>(
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
            suggestionsCallback: (pattern) async {
              final results = await fetchDatapropositions(pattern);

              final customSuggestions = results
                  .map((result) => CustomSuggestion(
                      description: result, someOtherData: "Some data"))
                  .toList();
              return customSuggestions;
            },
            itemBuilder: (context, CustomSuggestion suggestion) {
              return Container(
                child: Row(
                  children: [
                    // Icon(Icons.car),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          suggestion.description,
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
                ),
              );
            },
            onSuggestionSelected: (CustomSuggestion suggestion) {
              _getBrand(suggestion);
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: _searchValue,
              textInputAction: TextInputAction.search,
              autofocus: false,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: "Marque - modele",
                border: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                      fontSize: 13,
                      fontFamily: 'Montserrat-Medium',
                      color: Colors.black,
                    ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getBrand(CustomSuggestion suggestion) {
    setState(() {
      _searchValue.text = suggestion.description;
    });
    widget.setBrand(suggestion.description);
  }
}
