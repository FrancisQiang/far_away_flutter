import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  static const int _connectTimeOut = 5 * 1000;
  static const int _receiveTimeOut = 8 * 1000;

  static Dio _client;

  static BaseOptions _options = new BaseOptions();

  static setAuthorization(String jwt) {
    _options.headers["Authorization"] = jwt;
  }

  static Dio getDioClient() {
    if (_client == null) {
      _options.connectTimeout = _connectTimeOut;
      _options.receiveTimeout = _receiveTimeOut;
      _options.contentType = "application/json; charset=utf-8";
      _client = new Dio(_options);
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
