import 'dart:math';

import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:fluid_background/fluid_background.dart';
import 'package:flutter/material.dart';

class AnimatedMeshBackground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateAnimatedMeshBackground();
}

class _StateAnimatedMeshBackground extends State<AnimatedMeshBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshPainter(animationvalue: _controller.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double animationvalue;
  _MeshPainter({required this.animationvalue});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      ColorConstant.color_bluelight_shade,

      ColorConstant.color_blue_shade,
      ColorConstant.color_bluelight_shade,
    ];
    final t = animationvalue * 2 * pi;

    final positions = [
      Offset(
        size.width * (0.3 + 0.25 * sin(t)),
        size.height * (0.15 + 0.05 * cos(t)),
      ),
      Offset(
        size.width * (0.6 + 0.25 * sin(t + 1.5)),
        size.height * (0.20 + 0.05 * cos(t + 1.2)),
      ),
      Offset(
        size.width * (0.8 + 0.20 * sin(t + 2.3)),
        size.height * (0.18 + 0.04 * cos(t + 1.8)),
      ),
      // Offset(
      //   size.width * (0.4 + 0.22 * sin(t + 3.1)),
      //   size.height * (0.12 + 0.06 * cos(t + 2.6)),
      // ),
    ];
    for (int i = 0; i < positions.length; i++) {
      final color = colors[i % colors.length];

      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.9),
              ],
            ).createShader(
              Rect.fromCircle(center: positions[i], radius: size.width * 0.6),
            )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);

      canvas.drawCircle(positions[i], size.width * 0.5, paint);
    }
  }

  @override
  bool shouldRebuildSemantics(covariant _MeshPainter oldDelegate) {
    return oldDelegate.animationvalue != animationvalue;
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) {
    return oldDelegate.animationvalue != animationvalue;
  }
}
