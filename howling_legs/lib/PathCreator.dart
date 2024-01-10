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
  final List<String> points=[];

  void addItemToList(String item) {
    setState(() {
      points.add(item);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(      
          children: [
            PlacesPath(points: points),                            
          ]
        ),
        Column(
          children: [
            PlacesList(points: [
              Place(address: 'aa', onclick: addItemToList),
              Place(address: 'bb', onclick: addItemToList)
            ])
          ],
        ) 
      ],
    );   
  }
}
