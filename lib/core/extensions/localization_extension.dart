import 'package:chatbot_app/generated/l10n.dart';
import 'package:flutter/material.dart';

extension LocalizationX on BuildContext {
  S get l10n => S.of(this);
}
