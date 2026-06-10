import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final DrawerCallback? onDrawerChanged;
  const AppScreen({
    super.key,
    required this.body,
    this.appBar,
    this.onDrawerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.theme.colorScheme.secondaryContainer,
              context.theme.colorScheme.onPrimary,
            ], // Sharp split exactly in the middle
            stops: [0.1, 0.7],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          onDrawerChanged: onDrawerChanged,
          appBar: appBar,
          body: body,
          backgroundColor: ColorConstant.colorTransparent,
        ),
      ),
    );
  }
}
