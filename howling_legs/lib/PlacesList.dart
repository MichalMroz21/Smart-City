import 'package:flutter/material.dart';
import 'Place.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  @override
  State<StatefulWidget> createState() {
    return _PathtState();
  }
}

class _PathtState extends State<PlacesList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: widget.places.map((e) => Text(e.name)).toList());
  }
}
