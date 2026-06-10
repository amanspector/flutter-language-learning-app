import 'package:flutter/material.dart';

class AppShowloading {
  static void show(BuildContext context, Widget childwidget) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: childwidget),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
