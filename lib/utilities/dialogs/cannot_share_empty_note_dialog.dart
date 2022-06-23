import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(
  BuildContext context,
) {
  Map<String, void> optionsBuilder() {
    // note how map is created - same as js object
    return {"OK": null};
  }

// TODO note that we are typing this
  return showGenericDialog<void>(
      context: context,
      title: "Empty note",
      content: "Cannot share an empty note!",
      optionsBuilder: optionsBuilder);
}
