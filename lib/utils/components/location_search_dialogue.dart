import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import '../../controller/location_controller_provider.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  final Function(String) onSuggestionSelected;

  const LocationSearchDialog({
    required this.mapController,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationControllerProvider>(context);

    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 55),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: 'Search Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 15,
                      ),
                ),
                suggestionsCallback: (pattern) async {
                  return await locationController.searchLocation(
                      context, pattern);
                },
                itemBuilder: (context, Prediction suggestion) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      const Icon(Icons.location_on),
                      Expanded(
                        child: Text(suggestion.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                  fontSize: 15,
                                )),
                      ),
                    ]),
                  );
                },
                onSuggestionSelected: (Prediction suggestion) {
                  print("My location is " + suggestion.description!);
                  onSuggestionSelected(suggestion.description!);

                  Navigator.of(context).pop();
                },
              ),
            )),
      ),
    );
  }
}
