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
  String currCategory = "none";
  TextEditingController categoryController =
      TextEditingController(text: "none");
  Map<String, List<double>> positions = {};
  Map<String, Marker> markerMap = {};
  Iterable<Place> promptedPlaces = [];

  Map<String, Icon> categoryIconMap = {
    "none": Icon(Icons.question_mark),
    "bank": Icon(Icons.attach_money, size: 30.0, color: Colors.green),
    "hospital": Icon(Icons.local_hospital, size: 30.0, color: Colors.red),
    "pub": Icon(Icons.local_bar, size: 30.0, color: Colors.pink),
  };

  static void categoryChange(dynamic newCategory) {
    return;
  }

  Marker addMarker(double latitude, double longitude, Icon icon) {
    Marker m = Marker(
      point: LatLng(latitude, longitude),
      width: 80,
      height: 80,
      child: icon,
    );
    widget.markers.add(m);
    return m;
  }

  Future<Iterable<String>> callBox(String str) async {
    prompt = (currCategory == "none"
        ? str
        : currCategory);
    isCategory = (currCategory != "none");

    if (prompt == '') {
      promptedPlaces = [];
      return const Iterable<String>.empty();
    }
    promptedPlaces = await Webservice.searchPrompts(
        prompt, isCategory);

    if (isCategory) {

      for (var promptedPlace in promptedPlaces) {
        if (isCategory){
          Marker m = addMarker(
              promptedPlace.latitude,
              promptedPlace.longitude,
              categoryIconMap[currCategory]!);

          markerMap[promptedPlace.name] = m;
        }
        positions[promptedPlace.name] = [
          promptedPlace.latitude,
          promptedPlace.longitude
        ];
        
      }

      return promptedPlaces.map((e) => e.name);
      // {
      //   return option
      //       .contains(textEditingValue.text.toLowerCase());
      // });
      //;
    }
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white70,
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
                          return callBox(textEditingValue.text);
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return SizedBox(
                            height: 100,
                            child: SingleChildScrollView(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: options
                                    .map(
                                      (e) => Option(
                                        name: e,
                                        place: promptedPlaces.firstWhere(
                                            (element) => element.name == e),
                                        onGoTo: () {
                                          List<double> pos = positions[e]!;
                                          widget.mapController.move(
                                              LatLng(pos[0], pos[1]),
                                              widget.mapController.zoom);
                                        },
                                        onClick: () {
                                          setState(() {
                                            Place p = promptedPlaces.firstWhere(
                                                (element) => element.name == e);
                                            debugPrint(p.name);
                                            places.add(p);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
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

                          for(var marker in markerMap.values){
                              int i = -1;

                              for(int j = 0; j < widget.markers.length; j++){
                                  if(widget.markers[j] == marker) { 
                                      i = j;
                                      break;
                                  }
                              }

                              if(i != -1) widget.markers.removeAt(i);
                          }

                          callBox(currCategory);
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
