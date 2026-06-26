import 'package:just_audio/just_audio.dart';
import 'dart:developer' as dev;

class SoundEffectService {
  static bool isMuted = false;

  static final AudioPlayer _placePlayer = AudioPlayer();
  static final AudioPlayer _removePlayer = AudioPlayer();
  static final AudioPlayer _correctPlayer = AudioPlayer();
  static final AudioPlayer _wrongPlayer = AudioPlayer();

  static bool _placeLoaded = false;
  static bool _removeLoaded = false;
  static bool _correctLoaded = false;
  static bool _wrongLoaded = false;

  static Future<void> playPlace() async {
    if (isMuted) return;
    try {
      if (!_placeLoaded) {
        await _placePlayer.setAsset('assets/sounds/place.mp3');
        _placeLoaded = true;
      }
      await _placePlayer.seek(Duration.zero);
      _placePlayer.play();
    } catch (e) {
      dev.log("Error playing place sound: $e");
    }
  }

  static Future<void> playRemove() async {
    if (isMuted) return;
    try {
      if (!_removeLoaded) {
        await _removePlayer.setAsset('assets/sounds/remove.mp3');
        _removeLoaded = true;
      }
      await _removePlayer.seek(Duration.zero);
      _removePlayer.play();
    } catch (e) {
      dev.log("Error playing remove sound: $e");
    }
  }

  static Future<void> playCorrect() async {
    if (isMuted) return;
    try {
      if (!_correctLoaded) {
        await _correctPlayer.setAsset('assets/sounds/correct.mp3');
        _correctLoaded = true;
      }
      await _correctPlayer.seek(Duration.zero);
      _correctPlayer.play();
    } catch (e) {
      dev.log("Error playing correct sound: $e");
    }
  }

  static Future<void> playWrong() async {
    if (isMuted) return;
    try {
      if (!_wrongLoaded) {
        await _wrongPlayer.setAsset('assets/sounds/error2.mp3');
        _wrongLoaded = true;
      }
      await _wrongPlayer.seek(Duration.zero);
      _wrongPlayer.play();
    } catch (e) {
      dev.log("Error playing wrong sound: $e");
    }
  }
}
