import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSelector extends StatelessWidget {
  static const List<String> _kOptions = <String>[
    'ciocia',
    'wytrzeźwiałka',
    'pg',
  ];

  const LocationSelector({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        height: 50,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) async {

              String search = textEditingValue.text;

              if (search == '') {
                return const Iterable<String>.empty();
              }
              
              String url = "http://192.168.1.121:8080/search.php?q=" + search;

              var request = Uri.parse(url);

              var response = await http.get(request);

              if (response.statusCode == 200) {

                  String resp = response.body;

                  // Parse the JSON string
                  List<dynamic> jsonData = json.decode(resp);

                  List<String> results = [];

                  // Extract points from the JSON
                  for(var data in jsonData){
                    print(data);
                      results.add(data["display_name"].toString());
                  }

                  Iterable<String> iter = results;
                  
                  return iter;
              }

              return const Iterable<String>.empty();
            },
            onSelected: (String selection) {
              debugPrint('You just selected $selection');
            },
          ),
        ),
      ),
    );
    //const Text("kurrrr");
    // return Autocomplete<String>(
    //   optionsBuilder: (TextEditingValue textEditingValue) {
    //     if (textEditingValue.text == '') {
    //       return const Iterable<String>.empty();
    //     }
    //     return _kOptions.where((String option) {
    //       return option.contains(textEditingValue.text.toLowerCase());
    //     });
    //   },
    //   onSelected: (String selection) {
    //     debugPrint('You just selected $selection');
    //   },
    // );
  }
}
