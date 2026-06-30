import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:chatbot_app/core/services/dioclient.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer player = AudioPlayer();
  final sarvamapidio = Dioclient.getSarvamApiDio();
  CancelToken? _cancelToken;

  static const Map<String, String> languageMap = {
    "Hindi": "hi-IN",
    "Spanish": "es-ES",
    "Arabic": "ar-AE",
    "English": "en-IN",
    "Tamil": "ta-IN",
    "Telugu": "te-IN",
    "Marathi": "mr-IN",
    "Gujarati": "gu-IN",
    "Bengali": "bn-IN",
    "Kannada": "kn-IN",
    "French": "fr-FR",
  };

  static String getCode(String languageName) {
    return languageMap[languageName] ?? "en-US";
  }

  bool isIndian(String code) {
    return code.endsWith("-IN");
  }

  Future<void> stopPlayer() async {
    try {
      await player.stop();
    } catch (e) {
      log("Player init error: $e");
    }
  }

  Future<void> speakWithFlutterTts(String text, String language) async {
    await player.stop();
    await _flutterTts.setLanguage(language);
    await _flutterTts.setSpeechRate(0.4);

    log("-------------------------speakwithflutter tts");

    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<Uint8List?> getAudioUrl(
    String text,
    String langauge,
    String speaker,
  ) async {
    final oldToken = _cancelToken;
    if (oldToken != null && !oldToken.isCancelled) {
      oldToken.cancel("User pressed next too fast!");
      log("Old request cancelled! ⛔");
    }
    final newtoken = CancelToken();
    _cancelToken = newtoken;

    try {
      log("REQUEST to Sarvam:");
      log("Text: $text");
      log("Language: $langauge");
      log("Speaker: $speaker");

      if (!isIndian(langauge)) {
        log("This is not indian language......");
        return null;
      }
      ;
      final response = await sarvamapidio.post(
        "/text-to-speech",
        cancelToken: newtoken,

        options: Options(
          headers: {"Connection": "keep-alive"},
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 45),
          sendTimeout: const Duration(seconds: 10),
        ),
        data: {
          "text": text,
          "target_language_code": langauge,
          "speaker": speaker,
          "model": "bulbul:v3",
        },
      );

      log("RESPONSE from Sarvam:");
      log("Status: ${response.statusCode}");
      log("Request ID: ${response.data['request_id']}");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        log(data.length.toString());
        final audios = data["audios"] as List?;
        if (audios != null && audios.isNotEmpty) {
          log("Audio is not empty :)");
          final String audiobase = audios.first as String;
          return base64Decode(audiobase);
        }
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log("Request was successfully cancelled.");
        throw Exception("CANCELLED_BY_USER");
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        log("tts timeout!");
      } else {
        log("tts error in ifelse : ${e.message}");
      }
      if (e.response?.statusCode == 402) {
        log("API Quota Exceeded (402). Disable Bulbul v2 or top up credits.");
      }
    } catch (e) {
      log("tts error : $e");
    } finally {
      if (_cancelToken == newtoken) {
        _cancelToken = null;
      }
    }
    return null;
  }

  Future<Uint8List?> getAudioFromSmallestBatch({
    required String text,
    required String voiceId,
  }) async {
    // 1. Manage fast-cancellation tokens gracefully on user card swaps
    final oldToken = _cancelToken;
    if (oldToken != null && !oldToken.isCancelled) {
      oldToken.cancel("User pressed next too fast!");
      log("Old Smallest.ai request cancelled! ⛔");
    }

    final newtoken = CancelToken();
    _cancelToken = newtoken;

    try {
      log(
        "REQUEST (Batch API) to Smallest.ai: text: \"$text\" | voice: $voiceId",
      );

      final centralDio = Dioclient.getSmallestApiDio();

      final response = await centralDio.post(
        '/waves/v1/lightning-v3.1/get_speech',
        cancelToken: newtoken,
        data: {
          'text':
              "En español se dice: ¡${text.trim()}!", // 🎯 Pass your database words completely untouched!
          'voice_id': voiceId.toLowerCase().trim(),
          'sample_rate':
              24000, // Keep 24000Hz (Highly optimized for Lightning processing frames)
          'language':
              'es', // 🎯 THE EXACT FIX: Tells Isabella to strictly execute Spanish phonetics over-the-air!
          'output_format': 'wav',
          'speed': 0.85, // Slower learning speed pace
        },
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'audio/wav'},
        ),
      );

      log(
        "RESPONSE from Smallest.ai Batch: Status Code ${response.statusCode}",
      );

      if (response.statusCode == 200 && response.data != null) {
        log(
          "🎉 File asset bundle downloaded successfully! Size: ${response.data.length} bytes",
        );
        return Uint8List.fromList(response.data);
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log("Smallest.ai request successfully aborted via token swap.");
      } else {
        log("Smallest.ai batch channel exception: ${e.message}");
      }
    } catch (e) {
      log("General batch processing exception caught: $e");
    } finally {
      if (_cancelToken == newtoken) {
        _cancelToken = null;
      }
    }
    return null;
  }

  Future<void> playAudio(Uint8List bytes) async {
    await player.stop();
    try {
      log("playaudio started");
      await player.setAudioSource(MyByteSource(bytes));
      // await player.setAudioSource(
      //   AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/wav')),
      // );
      log("setaudiosource func called");
      player.play();
      await Future.delayed(Duration(milliseconds: 50));
      await player.seek(Duration.zero);

      log("player played");

      await player.processingStateStream.firstWhere(
        (state) =>
            state == ProcessingState.completed || state == ProcessingState.idle,
      );
    } catch (e) {
      log("Play Audio Error: $e");
    }
  }

  Future<void> dispose() async {
    await _flutterTts.stop();
    await player.dispose();
  }

  Future<void> stopAllAudio() async {
    await _flutterTts.stop();
    await player.stop();
  }
}

// ignore: experimental_member_use
class MyByteSource extends StreamAudioSource {
  final Uint8List bytes;
  MyByteSource(this.bytes);

  @override
  // ignore: experimental_member_use
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    // ignore: experimental_member_use
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/wav',
      // contentType: 'audio/mpeg',
    );
  }
}
