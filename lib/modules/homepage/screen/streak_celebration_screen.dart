import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/services/haptic_service.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';

class StreakCelebrationScreen extends StatefulWidget {
  const StreakCelebrationScreen({super.key});

  @override
  State<StreakCelebrationScreen> createState() =>
      _StreakCelebrationScreenState();
}

class _StreakCelebrationScreenState extends State<StreakCelebrationScreen>
    with TickerProviderStateMixin {
  bool _isCountCompleted = false;
  bool _showLottie = false;
  AnimationController? _lottieController;
  late final ConfettiController _confettiController;
  late final List<DateTime> _weekDays;
  final List<String> _labels = ["M", "T", "W", "T", "F", "S", "S"];
  final List<Timer> _hapticTimers = [];

  @override
  void initState() {
    super.initState();
    // Calculate week days (Monday to Sunday)
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final monday = todayMidnight.subtract(
      Duration(days: todayMidnight.weekday - 1),
    );
    _weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));

    // Light haptics for each dot appearing (spaced 80ms apart)
    for (int i = 0; i < 7; i++) {
      _hapticTimers.add(
        Timer(Duration(milliseconds: 80 * i), () {
          if (mounted) {
            AppHapticService.vibrate(duration: 15);
          }
        }),
      );
    }

    _lottieController = AnimationController(vsync: this);
    _lottieController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showLottie = false;
        });
      }
    });

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    for (final timer in _hapticTimers) {
      timer.cancel();
    }
    _lottieController?.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onCountUpComplete() {
    setState(() {
      _isCountCompleted = true;
      _showLottie = true;
    });
    _confettiController.play();
    // Heavy haptic feedback on streak count-up complete
    AppHapticService.vibrate(pattern: [0, 80], intensities: [0, 255]);
  }

  String _getDayState(DateTime day, Map<String, String> weekHistory) {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final dayMidnight = DateTime(day.year, day.month, day.day);
    final dayStr = DateFormat('yyyy-MM-dd').format(day);

    if (dayMidnight.isAfter(todayMidnight)) {
      return 'future';
    } else if (dayMidnight.isAtSameMomentAs(todayMidnight)) {
      if (weekHistory[dayStr] == 'completed') {
        return 'completed';
      }
      return 'pending';
    } else {
      if (weekHistory[dayStr] == 'completed') {
        return 'completed';
      } else if (weekHistory[dayStr] == 'freeze') {
        return 'freeze';
      } else {
        return 'missed';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomescreenProvider>(
      context,
      listen: false,
    );
    final streak = homeProvider.currentStreak;
    final weekHistory = homeProvider.weekHistory;
    final now = DateTime.now();

    return AppScreen(
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragEnd: (details) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Homescreen()),
                (route) => false,
              );
            },
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Homescreen()),
                (route) => false,
              );
            },
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 20.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),

                              // 1. Lottie Fire Animation with pulsing background glow
                              SizedBox(
                                height: 220.h,
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Soft glowing background circle
                                    Container(
                                          width: 140.w,
                                          height: 140.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                Colors.orange.withValues(
                                                  alpha: 0.35,
                                                ),
                                                Colors.orange.withValues(
                                                  alpha: 0.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true),
                                        )
                                        .scale(
                                          begin: const Offset(0.85, 0.85),
                                          end: const Offset(1.2, 1.2),
                                          duration: 1800.ms,
                                          curve: Curves.easeInOut,
                                        ),
                                    Lottie.asset(
                                      'assets/lottie/fire.json',
                                      width: 220.w,
                                      height: 220.h,
                                      repeat: true,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // 2. Streak text with Count Up Animation
                              AnimatedStreakText(
                                streak: streak,
                                isCountCompleted: _isCountCompleted,
                                onComplete: _onCountUpComplete,
                              ),
                              SizedBox(height: 12.h),

                              // 3. Subtitle text
                              AnimatedOpacity(
                                opacity: _isCountCompleted ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  "Keep the flame alive!",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: context.colors.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2),

                              // 4. Week dots row enclosed in a premium card container
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surface.withValues(
                                    alpha: 0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: context.colors.outline.withValues(
                                      alpha: 0.12,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.shadow.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(7, (index) {
                                    final day = _weekDays[index];
                                    final state = _getDayState(
                                      day,
                                      weekHistory,
                                    );
                                    final label = _labels[index];
                                    final isToday =
                                        day.year == now.year &&
                                        day.month == now.month &&
                                        day.day == now.day;
                                    return _buildWeekDayDot(
                                      index,
                                      label,
                                      state,
                                      isToday,
                                    );
                                  }),
                                ),
                              ),
                              const Spacer(flex: 3),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Confetti blowing from the top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                ColorConstant.colorGreen,
                ColorConstant.colorBlue,
                ColorConstant.colorPink,
                ColorConstant.colorOrange,
                ColorConstant.colorPurple,
              ],
            ),
          ),
          // Celebration Lottie of emoji 🎉 in the center
          if (_showLottie)
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/lottie/celebration.json',
                  controller: _lottieController,
                  onLoaded: (composition) {
                    _lottieController!.duration = composition.duration;
                    _lottieController!.forward(from: 0.0);
                  },
                  width: 250.w,
                  height: 250.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekDayDot(int index, String label, String state, bool isToday) {
    Widget dotWidget;
    final delay = (80 * index).ms;

    switch (state) {
      case 'completed':
        dotWidget = Container(
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.45),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 20,
          ),
        ).animate().flip(delay: delay + 100.ms, duration: 600.ms);
        break;
      case 'freeze':
        dotWidget =
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xFF29B6F6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF29B6F6).withValues(alpha: 0.45),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.ac_unit_rounded,
                color: Colors.white,
                size: 20,
              ),
            ).animate().shake(
              hz: 4,
              rotation: 0.15,
              duration: 600.ms,
              delay: delay + 200.ms,
            );
        break;
      case 'pending':
        dotWidget =
            Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.primary, width: 2),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .boxShadow(
                  begin: BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                  end: BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  duration: 1.seconds,
                );
        break;
      case 'future':
      case 'missed':
      default:
        dotWidget = Container(
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.onSurface.withValues(alpha: 0.05),
            border: Border.all(
              color: context.colors.onSurface.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
        );
        break;
    }

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isToday
                    ? context.colors.primary
                    : context.colors.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            dotWidget,
          ],
        )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .scale(delay: delay, duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class AnimatedStreakText extends StatefulWidget {
  final int streak;
  final bool isCountCompleted;
  final VoidCallback onComplete;

  const AnimatedStreakText({
    super.key,
    required this.streak,
    required this.isCountCompleted,
    required this.onComplete,
  });

  @override
  State<AnimatedStreakText> createState() => _AnimatedStreakTextState();
}

class _AnimatedStreakTextState extends State<AnimatedStreakText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation =
        IntTween(begin: 0, end: widget.streak).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.onComplete();
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          "${_animation.value} Day Streak!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
            color: context.colors.onSurface,
          ),
        );
      },
    );

    if (widget.isCountCompleted) {
      textWidget = textWidget
          .animate()
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.12, 1.12),
            duration: 450.ms,
            curve: Curves.elasticOut,
          )
          .then()
          .shimmer(
            duration: const Duration(milliseconds: 1500),
            color: Colors.orange.withValues(alpha: 0.4),
          );
    }

    return textWidget;
  }
}
