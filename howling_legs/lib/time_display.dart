import 'package:flutter/material.dart';
import 'package:howling_legs/webservice.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Text(
          (Webservice.time / 60000).toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
