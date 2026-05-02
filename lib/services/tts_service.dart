import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  final String apiKey = dotenv.env['SARVAM_API']!;

  bool isIndianLanguage(String code) {
    const indianLangs = {
      "hi-IN",
      "ta-IN",
      "te-IN",
      "mr-IN",
      "gu-IN",
      "bn-IN",
      "kn-IN",
    };
    return indianLangs.contains(code);
  }

  Future<void> speak({
    String? speaker,
    required String text,
    required String language,
  }) async {
    if (isIndianLanguage(language)) {
      print("_speakWithSarvam");
      await _speakWithSarvam(text: text, language: language, speaker: speaker);
    } else {
      print("_speakWithFlutterTts");
      await _speakWithFlutterTts(text, language);
    }
  }

  Future<void> _speakWithFlutterTts(String text, String language) async {
    await _player.stop();
    await _flutterTts.setLanguage(language);
    await _flutterTts.setSpeechRate(0.4);

    print("-------------------------speakwithflutter tts");

    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> _speakWithSarvam({
    required String text,
    required String language,
    String? speaker,
  }) async {
    print("-------------------------speakwithsarvam");

    try {
      await _flutterTts.stop();
      await _player.stop();

      final audioUrl = await _getAudioUrl(text, language, speaker!);
      if (audioUrl != null) {
        await _playAudio(audioUrl);
      } else {
        // await _flutterTts.setLanguage("hi-IN");
        print("-------------------------speakwithflutter${audioUrl}");

        await _flutterTts.setLanguage(language);
        await _flutterTts.speak(text);
      }
    } catch (e) {
      // await _flutterTts.setLanguage("hi-IN");
      await _flutterTts.setLanguage(language);
      await _flutterTts.speak(text);
    }
  }

  Future<String?> _getAudioUrl(
    String text,
    String langauge,
    String speaker,
  ) async {
    print("REQUEST to Sarvam:");
    print("Text: $text");
    print("Language: $langauge");
    print("Speaker: $speaker");

    final response = await http
        .post(
          Uri.parse("https://api.sarvam.ai/text-to-speech"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey",
          },
          body:
              // jsonEncode({
              //   "text": "hello",
              //   "target_language_code": "hi-IN",
              //   "speaker": "hitesh",
              // }),
              jsonEncode({
                "text": text,
                "target_language_code": langauge,
                "speaker": speaker,
                "model": "bulbul:v2",
              }),
        )
        .timeout(Duration(seconds: 5));

    print(
      "--------------------------------------------------getaudiourl${response.body}",
    );

    print("RESPONSE from Sarvam:");
    print("Status: ${response.statusCode}");
    print("Request ID: ${jsonDecode(response.body)['request_id']}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      // return data["audios"];

      final List<dynamic> audios = data["audios"];
      if (audios.isNotEmpty) {
        print("Audio length: ${audios[0].length} chars");
        return audios[0];
      }
    }

    return null;
  }

  // Future<void> _playAudio(String url) async {
  //   await _player.stop();
  //   await _player.setUrl(url);
  //   await _player.play();
  // }
  Future<void> _playAudio(String base64Audio) async {
    await _player.stop();
    try {
      print("🎵 Playing audio directly from memory...");

      // Decode base64 to bytes
      final bytes = base64Decode(base64Audio);
      print("Decoded ${bytes.length} bytes");

      // Play directly from bytes
      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/wav')),
      );
      await _player.play();

      print("Playing audio!");
    } catch (e) {
      print("Playback error: $e");
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _flutterTts.stop();
    await _player.dispose();
  }
}
