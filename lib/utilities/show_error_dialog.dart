import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Something is wrong"),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ]);
      });
}
