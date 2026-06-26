import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:chatbot_app/core/services/dioclient.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiRepo {
  final geminiapiclient = Dioclient.getGeminiApiDio();
  CancelToken? _chatCancelToken;
  CancelToken? _vocabCancelToken;

  Future<String> sendMessage(String message, {int? age}) async {
    try {
      _chatCancelToken = CancelToken();
      final apikey = dotenv.env['API_KEY'];
      final ageInstruction = age != null
          ? " The user is $age years old. Please adapt your explanation style, vocabulary difficulty, tone, and examples to be appropriate and engaging for a ${age < 13 ? 'child under 13' : age < 20 ? 'teenager (13-19)' : 'adult (20+)'}."
          : "";

      final res = await geminiapiclient.post(
        '/models/gemini-3.1-flash-lite:generateContent',
        queryParameters: {"key": apikey},
        cancelToken: _chatCancelToken,
        data: {
          "contents": [
            {
              "parts": [
                {"text": message},
              ],
            },
          ],
          "systemInstruction": {
            "parts": [
              {
                "text":
                    "You are a helpful language learning tutor chatbot. Your sole purpose is to solve user doubts, translations, vocabulary, grammar rules, and language learning queries. If the user asks you about anything else unrelated to language learning, you must politely decline and direct them to ask you questions about language learning instead.$ageInstruction",
              },
            ],
          },
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
      _vocabCancelToken = CancelToken();
      final res = await geminiapiclient.post(
        '/models/gemini-3.1-flash-lite:generateContent',
        queryParameters: {"key": dotenv.env['API_KEY']},
        cancelToken: _vocabCancelToken,
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
              .replaceAll(RegExp(r'```(?:json)?'), '')
              .trim();

          decoded = _parseJsonFromText(cleaned);
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

  dynamic _parseJsonFromText(String text) {
    try {
      return jsonDecode(text);
    } catch (firstError) {
      log("Initial JSON decode failed: $firstError");
      log("Raw Gemini output: $text");
      final startIndex = text.indexOf('{');
      if (startIndex == -1) {
        throw Exception("No JSON object start found in Gemini output.");
      }

      int depth = 0;
      for (var i = startIndex; i < text.length; i++) {
        final char = text[i];
        if (char == '{') {
          depth++;
        } else if (char == '}') {
          depth--;
          if (depth == 0) {
            final candidate = text.substring(startIndex, i + 1).trim();
            try {
              return jsonDecode(candidate);
            } catch (secondError) {
              log("JSON extraction failed for candidate: $secondError");
            }
          }
        }
      }

      throw Exception(
        "Unable to extract JSON from Gemini output. Raw output begins: ${text.length > 300 ? text.substring(0, 300) + '...' : text}",
      );
    }
  }

  void stopSending() {
    _chatCancelToken?.cancel('Task stopped');
    _vocabCancelToken?.cancel('Task stopped');
  }
}
