import 'dart:async';
import 'dart:convert';

import 'package:chatbot_app/services/dioclient.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiRepo {
  final client = Dioclient.getDio();
  CancelToken? _cancelToken;

  Future<String> sendMessage(String message) async {
    try {
      _cancelToken = CancelToken();
      final _apikey = dotenv.env['API_KEY'];
      final res = await client.post(
        '/models/gemini-flash-latest:generateContent',
        queryParameters: {"key": _apikey},
        cancelToken: _cancelToken,
        data: {
          "contents": [
            {
              "parts": [
                {"text": message},
              ],
            },
          ],
        },
      );

      print("API SUCESS : ${res.data}");
      return res.data["candidates"][0]["content"]["parts"][0]["text"];
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception("CANCELLED");
      }

      if (e.response != null) {
        final statusCode = e.response?.statusCode;

        if (statusCode == 400) {
          throw Exception("Bad request");
        } else if (statusCode == 401) {
          throw Exception("Invalid API key");
        } else if (statusCode == 429) {
          throw Exception("Too many requests, slow down");
        } else if (statusCode == 500) {
          throw Exception("Server error");
        } else {
          throw Exception("Error: $statusCode");
        }
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Response timeout");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("No internet connection");
      }

      throw Exception("Unexpected error occurred");
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  void stopSending() {
    _cancelToken?.cancel('Task stopped');
  }
}
