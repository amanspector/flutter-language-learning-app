import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:flutter/material.dart';

class CustomShapeContainter extends StatelessWidget {
  final Widget child;
  const CustomShapeContainter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: TicketPainter(), child: child);
  }
}

class TicketPainter extends CustomPainter {
  final double cornerRadius;
  final double concaveDepth; // How deep the inward curve goes, e.g. 0.04
  final Color color;
  final Color? glowColor;
  final Color borderColor;
  final double borderWidth;

  const TicketPainter({
    this.cornerRadius = 40,
    this.concaveDepth = 18, // pixels of inward curve
    this.color = ColorConstant.colorWhite,
    this.glowColor,
    this.borderColor = ColorConstant.colorTransparent,
    this.borderWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    canvas.drawShadow(
      path,
      ColorConstant.colorBlack.withValues(alpha: 0.18),
      12.0,
      false,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    if (glowColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..shader = RadialGradient(
            colors: [
              glowColor!.withValues(alpha: 0.3),
              glowColor!.withValues(alpha: 0.0),
            ],
            radius: 0.8,
            center: Alignment.topRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }

    if (borderColor != Colors.transparent && borderWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  Path _buildPath(Size size) {
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;

    final d = concaveDepth;

    final path = Path();

    path.moveTo(r, 0);

    // Top edge: concave
    path.cubicTo(w * 0.25, d, w * 0.75, d, w - r, 0);

    // Top-right corner
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);

    // Right edge
    path.lineTo(w, h - r);

    // Bottom-right corner
    path.arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Bottom edge: concave
    path.cubicTo(w * 0.75, h - d, w * 0.25, h - d, r, h);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, h - r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Left edge
    path.lineTo(0, r);

    // Top-left corner
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant TicketPainter oldDelegate) =>
      oldDelegate.concaveDepth != concaveDepth ||
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.color != color ||
      oldDelegate.glowColor != glowColor;
}
