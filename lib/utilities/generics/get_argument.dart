import 'package:flutter/cupertino.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    // this is cotnext of build context i guess?
    // or is it context of cotnext at the place where we call this?
    final modalRoute = ModalRoute.of(this);
    if (modalRoute == null) return null;

    final args = modalRoute.settings.arguments;
    if (args == null) return null;
    // two cool things here - is!, and is operator itself that checks for type match
    if (args is! T) return null;

    return args as T;
  }
}
