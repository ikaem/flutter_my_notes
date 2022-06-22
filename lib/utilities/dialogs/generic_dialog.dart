import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>(
    {required BuildContext context,
    required String title,
    required String content,
    required DialogOptionBuilder optionsBuilder}) {
  // getting optiosn from the function
  final options = optionsBuilder();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: options.keys.map((option) {
              final T value = options[option];

              return TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(value);
                  },
                  child: Text(option));
            }).toList());
      });
}
