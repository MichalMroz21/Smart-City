import 'package:flutter/material.dart';
import 'package:howling_legs/path_node.dart';

import 'Place.dart';

class PlacesPath extends StatefulWidget {
  const PlacesPath({super.key, required this.places});

  final List<Place> places;

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
            children: widget.places
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PathNode(
                        place: e,
                        remove: () {
                          widget.places.remove(e);
                          setState(() {});
                        },
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
