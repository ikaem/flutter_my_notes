// lib\extensions\build_context\loc.dart

import 'package:flutter/cupertino.dart' show BuildContext;
import "package:flutter_gen/gen_l10n/app_localizations.dart"
    show AppLocalizations;

extension Localization on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
