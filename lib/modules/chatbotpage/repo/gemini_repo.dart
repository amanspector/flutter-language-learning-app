import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:chatbot_app/core/services/dioclient.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiRepo {
  final geminiapiclient = Dioclient.getGeminiApiDio();
  CancelToken? _cancelToken;

  Future<String> sendMessage(String message) async {
    try {
      _cancelToken = CancelToken();
      final apikey = dotenv.env['API_KEY'];
      final res = await geminiapiclient.post(
        '/models/gemini-3.1-flash-lite:generateContent',
        queryParameters: {"key": apikey},
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

      log("API SUCESS : ${res.data}");
      return res.data["candidates"][0]["content"]["parts"][0]["text"];
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw ("CANCELLED");
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

  Future<List<WordModel>> generateVocabulary(String prompt) async {
    try {
      final res = await geminiapiclient.post(
        '/models/gemini-3.1-flash-lite:generateContent',
        queryParameters: {"key": dotenv.env['API_KEY']},
        cancelToken: _cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) PostmanRuntime/7.43.0',
          },
          receiveTimeout: const Duration(seconds: 90),
          sendTimeout: const Duration(seconds: 30),
        ),

        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.4,
            "topP": 0.9,
            "responseMimeType": "application/json",
          },
        },
      );

      final parts = res.data['candidates'][0]['content']['parts'];

      dynamic decoded;

      if (parts != null && parts.isNotEmpty) {
        final firstPart = parts[0];

        final content = firstPart['text'];

        if (content is String) {
          final cleaned = content
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          decoded = jsonDecode(cleaned);
        } else if (content is Map<String, dynamic>) {
          decoded = content;
        } else {
          throw Exception("Unexpected content format: ${content.runtimeType}");
        }
      } else {
        throw Exception("No parts in Gemini response");
      }

      log("decoded text : $decoded");
      // final List wordsJson = decoded['words'] as List;
      final List? wordsJson =
          (decoded['words'] ?? decoded['vocabulary'] ?? decoded['word_list'])
              as List?;

      if (wordsJson == null || wordsJson.isEmpty) {
        log(
          "decoded keys: ${decoded.keys.toList()}",
        ); // ✅ see what AI actually returned
        log("status: ${decoded['status']}"); // ✅ add this
        log("message: ${decoded['message']}");
        throw Exception(
          "No words found in response. Keys: ${decoded.keys.toList()}",
        );
      }

      return wordsJson.map((e) => WordModel.fromJson(e)).toList();

      // return wordsJson.map((e) => WordModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw Exception("CANCELLED");

      final status = e.response?.statusCode;
      if (status == 400) throw Exception("Bad request — check prompt");
      if (status == 401) throw Exception("Invalid API key");
      if (status == 429) throw Exception("Rate limit exceeded, try later");
      if (status == 500) throw Exception("Gemini server error");

      if (e.type == DioExceptionType.connectionTimeout)
        throw Exception("Connection timeout");
      if (e.type == DioExceptionType.receiveTimeout)
        throw Exception("Response timeout — prompt may be too large");
      if (e.type == DioExceptionType.connectionError)
        throw Exception("No internet connection");

      throw Exception("Network error: ${e.message}");
    } catch (e) {
      if (e.toString().contains("CANCELLED")) rethrow;
      log("generateVocabulary error: $e");
      throw Exception("Failed to parse vocabulary: $e");
    }
  }

  void stopSending() {
    _cancelToken?.cancel('Task stopped');
  }
}
