import 'package:dio/dio.dart';
import 'package:far_away_flutter/util/dio_factory.dart';
import 'package:flutter/foundation.dart';

class DioUtil {

  static const String GET = "get";
  static const String POST = "post";

  static DioUtil _instance;

  static DioUtil get instance => _getInstance();

  static DioUtil _getInstance() {
    if (_instance == null) {
      _instance = DioUtil._internal();
    }
    return _instance;
  }

  DioUtil._internal();

  void get(
    String url,
    Function callBack, {
    Map<String, String> params,
    Function errorCallBack,
    CancelToken token,
  }) async {
    request(
      url,
      callBack,
      method: GET,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  void post(
    String url,
    Function callBack, {
    Map<String, String> params,
    Function errorCallBack,
    CancelToken token,
  }) async {
    request(
      url,
      callBack,
      method: POST,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  void postUpload(
    String url,
    Function callBack,
    // 调用上传的进度
    ProgressCallback progressCallBack, {
    FormData formData,
    Function errorCallBack,
    CancelToken token,
  }) async {
    request(
      url,
      callBack,
      method: POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  void request(
    String url,
    Function callBack, {
    String method,
    Map<String, String> params,
    FormData formData,
    Function errorCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    String errorMsg = "";
    int statusCode;
    try {
      Response response;
      switch (method) {
        case GET:
          {
            response = await DioFactory.getDioClient().get(
              url,
              queryParameters: params,
              cancelToken: token,
            );
          }
          break;
        case POST:
          {
            response = await DioFactory.getDioClient().post(
              url,
              data: params,
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          }
          break;
      }
      statusCode = response.statusCode;
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }
      if (callBack != null) {
        callBack(response.data);
      }
    } catch (e) {
      _handError(errorCallBack, e.toString());
    }
  }

  void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }
}
