import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioFactory {

  static const int _connectTimeOut = 5 * 1000;
  static const int _receiveTimeOut = 8 * 1000;

  static Dio _client;

  static Dio getDioClient() {
    if (_client == null) {
      BaseOptions options = new BaseOptions();
      options.connectTimeout = _connectTimeOut;
      options.receiveTimeout = _receiveTimeOut;
      options.contentType = "application/json; charset=utf-8";
      _client = new Dio(options);
      _client.interceptors.add(LogInterceptor(
        responseBody: debugInstrumentationEnabled,
        requestHeader: debugInstrumentationEnabled,
        responseHeader: debugInstrumentationEnabled,
        request: debugInstrumentationEnabled,
      ));
    }
    return _client;
  }

  DioFactory._internal();

}