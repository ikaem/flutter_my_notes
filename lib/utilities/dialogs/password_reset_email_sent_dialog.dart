import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(
  BuildContext context,
) {
  Map<String, void> optionsBuilder() {
    // note how map is created - same as js object
    return {"OK": null};
  }

// TODO note that we are typing this
  return showGenericDialog<void>(
      context: context,
      title: "Password reset",
      content: "Link for password reset has been sent to you",
      optionsBuilder: optionsBuilder);
}
