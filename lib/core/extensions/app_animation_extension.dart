import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension WidgetExtensions on Widget {
  // ─────────────────────────────────────────────
  // 1. FADE + SLIDE COMBOS
  // ─────────────────────────────────────────────

  /// Fade in while sliding up from below
  Widget get fadeInSlideUp => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);

  /// Fade in while sliding down from above
  Widget get fadeInSlideDown => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideY(begin: -0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);

  /// Fade in while sliding in from the left
  Widget get fadeInSlideLeft => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideX(begin: -0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);

  /// Fade in while sliding in from the right
  Widget get fadeInSlideRight => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideX(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);

  // ─────────────────────────────────────────────
  // 2. SCALE ANIMATIONS
  // ─────────────────────────────────────────────

  /// Fade in and scale up with elastic overshoot
  Widget get fadeInScale => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 600.ms,
        curve: Curves.elasticOut,
      );

  /// Pop in from zero scale — like a tooltip appearing
  Widget get popIn => animate()
      .fadeIn(duration: 300.ms)
      .scale(
        begin: Offset.zero,
        end: const Offset(1, 1),
        duration: 400.ms,
        curve: Curves.elasticOut,
      );

  /// Scale down and fade out — like dismissing a chip
  Widget get popOut => animate()
      .fadeOut(duration: 300.ms)
      .scale(
        begin: const Offset(1, 1),
        end: Offset.zero,
        duration: 300.ms,
        curve: Curves.easeIn,
      );

  /// Heartbeat pulse — scale up then back
  Widget get heartbeat =>
      animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
        begin: const Offset(1, 1),
        end: const Offset(1.12, 1.12),
        duration: 700.ms,
        curve: Curves.easeInOut,
      );

  /// Soft breathe — gentle continuous scale loop
  Widget get breathe =>
      animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
        begin: const Offset(0.97, 0.97),
        end: const Offset(1.03, 1.03),
        duration: 1800.ms,
        curve: Curves.easeInOut,
      );

  // ─────────────────────────────────────────────
  // 3. ROTATE ANIMATIONS
  // ─────────────────────────────────────────────

  /// Fade in with a subtle clockwise rotation
  Widget get fadeInRotate => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .rotate(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.elasticOut);

  /// Continuous clockwise spin — good for loaders
  Widget get spin => animate(
    onPlay: (controller) => controller.repeat(),
  ).rotate(duration: 1200.ms, curve: Curves.linear);

  /// Wiggle left–right — attention grabber
  Widget get wiggle => animate(
    onPlay: (controller) => controller.repeat(reverse: true),
  ).rotate(begin: -0.05, end: 0.05, duration: 200.ms, curve: Curves.easeInOut);

  /// Single flip on the Y axis (360°)
  Widget get flipY => animate().rotate(
    begin: -1,
    end: 0,
    duration: 700.ms,
    curve: Curves.easeOut,
  );

  // ─────────────────────────────────────────────
  // 4. BOUNCE ANIMATIONS
  // ─────────────────────────────────────────────

  /// Fade in and drop with a natural bounce at landing
  Widget get fadeInBounce => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideY(begin: -0.5, end: 0, duration: 600.ms, curve: Curves.bounceOut);

  /// Elastic snap up from below
  Widget get elasticIn => animate()
      .fadeIn(duration: 800.ms, curve: Curves.elasticOut)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 800.ms,
        curve: Curves.elasticOut,
      );

  /// Continuous vertical bounce loop — like a notification dot
  Widget get bouncingDot => animate(
    onPlay: (controller) => controller.repeat(reverse: true),
  ).slideY(begin: 0, end: -0.3, duration: 500.ms, curve: Curves.easeInOut);

  // ─────────────────────────────────────────────
  // 5. SLIDE ONLY
  // ─────────────────────────────────────────────

  Widget get slideInFromTop => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideY(begin: -0.5, end: 0, duration: 600.ms, curve: Curves.easeOut);

  Widget get slideInFromBottom => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOut);

  Widget get slideInFromLeft => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideX(begin: -0.5, end: 0, duration: 600.ms, curve: Curves.easeOut);

  Widget get slideInFromRight => animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
      .slideX(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOut);

  /// Slide out to the left (for dismiss / swipe-away)
  Widget get slideOutLeft => animate()
      .fadeOut(duration: 400.ms)
      .slideX(begin: 0, end: -1, duration: 400.ms, curve: Curves.easeIn);

  /// Slide out to the right
  Widget get slideOutRight => animate()
      .fadeOut(duration: 400.ms)
      .slideX(begin: 0, end: 1, duration: 400.ms, curve: Curves.easeIn);

  /// Slide out upward
  Widget get slideOutUp => animate()
      .fadeOut(duration: 400.ms)
      .slideY(begin: 0, end: -1, duration: 400.ms, curve: Curves.easeIn);

  /// Slide out downward
  Widget get slideOutDown => animate()
      .fadeOut(duration: 400.ms)
      .slideY(begin: 0, end: 1, duration: 400.ms, curve: Curves.easeIn);

  // ─────────────────────────────────────────────
  // 6. SHIMMER / GLINT
  // ─────────────────────────────────────────────

  /// Classic loading shimmer (repeat loop)
  Widget shimmerLoading(BuildContext context) => animate(
    onPlay: (controller) => controller.repeat(),
  ).shimmer(duration: 1800.ms, color: Colors.white.withValues(alpha: 0.25));

  /// Gold glint effect — great for premium UI highlights
  Widget get goldGlint =>
      animate(
        onPlay: (controller) => controller.repeat(reverse: false),
      ).shimmer(
        delay: 1200.ms,
        duration: 1000.ms,
        color: const Color(0xFFFFD700).withValues(alpha: 0.5),
        size: 0.4,
      );

  // ─────────────────────────────────────────────
  // 7. COLOR / TINT ANIMATIONS
  // ─────────────────────────────────────────────

  /// Tint to a target color then back — like a validation flash
  Widget colorFlash({Color color = Colors.redAccent}) => animate()
      .tint(color: color, duration: 300.ms)
      .tint(color: Colors.transparent, duration: 300.ms, delay: 300.ms);

  /// Success green pulse
  Widget get successFlash => animate()
      .scaleXY(begin: 1.0, end: 1.04, duration: 180.ms)
      .tint(color: ColorConstant.colorGreen, duration: 250.ms)
      .tint(color: Colors.transparent, duration: 300.ms, delay: 250.ms);

  /// Error red shake-and-flash combo
  Widget get errorShake => animate()
      .tint(color: Colors.redAccent, duration: 200.ms)
      .shakeX(amount: 6, duration: 400.ms)
      .tint(color: Colors.transparent, duration: 200.ms, delay: 400.ms);

  // ─────────────────────────────────────────────
  // 8. BLUR ANIMATIONS
  // ─────────────────────────────────────────────

  /// Fade in from blurred state — cinematic reveal
  Widget get blurIn => animate()
      .blur(begin: const Offset(12, 12), end: Offset.zero, duration: 700.ms)
      .fadeIn(duration: 700.ms);

  /// Blur out and fade — like closing a modal background
  Widget get blurOut => animate()
      .blur(begin: Offset.zero, end: const Offset(10, 10), duration: 500.ms)
      .fadeOut(duration: 500.ms);

  /// Soft focus-in — starts slightly blurred, sharpens on enter
  Widget get softFocusIn => animate()
      .blur(
        begin: const Offset(4, 4),
        end: Offset.zero,
        duration: 500.ms,
        curve: Curves.easeOut,
      )
      .fadeIn(duration: 500.ms, curve: Curves.easeOut);

  Widget vocabCardTransition({
    Object? transitionKey,
    bool isGoingForward = true,
  }) {
    final currentKey = ValueKey(transitionKey ?? hashCode);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final isIncoming = child.key == currentKey;

        final Offset beginOffset;
        if (isIncoming) {
          beginOffset = isGoingForward
              ? const Offset(1, 0)
              : const Offset(-1, 0);
        } else {
          beginOffset = isGoingForward
              ? const Offset(-1, 0)
              : const Offset(1, 0);
        }

        final slideAnim = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return SlideTransition(position: slideAnim, child: child);
      },
      child: KeyedSubtree(key: currentKey, child: this),
    );
  }

  // ─────────────────────────────────────────────
  // 9. SHAKE ANIMATIONS
  // ─────────────────────────────────────────────

  /// Horizontal shake — wrong input / error feedback
  Widget get shakeHorizontal =>
      animate().shakeX(amount: 8, duration: 500.ms, hz: 4);

  /// Vertical shake — less common, good for rejection nudge
  Widget get shakeVertical =>
      animate().shakeY(amount: 6, duration: 500.ms, hz: 4);

  // ─────────────────────────────────────────────
  // 10. FLIP ANIMATIONS
  // ─────────────────────────────────────────────

  /// Flip card reveal from invisible to full view
  Widget get flipInX => animate()
      .flipV(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
      .fadeIn(duration: 400.ms);

  /// Flip card from top — like flipping a tile
  Widget get flipInY => animate()
      .flipH(begin: -0.3, duration: 600.ms, curve: Curves.easeOut)
      .fadeIn(duration: 400.ms);

  // ─────────────────────────────────────────────
  // 11. STAGGER HELPERS (index-based delay)
  // ─────────────────────────────────────────────

  /// Staggered fade-in slide-up — pass list index for cascading effect
  Widget staggerFadeUp(int index, {int baseDelayMs = 80}) => animate()
      .fadeIn(
        delay: (baseDelayMs * index).ms,
        duration: 500.ms,
        curve: Curves.easeOut,
      )
      .slideY(
        delay: (baseDelayMs * index).ms,
        begin: 0.25,
        end: 0,
        duration: 500.ms,
        curve: Curves.easeOut,
      );

  /// Staggered fade-in slide from left
  Widget staggerFadeLeft(int index, {int baseDelayMs = 80}) => animate()
      .fadeIn(
        delay: (baseDelayMs * index).ms,
        duration: 500.ms,
        curve: Curves.easeOut,
      )
      .slideX(
        delay: (baseDelayMs * index).ms,
        begin: -0.25,
        end: 0,
        duration: 500.ms,
        curve: Curves.easeOut,
      );

  /// Staggered scale pop-in
  Widget staggerPopIn(int index, {int baseDelayMs = 100}) => animate()
      .fadeIn(delay: (baseDelayMs * index).ms, duration: 400.ms)
      .scale(
        delay: (baseDelayMs * index).ms,
        begin: const Offset(0.7, 0.7),
        end: const Offset(1, 1),
        duration: 500.ms,
        curve: Curves.elasticOut,
      );

  // ─────────────────────────────────────────────
  // 12. DELAYED VERSIONS (all originals + new)
  // ─────────────────────────────────────────────

  Widget fadeInSlideUpDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .slideY(
        delay: delayMs.ms,
        begin: 0.3,
        end: 0,
        duration: 600.ms,
        curve: Curves.easeOut,
      );

  Widget fadeInSlideDownDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .slideY(
        delay: delayMs.ms,
        begin: -0.3,
        end: 0,
        duration: 600.ms,
        curve: Curves.easeOut,
      );

  Widget fadeInSlideLeftDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .slideX(
        delay: delayMs.ms,
        begin: -0.3,
        end: 0,
        duration: 600.ms,
        curve: Curves.easeOut,
      );

  Widget fadeInSlideRightDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .slideX(
        delay: delayMs.ms,
        begin: 0.3,
        end: 0,
        duration: 600.ms,
        curve: Curves.easeOut,
      );

  Widget fadeInScaleDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .scale(
        delay: delayMs.ms,
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 600.ms,
        curve: Curves.elasticOut,
      );

  Widget fadeInRotateDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .rotate(
        delay: delayMs.ms,
        begin: -0.2,
        end: 0,
        duration: 600.ms,
        curve: Curves.elasticOut,
      );

  Widget fadeInBounceDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 600.ms, curve: Curves.easeOut)
      .slideY(
        delay: delayMs.ms,
        begin: -0.5,
        end: 0,
        duration: 600.ms,
        curve: Curves.bounceOut,
      );

  Widget blurInDelayed(int delayMs) => animate()
      .blur(
        delay: delayMs.ms,
        begin: const Offset(12, 12),
        end: Offset.zero,
        duration: 700.ms,
      )
      .fadeIn(delay: delayMs.ms, duration: 700.ms);

  Widget popInDelayed(int delayMs) => animate()
      .fadeIn(delay: delayMs.ms, duration: 300.ms)
      .scale(
        delay: delayMs.ms,
        begin: Offset.zero,
        end: const Offset(1, 1),
        duration: 400.ms,
        curve: Curves.elasticOut,
      );

  // ─────────────────────────────────────────────
  // 13. COMPOSITE / CINEMATIC
  // ─────────────────────────────────────────────

  /// Hero entrance — blur clears, scale settles, fade completes
  Widget get heroEntrance => animate()
      .blur(
        begin: const Offset(16, 16),
        end: Offset.zero,
        duration: 800.ms,
        curve: Curves.easeOut,
      )
      .scale(
        begin: const Offset(0.9, 0.9),
        end: const Offset(1, 1),
        duration: 800.ms,
        curve: Curves.easeOut,
      )
      .fadeIn(duration: 600.ms);

  /// Depth pop — scale up slightly above 1 then settle, as if popping toward viewer
  Widget get depthPop => animate()
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.08, 1.08),
        duration: 200.ms,
        curve: Curves.easeOut,
      )
      .then()
      .scale(
        begin: const Offset(1.08, 1.08),
        end: const Offset(1, 1),
        duration: 300.ms,
        curve: Curves.elasticOut,
      );

  /// Rubber-band snap — like a pulled-back slingshot
  Widget get rubberBand => animate()
      .scaleX(begin: 1.25, end: 1, duration: 150.ms)
      .scaleY(begin: 0.75, end: 1, duration: 150.ms)
      .then(delay: 150.ms)
      .scaleX(begin: 0.85, end: 1, duration: 150.ms)
      .scaleY(begin: 1.15, end: 1, duration: 150.ms);

  /// Float up gently on a loop — like a badge or FAB idle state
  Widget get floatUp => animate(
    onPlay: (controller) => controller.repeat(reverse: true),
  ).slideY(begin: 0, end: -0.06, duration: 1500.ms, curve: Curves.easeInOut);

  /// Ripple scale pulse — like a live indicator or ping dot
  Widget get ripplePulse => animate(onPlay: (controller) => controller.repeat())
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.3, 1.3),
        duration: 900.ms,
        curve: Curves.easeOut,
      )
      .fadeOut(duration: 900.ms);

  /// Neon flicker — for dark-theme glowing badges / icons
  Widget get neonFlicker =>
      animate(onPlay: (controller) => controller.repeat(reverse: true))
          .fadeIn(duration: 80.ms)
          .then(delay: 60.ms)
          .fadeOut(duration: 80.ms)
          .then(delay: 500.ms)
          .fadeIn(duration: 80.ms)
          .then(delay: 30.ms)
          .fadeOut(duration: 80.ms)
          .then(delay: 1000.ms);

  /// Highlight ping — tint white flash then clear, like a "new" badge ping
  Widget get highlightPing => animate()
      .tint(color: Colors.white.withValues(alpha: 0.6), duration: 150.ms)
      .then()
      .tint(color: Colors.transparent, duration: 300.ms);

  /// Magnetic hover settle — slides in with slight overshoot
  Widget get magneticIn => animate()
      .slideX(begin: 0.4, end: -0.03, duration: 400.ms, curve: Curves.easeOut)
      .then()
      .slideX(begin: -0.03, end: 0, duration: 200.ms, curve: Curves.easeIn)
      .fadeIn(duration: 400.ms);
}
