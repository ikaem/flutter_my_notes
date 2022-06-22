import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  Map<String, void> optionsBuilder() {
    // note how map is created - same as js object
    return {"OK": null};
  }

// TODO note that we are typing this
  return showGenericDialog<void>(
      context: context,
      title: "Something is wrong",
      content: text,
      optionsBuilder: optionsBuilder);
}
