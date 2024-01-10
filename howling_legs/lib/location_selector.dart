import 'package:flutter/material.dart';
import 'package:howling_legs/PathCreator.dart';
import 'package:howling_legs/PlacesPath.dart';

import 'Place.dart';

class LocationSelector extends StatefulWidget {
  final PathCreator pathCreator;

  static const List<String> _kOptions = <String>[
    'ciocia',
    'wytrzeźwiałka',
    'pg',
  ];

  const LocationSelector({super.key, required this.pathCreator});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  List<Place> places = [
    Place(name: "pg"),
    Place(name: "wytrzeźwiałka"),
    Place(name: "ciocia"),
  ];

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
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return LocationSelector._kOptions.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      Place p = places.firstWhere((e) => e.name == selection);
                      setState(() {
                        places.add(p);
                      });
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
