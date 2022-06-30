import 'dart:io';

import 'package:dio/dio.dart';

class AppDio {
  static getDio() {
    Dio dio;
    BaseOptions options = BaseOptions(
      baseUrl: "https://mytect.herokuapp.com",
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    dio = Dio(options);
    return dio;
  }
}