import 'package:flutter/material.dart';
import 'package:howling_legs/PathCreator.dart';
import 'package:howling_legs/PlacesPath.dart';
import 'package:howling_legs/option.dart';
import 'package:howling_legs/webservice.dart';

import 'Place.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class LocationSelector extends StatefulWidget {
  final PathCreator pathCreator;
  final MapController mapController;
  static Map<String, List<double>> locations = {};

  const LocationSelector(
      {super.key, required this.pathCreator, required this.mapController});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  List<Place> places = [];
  String prompt = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      prompt = textEditingValue.text;
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      Iterable<Place> promptedPlaces =
                          await Webservice.searchPrompts(textEditingValue.text);
                      return promptedPlaces.map((e) => e.name);
                      // {
                      //   return option
                      //       .contains(textEditingValue.text.toLowerCase());
                      // });
                      //;
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Column(
                        children: options
                            .map(
                              (e) => Option(
                                name: e,
                                onGoTo: () {
                                  debugPrint("eeee");
                                },
                                onClick: () {},
                              ),
                            )
                            .toList(),
                      );
                    },
                    onSelected: (String selection) async {
                      Iterable<Place> promptedPlaces =
                          await Webservice.searchPrompts(prompt);
                      setState(() {
                        places.add(promptedPlaces
                            .firstWhere((e) => e.name == selection));
                      });
                      //                       List<double> points = locations[selection]!;
                      // mapController.move(LatLng(points[0], points[1]), mapController.zoom);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            PlacesPath(places: places),
          ],
        ),
      ],
    );
  }
}
