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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              child:IconButton(
                icon: Icon(Icons.arrow_upward),
                color: Colors.black,
                onPressed: ()=>{}) 
            )                       
          ],
        )
      ]
    );   
  }
}
