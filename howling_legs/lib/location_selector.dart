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
  final Function(List<Place>)? onDraw;

  const LocationSelector({
    super.key,
    required this.pathCreator,
    required this.mapController,
    required this.markers,
    required this.onDraw,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

enum Category {
  none('category', Icons.location_pin, Colors.grey),
  bank('bank', Icons.attach_money, Colors.green),
  hospital('hospital', Icons.local_hospital, Colors.red),
  pub('pub', Icons.local_bar, Colors.pink),
  shop('shop', Icons.shop, Colors.amber),
  postOffice('post_office', Icons.local_post_office, Colors.deepPurple);

  const Category(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class _LocationSelectorState extends State<LocationSelector> {
  List<Place> places = [];
  String prompt = "";
  bool isCategory = false;
  String currCategory = "category";
  TextEditingController categoryController =
      TextEditingController(text: "category");
  Map<String, List<double>> positions = {};
  Map<String, Marker> markerMap = {};
  Iterable<Place> promptedPlaces = [];

  Map<String, Widget> categoryIconMap = {
    "category": const CircleAvatar(
      backgroundColor: Colors.red,
      child: Icon(Icons.location_pin, size: 20.0, color: Colors.white),
    ),
    "bank": const CircleAvatar(
      backgroundColor: Colors.green,
      child: Icon(Icons.attach_money, size: 20.0, color: Colors.white),
    ),
    "hospital": const CircleAvatar(
      backgroundColor: Colors.red,
      child: Icon(Icons.local_hospital, size: 20.0, color: Colors.white),
    ),
    "pub": const CircleAvatar(
      backgroundColor: Colors.pink,
      child: Icon(Icons.local_bar, size: 20.0, color: Colors.white),
    )
  };

  static void categoryChange(dynamic newCategory) {
    return;
  }

  void addMarker(double latitude, double longitude, Widget icon,{width = 80, height = 80}) {
    widget.markers.add(Marker(
      point: LatLng(latitude, longitude),
      width: width,
      height: height,
      child: icon,
    ));
  }

  void addPlace(Place item) {
    if (places.length < 10) {
      setState(() {
        places.add(item);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Maximum places reached!")));
    }
  }

  Future<Iterable<String>> callBox(String str) async {
    prompt = (currCategory == "category" ? str : currCategory);
    isCategory = (currCategory != "category");

    if (prompt == '') {
      promptedPlaces = [];
      return const Iterable<String>.empty();
    }

    if (isCategory) {
      promptedPlaces = await Webservice.searchByCategory(currCategory);
      for (var promptedPlace in promptedPlaces) {
        if (isCategory) {
          addMarker(promptedPlace.latitude, promptedPlace.longitude,
              categoryIconMap[currCategory]!,
              width: 30,
              height: 30);
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
    } else {
      promptedPlaces = await Webservice.searchPrompts(prompt, false);
      return promptedPlaces.map((e) => e.name);
    }
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 400,
                          child: FocusScope(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) async {
                                  return callBox(textEditingValue.text);
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Column(
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
                                                Place p = promptedPlaces
                                                    .firstWhere((element) =>
                                                        element.name == e);
                                                debugPrint(p.name);
                                                addPlace(p);
                                                widget.onDraw!(places);
                                              });
                                            },
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                                onSelected: (String selection) async {
                                  final FocusNode focus = Focus.of(context);
                                  final bool hasFocus = focus.hasFocus;
                                  Iterable<Place> promptedPlaces =
                                      await Webservice.searchPrompts(
                                          prompt, isCategory);
                                  setState(() {
                                    promptedPlaces = [];
                                    places.add(promptedPlaces.firstWhere(
                                        (e) => e.name == selection));
                                    if (hasFocus) {
                                      focus.unfocus();
                                    }
                                  });
                                  //                       List<double> points = locations[selection]!;
                                  // mapController.move(LatLng(points[0], points[1]), mapController.zoom);
                                },
                              ),
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
                                widget.markers.clear();
                                callBox(currCategory);
                              });
                            },
                            dropdownMenuEntries: Category.values
                                .map<DropdownMenuEntry<Category>>(
                                    (Category icon) {
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: PlacesPath(
              places: places,
              onRemove: (p) {
                setState(() {
                  places.remove(p);
                  widget.onDraw!(places);
                });
              },
              markers: widget.markers,
            ),
          ),
        ],
      ),
    );
  }
}
