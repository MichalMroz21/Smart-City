
import 'package:flutter/material.dart';

class Place extends StatefulWidget {
  const Place({super.key, required this.address,required this.onclick});
  
  final void Function(String address) onclick;
  final String address;  

  @override
  State<StatefulWidget> createState() {
    return _PlaceState();
  }


}

  class _PlaceState extends State<Place> {  
  
  @override
  Widget build(BuildContext context) {    
  
  return Column(children: [
    TextButton( child: Text(widget.address), 
    onPressed: ()=>{
      widget.onclick(widget.address)      
      })    
    ]);
  }



}