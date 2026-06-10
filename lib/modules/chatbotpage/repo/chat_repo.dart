import 'dart:async';
import 'dart:developer';
import 'package:chatbot_app/core/services/dioclient.dart';
import 'package:dio/dio.dart';

class ChatRepo {
  final client = Dioclient.getChatgptDio();
  CancelToken? _cancelToken;
  Future<String> sendMessage(String message) async {
    try {
      final res = await client.post(
        '/openai/v1/chat/completions',
        cancelToken: _cancelToken,
        data: {
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "user", "content": message},
          ],
        },
      );

      log("API SUCESS : ${res.data}");

      return res.data['choices'][0]['message']['content'];
    } catch (e) {
      log("Error : $e");
    }
    return "Failed to get response";
  }

  void stopSending() {
    _cancelToken?.cancel('Task stopped');
  }
}
