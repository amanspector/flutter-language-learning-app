import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AppHapticCounter extends StatefulWidget {
  final int begin;
  final int end;
  final Duration? duration;
  final int currentStep;
  final int myStep;
  final VoidCallback? onComplete;
  final Widget Function(BuildContext context, int value) builder;

  const AppHapticCounter({
    super.key,
    this.begin = 0,
    required this.end,
    this.duration,
    required this.currentStep,
    required this.myStep,
    this.onComplete,
    required this.builder,
  });

  @override
  State<AppHapticCounter> createState() => _AppHapticCounterState();
}

class _AppHapticCounterState extends State<AppHapticCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _lastVibratedValue = -1;
  DateTime _lastVibrationTime = DateTime(0);

  Duration get _effectiveDuration {
    if (widget.duration != null) return widget.duration!;
    final difference = (widget.end - widget.begin).abs();
    final durationMs = (400 + (difference * 30)).clamp(400, 1500);
    return Duration(milliseconds: durationMs);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _effectiveDuration,
    );

    _animation = IntTween(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.addListener(() {
      final value = _animation.value;
      if (value == _lastVibratedValue) return;
      _lastVibratedValue = value;
      if (value <= widget.begin) return;

      if (_controller.isCompleted) {
        Vibration.vibrate(
          pattern: [0, 40, 60, 40],
          intensities: [0, 255, 0, 255],
        );
      } else {
        final now = DateTime.now();
        final progress = _controller.value;
        final currentGap = (220 - (progress * 140)).round();

        if (now.difference(_lastVibrationTime).inMilliseconds >= currentGap) {
          _lastVibrationTime = now;
          final amplitude = (40 + (progress * 215)).round().clamp(1, 255);
          Vibration.vibrate(amplitude: amplitude);
        }
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.currentStep == widget.myStep) {
      _start();
    }
  }

  @override
  void didUpdateWidget(covariant AppHapticCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep == widget.myStep &&
        oldWidget.currentStep != widget.myStep) {
      _start();
    } else if (widget.currentStep != widget.myStep &&
        oldWidget.currentStep == widget.myStep) {
      _controller.reset();
    }
  }

  void _start() {
    _lastVibratedValue = -1;
    _lastVibrationTime = DateTime(0);
    _controller.duration = _effectiveDuration;
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentStep < widget.myStep) {
      return widget.builder(context, widget.begin);
    }
    if (widget.currentStep > widget.myStep) {
      return widget.builder(context, widget.end);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return widget.builder(context, _animation.value);
      },
    );
  }
}
