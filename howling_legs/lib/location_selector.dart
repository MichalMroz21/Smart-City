import 'package:flutter/material.dart';
import 'package:howling_legs/PathCreator.dart';
import 'package:howling_legs/Place.dart';
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
  final List<Marker> markers;
  static Map<String, List<double>> locations = {};

  const LocationSelector(
      {super.key,
      required this.pathCreator,
      required this.mapController,
      required this.markers});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

enum Category {
  none('none', Icons.question_mark, Colors.grey),
  bank('bank', Icons.attach_money, Colors.green),
  hospital('hospital', Icons.local_hospital, Colors.red),
  pub('pub', Icons.local_bar, Colors.pink);

  const Category(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class _LocationSelectorState extends State<LocationSelector> {
  List<Place> places = [];
  String prompt = "";
  bool isCategory = false;
  String currCategory = "bank";
  TextEditingController categoryController =
      TextEditingController(text: "none");

  Map<String, Icon> categoryIconMap = {
    "none": Icon(Icons.question_mark),
    "bank": Icon(Icons.attach_money, size: 30.0, color: Colors.green),
    "hospital": Icon(Icons.local_hospital, size: 30.0, color: Colors.red),
    "pub": Icon(Icons.local_bar, size: 30.0, color: Colors.pink),
  };

  static void categoryChange(dynamic newCategory) {
    return;
  }

  void addMarker(double latitude, double longitude, Icon icon) {
    widget.markers.add(Marker(
      point: LatLng(latitude, longitude),
      width: 80,
      height: 80,
      child: icon,
    ));
  }

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
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Autocomplete<String>(
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          prompt = (currCategory == "none"
                              ? textEditingValue.text
                              : currCategory);
                          isCategory = (currCategory != "none");

                          if (prompt == '') {
                            return const Iterable<String>.empty();
                          }
                          Iterable<Place> promptedPlaces =
                              await Webservice.searchPrompts(
                                  prompt, isCategory);

                          if (isCategory) {
                            for (var promptedPlace in promptedPlaces) {
                              addMarker(
                                  promptedPlace.latitude,
                                  promptedPlace.longitude,
                                  categoryIconMap[currCategory]!);
                            }
                          }

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
                              await Webservice.searchPrompts(
                                  prompt, isCategory);
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
                  DropdownMenu<Category>(
                      initialSelection: Category.none,
                      inputDecorationTheme:
                          const InputDecorationTheme(border: null),
                      trailingIcon: Icon(
                        Category.values
                            .where((e) => e.label == currCategory)
                            .first
                            .icon,
                        color: Category.values
                            .where((e) => e.label == currCategory)
                            .first
                            .color,
                      ),
                      controller: categoryController,
                      menuStyle: const MenuStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 240, 234, 216))),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      onSelected: (value) {
                        setState(() {
                          currCategory = value!.label;
                        });
                      },
                      dropdownMenuEntries: Category.values
                          .map<DropdownMenuEntry<Category>>((Category icon) {
                        return DropdownMenuEntry<Category>(
                            value: icon,
                            label: icon.label,
                            leadingIcon: Icon(
                              icon.icon,
                              color: icon.color,
                            ));
                      }).toList()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
