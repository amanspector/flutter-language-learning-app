// import 'package:chatbot_app/core/appconstants/color_constant.dart';
// import 'package:chiclet/chiclet.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class AppButton1 extends StatelessWidget {
//   VoidCallback buttonFunc;
//   Widget childWidget;
//   Color? buttoncolor;
//   Color? backgroundColor;
//   Color? borderColor;
//   double? width;
//   double? height;
//   bool? isPressed;
//   AppButton1({
//     super.key,
//     required this.buttonFunc,
//     required this.childWidget,
//     this.backgroundColor,
//     this.borderColor,
//     this.buttoncolor,
//     this.width,
//     this.height,
//     this.isPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ChicletOutlinedAnimatedButton(
//       height: height ?? 50,
//       width: width ?? MediaQuery.widthOf(context),
//       borderColor: borderColor ?? context.theme.colorScheme.primary,
//       borderWidth: 2,
//       buttonColor:
//           buttoncolor ?? context.theme.colorScheme.onPrimaryContainer,
//       backgroundColor: backgroundColor ?? context.theme.colorScheme.primary,
//       onPressed: buttonFunc,
//       buttonType: ChicletButtonTypes.roundedRectangle,
//       child: childWidget,
//     );
//   }
// }
