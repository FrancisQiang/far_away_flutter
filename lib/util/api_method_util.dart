import 'dart:io';

import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_post_bean.dart';
import 'package:far_away_flutter/bean/together_post_bean.dart';
import 'package:far_away_flutter/param/children_comment_query_param.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/util/dio_factory.dart';
import 'package:flutter/cupertino.dart';

import 'dio_util.dart';

class ApiMethodUtil {
  static const int SUCCEED = 0;
  static const int FAILED = 1;

  static ApiMethodUtil get instance => _getInstance();
  static ApiMethodUtil _instance;

  ApiMethodUtil._internal();

  static ApiMethodUtil _getInstance() {
    if (_instance == null) {
      _instance = ApiMethodUtil._internal();
    }
    return _instance;
  }

  /// QQ登录注册
  void qqRegisterOrLogin({
    Function success,
    Function failed,
    Function error,
    Map<String, String> params,
    CancelToken token,
  }) {
    DioUtil.instance.post(
      ApiProperties.HOST_BASE_URL + "/user/qq/register_login",
      success,
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
    );
  }

  /// 获取手机验证码
  void getMobileCode({
    Function success,
    Function failed,
    Function error,
    String mobile,
    CancelToken token,
  }) {
    DioUtil.instance.post(
      ApiProperties.HOST_BASE_URL + "/msg/verify_code/$mobile",
      success,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
    );
  }

  /// 手机验证码注册登录
  void mobileRegisterOrLogin({
    Function success,
    Function failed,
    Function error,
    Map<String, String> params,
    CancelToken token,
  }) {
    DioUtil.instance.post(
      ApiProperties.HOST_BASE_URL + "/user/mobile/register_login",
      success,
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
    );
  }

  /// 获取动态圈数据
  static Future<dynamic> getDynamicList(
      {@required int timestamp,
      @required int currentPage,
      @required String token}) {
    return DioFactory.getDioClient().get(
      ApiProperties.HOST_BASE_URL + "/dynamic/list/$timestamp/$currentPage",
      options: Options(headers: {"Authorization": token}),
    );
  }

  /// 获取动态详情
  static Future<dynamic> getDynamicDetail(
      {@required String id, @required String token}) {
    return DioFactory.getDioClient().get(
      ApiProperties.HOST_BASE_URL + "/dynamic/detail/$id",
      options: Options(headers: {"Authorization": token}),
    );
  }

  /// 获取指定评论列表
  static Future<dynamic> getCommentList(
      {@required CommentQueryParam commentQueryParam}) {
    return DioFactory.getDioClient()
        .post(ApiProperties.HOST_BASE_URL + "/comment/get", data: {
      "businessType": commentQueryParam.businessType,
      "businessId": commentQueryParam.businessId,
      "currentPage": commentQueryParam.currentPage
    });
  }

  /// 获取指定子评论列表
  static Future<dynamic> getChildrenCommentList(
      {@required ChildrenCommentQueryParam childrenCommentQueryParam}) {
    return DioFactory.getDioClient()
        .post(ApiProperties.HOST_BASE_URL + "/comment/getChildren", data: {
      "parentId": childrenCommentQueryParam.parentId,
      "currentPage": childrenCommentQueryParam.currentPage
    });
  }

  static Future<dynamic> getUserInfo({@required String token}) {
    return DioFactory.getDioClient().get(
        ApiProperties.HOST_BASE_URL + "/user/info",
        options: Options(headers: {"Authorization": token}));
  }

  static Future<dynamic> uploadPicture(
      {@required String token, @required File file, @required filename}) {
    return DioFactory.getDioClient().post(
      'http://upload-z2.qiniup.com',
      options: Options(contentType: "multipart/form-data"),
      data: FormData.fromMap({
        "file": MultipartFile.fromFileSync(file.path, filename: filename),
        "token": token
      }),
    );
  }

  static Future<dynamic> getUploadToken({@required String userToken}) {
    return DioFactory.getDioClient().get(
        ApiProperties.HOST_BASE_URL + "/oss/token",
        options: Options(headers: {"Authorization": userToken}));
  }

  static Future<dynamic> postDynamic(
      {@required String token, @required DynamicPostBean dynamicPostBean}) {
    return DioFactory.getDioClient().post(
        ApiProperties.HOST_BASE_URL + "/dynamic",
        options: Options(headers: {"Authorization": token}),
        data: dynamicPostBean.toJson());
  }

  static Future<dynamic> getAround(
      {@required String token, @required String location}) {
    return DioFactory.getDioClient().get(
      ApiProperties.HOST_BASE_URL + "/poi/around/$location",
      options: Options(headers: {"Authorization": token}),
    );
  }

  static Future<dynamic> dynamicThumbChange(
      {@required String token,
      @required bool thumb,
      @required String dynamicId}) {
    return DioFactory.getDioClient().post(
      ApiProperties.HOST_BASE_URL + "/dynamic/thumb",
      data: {"dynamicId": dynamicId, "thumb": thumb},
      options: Options(headers: {"Authorization": token}),
    );
  }

  static Future<dynamic> postComment(
      {@required String token,
      @required String bizId,
      @required String toUserId,
      @required String content,
      String pid,
      String bizType,
      String pictureList}) {
    return DioFactory.getDioClient().post(
      ApiProperties.HOST_BASE_URL + "/comment/post",
      data: {
        "parentId": pid,
        "businessType": bizType,
        "businessId": bizId,
        "toUserId": toUserId,
        "content": content,
        "pictureUrlList": pictureList
      },
      options: Options(headers: {"Authorization": token}),
    );
  }

  static Future<dynamic> getTogetherInfoList({@required int timestamp, @required int currentPage, @required String token}) {
    return DioFactory.getDioClient().get(
      ApiProperties.HOST_BASE_URL + "/together/list/$timestamp/$currentPage",
      options: Options(headers: {"Authorization": token}),
    );
  }

  static Future<dynamic> postTogether(
      {@required String token, @required TogetherPostBean togetherPostBean}) {
    return DioFactory.getDioClient().post(
        ApiProperties.HOST_BASE_URL + "/together",
        options: Options(headers: {"Authorization": token}),
        data: togetherPostBean.toJson());
  }

  static Future<dynamic> getTogetherDetail(
      {@required String id, @required String token}) {
    return DioFactory.getDioClient().get(
      ApiProperties.HOST_BASE_URL + "/together/detail/$id",
      options: Options(headers: {"Authorization": token}),
    );
  }

  static Future<dynamic> togetherSignUp(
      {@required String token,
        @required String id}) {
    return DioFactory.getDioClient().post(
      ApiProperties.HOST_BASE_URL + "/together/signup/$id",
      options: Options(headers: {"Authorization": token}),
    );
  }

}
