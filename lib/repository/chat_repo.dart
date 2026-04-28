import 'dart:async';
import 'package:chatbot_app/services/dioclient.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatRepo {
  final client = Dioclient.getDio();

  Future<String> sendMessage(String message) async {
    try {
      final res = await client.post(
        '/chat/completions',
        data: {
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "user", "content": message},
          ],
        },
      );

      print("API SUCESS : ${res.data}");

      return res.data['choices'][0]['message']['content'];
    } catch (e) {
      print("Error : $e");
    }
    return "Failed to get response";
  }
}
