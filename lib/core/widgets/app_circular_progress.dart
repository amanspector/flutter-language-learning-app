import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCircularProgress extends StatelessWidget {
  final int score;
  final int total;
  final double? size;
  final double? strokeWidth;
  final Color? progressColor;
  final bool showPercentage;
  final TextStyle? labelStyle;

  const AppCircularProgress({
    super.key,
    required this.score,
    required this.total,
    this.size,
    this.strokeWidth,
    this.progressColor,
    this.showPercentage = false,
    this.labelStyle,
  });

  Color _scoreColor() {
    final percentage = total == 0 ? 0.0 : (score / total) * 100;
    if (percentage >= 90) return ColorConstant.green400;
    if (percentage >= 75) return ColorConstant.blue400;
    if (percentage >= 60) return ColorConstant.orange400;
    return ColorConstant.red400;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : (score / total) * 100;
    final color = progressColor ?? _scoreColor();
    final double stroke = strokeWidth ?? (size ?? 56.r) * 0.15;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percentage),
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        final animateValue = animated.clamp(0.0, 100.0);
        return SizedBox(
          width: size ?? 56.r,
          height: size ?? 56.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  centerSpaceRadius: (size ?? 56.r) * 0.34,
                  sections: [
                    PieChartSectionData(
                      cornerRadius: 4,
                      value: animateValue,
                      color: color,
                      radius: stroke,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 100 - animateValue,
                      color: context.theme.colorScheme.outline.withValues(
                        alpha: 0.15,
                      ),
                      radius: stroke,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showPercentage)
                    Text(
                      '${animated.toStringAsFixed(0)}%',
                      style:
                          labelStyle ??
                          context.text.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                  Text(
                    '$score/$total',
                    style: context.text.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: showPercentage
                          ? context.theme.colorScheme.outline
                          : color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
