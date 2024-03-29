import 'package:flutter/material.dart';
import 'package:howling_legs/Place.dart';

class Option extends StatelessWidget {
  final String name;
  final Place place;
  final Function()? onClick;
  final Function()? onGoTo;

  const Option(
      {super.key,
      required this.name,
      required this.place,
      required this.onGoTo,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onClick,
          child: SizedBox(
            width: 500,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          textBaseline: null),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onGoTo,
          icon: const Icon(Icons.arrow_right_alt),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.amber),
          ),
        )
      ],
    );
  }
}
