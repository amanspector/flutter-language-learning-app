import 'package:vibration/vibration.dart';

class AppHapticService {
  static bool isVibrationEnabled = true;

  static Future<void> vibrate({
    int? duration,
    List<int>? pattern,
    List<int>? intensities,
    int? amplitude,
  }) async {
    if (!isVibrationEnabled) return;

    // Check if the device has a vibrator
    final hasVib = await Vibration.hasVibrator();
    if (!hasVib) return;

    final localPattern = pattern;
    final localIntensities = intensities;

    if (localPattern != null) {
      if (localIntensities != null) {
        await Vibration.vibrate(pattern: localPattern, intensities: localIntensities);
      } else {
        await Vibration.vibrate(pattern: localPattern);
      }
    } else if (amplitude != null) {
      await Vibration.vibrate(amplitude: amplitude);
    } else {
      await Vibration.vibrate(duration: duration ?? 50);
    }
  }
}
