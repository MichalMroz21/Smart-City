import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final String name;
  final Function()? onClick;
  final Function()? onGoTo;

  const Option(
      {super.key,
      required this.name,
      required this.onGoTo,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          child: SizedBox(
            width: 500,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 15, color: Colors.black, textBaseline: null),
                ),
              ),
            ),
          ),
          onPressed: () {},
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
