import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) async {
  Map<String, bool> optionsBuilder() {
    return {
      "Yes": true,
      "No": false,
    };
  }

  final result = await showGenericDialog<bool>(
      context: context,
      title: "Delete",
      content: "Are you sure you want to delete this item?",
      optionsBuilder: optionsBuilder);

  return result ?? false;
}
