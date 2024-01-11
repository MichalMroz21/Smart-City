import 'package:flutter/material.dart';
import 'package:howling_legs/webservice.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text((Webservice.time / 60000).toString()),
    );
  }
}
