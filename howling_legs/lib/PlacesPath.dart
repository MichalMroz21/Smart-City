import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:howling_legs/path_node.dart';

import 'Place.dart';

class PlacesPath extends StatefulWidget {
  const PlacesPath({super.key, required this.places, required this.markers, required this.onRemove});

  final List<Place> places;
  final Function(Place)? onRemove;
  final List<Marker> markers;

  @override
  State<StatefulWidget> createState() {
    return _PlacesPathtState();
  }
}

class _PlacesPathtState extends State<PlacesPath> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 8 / 9,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.places.asMap().entries
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PathNode(
                        place: e.value,
                        remove: () {
                          widget.markers.removeAt(e.key); //delete at index
                          widget.places.remove(e.value);
                          widget.onRemove!(e.value);                          
                          setState(() {});
                        },
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
