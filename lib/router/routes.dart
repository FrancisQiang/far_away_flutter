import 'package:far_away_flutter/router/route_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String phoneLogin = "/phone_login";
  static String loginChoose = "/login_choose";
  static String main = "/main";
  static String search = "/search";
  static String dynamicDetail = "/dynamicDetail";
  static String mediaView = "/mediaView";
  static String postDynamic = "/postDynamic";
  static String postTogether = "/postTogether";
  static String postRecruit = "/postRecruit";
  static String locationChoose = "/locationChoose/:longitude/:latitude/:type";
  static String assetView = "/assetView";
  static String togetherDetail = "/togetherDetail";
  static String recruitDetail = "/recruitDetail";
  static String recruitComment = "/recruitComment";
  static String privateChat = "/privateChat";
  static String userInfo = "/userInfo/:userId";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          // 这里设置出错页面
          print("ROUTE WAS NOT FOUND !!!");
          return null;
        });
    router.define(phoneLogin, handler: phoneLoginHandler);
    router.define(loginChoose, handler: loginChooseHandler);
    router.define(main, handler: mainHandler);
    router.define(search, handler: searchHandler);
    router.define(dynamicDetail, handler: dynamicDetailHandler);
    router.define(mediaView, handler: mediaViewHandler);
    router.define(postDynamic, handler: postDynamicHandler);
    router.define(postTogether, handler: postTogetherHandler);
    router.define(postRecruit, handler: postRecruitHandler);
    router.define(locationChoose, handler: locationChooseHandler);
    router.define(assetView, handler: assetViewHandler);
    router.define(togetherDetail, handler: togetherDetailHandler);
    router.define(recruitDetail, handler: recruitDetailHandler);
    router.define(privateChat, handler: privateChatHandler);
    router.define(userInfo, handler: userInfoHandler);
  }
}