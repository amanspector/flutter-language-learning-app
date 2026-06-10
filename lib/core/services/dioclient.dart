import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _geminibaseurl = dotenv.env['GEMINI_BASE_URL'];
final _sarvambaseurl = dotenv.env['SARVAM_BASE_URL'];
final _puterbaseurl = dotenv.env['PUTER_BASE_URL'];
final _smallestbaseurl = dotenv.env['SMALLEST_BASE_URL'];

class Dioclient {
  static Dio getGeminiApiDio() {
    Dio dioservice = Dio();
    dioservice.options.baseUrl = _geminibaseurl!;
    dioservice.options.headers = {"Content-Type": "application/json"};
    return dioservice;
  }

  static Dio getSarvamApiDio() {
    Dio dioservice = Dio();
    dioservice.options.baseUrl = _sarvambaseurl!;
    dioservice.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${dotenv.env['SARVAM_API']}",
    };
    // Add this to your Dio client setup to see the exact request
    dioservice.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
    return dioservice;
  }

  static Dio getSmallestApiDio() {
    Dio dioservice = Dio();
    dioservice.options.baseUrl = _smallestbaseurl!;
    dioservice.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${dotenv.env['SMALLEST_API']}",
    };
    dioservice.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: false),
    );
    return dioservice;
  }

  static Dio getChatgptDio() {
    Dio dioservice = Dio();
    dioservice.options.baseUrl = _puterbaseurl!;
    dioservice.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${dotenv.env['PUTER_AUTH']}",
    };

    return dioservice;
  }
}
