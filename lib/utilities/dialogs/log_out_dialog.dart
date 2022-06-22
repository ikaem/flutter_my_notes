import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  Map<String, bool> optionsBuilder() {
    return {
      "No": false,
      "Yes": true,
    };
  }

  final result = await showGenericDialog<bool>(
      context: context,
      title: "Log out?",
      content: "Are you sure you want to log out?",
      optionsBuilder: optionsBuilder);

// this is because show generic dialog might actually return null
  return result ?? false;
}
