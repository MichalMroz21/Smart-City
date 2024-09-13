import 'package:flutter/material.dart';

import 'Place.dart';

class PathNode extends StatelessWidget {
  final Place place;
  final Function()? remove;

  const PathNode({super.key, required this.place, this.remove});

  @override
  Widget build(BuildContext context) {
    List<String> strings = place.name.split(',');
    String result = "";
    result += strings[0];
    if (strings.length > 1) {
      result += ", ${strings[1]}";
    }
    if (strings.length > 2) {
      result += ", ${strings[2]}";
    }
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                onPressed: remove)),
      ],
    );
  }
}
