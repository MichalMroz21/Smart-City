import 'package:flutter/material.dart';

import 'Place.dart';

class PathNode extends StatelessWidget {
  final Place place;
  final Function()? remove;

  const PathNode({super.key, required this.place, this.remove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 20, 99, 43),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  place.name,
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
