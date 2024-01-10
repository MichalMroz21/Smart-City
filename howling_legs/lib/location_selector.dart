import 'package:flutter/material.dart';

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
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return _kOptions.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
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
