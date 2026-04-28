import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _apikey = dotenv.env['API_KEY'];
final _baseurl = dotenv.env['BASE_URL'];

class Dioclient {
  static Dio getDio() {
    Dio dioservice = Dio();
    dioservice.options.baseUrl = _baseurl!;
    dioservice.options.headers = {"Content-Type": "application/json"};

    return dioservice;
  }
}
