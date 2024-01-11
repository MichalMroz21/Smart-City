import 'package:flutter/material.dart';
import 'package:howling_legs/PlacesList.dart';
import 'PlacesPath.dart';
import 'Place.dart';

class PathCreator extends StatefulWidget {
  const PathCreator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PathtCreatorState();
  }
}

class _PathtCreatorState extends State<PathCreator> {
  final List<Place> places = [];

  void addItemToList(Place item) {
    if (places.length < 10) {
      setState(() {
        places.add(item);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Maximum places reached!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          PlacesPath(places: places),
        ]),
        // Column(
        //   children: [
        //     // PlacesList(points: [
        //     //   Place(),
        //     //   Place(address: 'bb', onclick: addItemToList)
        //     // ])
        //   ],
        // )
      ],
    );
  }
}
