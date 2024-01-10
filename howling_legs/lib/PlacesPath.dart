
import 'package:flutter/material.dart';


class PlacesPath extends StatefulWidget {
  const PlacesPath({super.key, required this.points});
  
  final List<String> points;      

  @override
  State<StatefulWidget> createState() {
    return _PlacesPathtState();
  }  
}

  class _PlacesPathtState extends State<PlacesPath> {  

  
  @override
  Widget build(BuildContext context) {        
  
    return Column(
      children: widget.points.map(
        (e) => Text(e)

        /* for drawing with icons 
        (e) => CircleAvatar(
              backgroundColor: Colors.green,
              child:IconButton(
                icon: Icon(Icons.bakery_dining),
                color: Colors.black,
                onPressed: ()=>{}) 
            )
        
         */
        ).toList()
    );
  }


}