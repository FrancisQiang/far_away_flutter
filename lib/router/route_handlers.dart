import 'package:far_away_flutter/page/home/dynamic_detail_page.dart';
import 'package:far_away_flutter/page/login/login_choose_page.dart';
import 'package:far_away_flutter/page/login/phone_login_page.dart';
import 'package:far_away_flutter/page/photo/asset_view_page.dart';
import 'package:far_away_flutter/page/photo/media_view_page.dart';
import 'package:far_away_flutter/page/recurit/comment_input_bottom_page.dart';
import 'package:far_away_flutter/page/search/search_page.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/param/recruit_param.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
import 'package:far_away_flutter/param/asset_view_page_param.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var phoneLoginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PhoneLoginPage();
});

var loginChooseHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginChoosePage();
});

var mainHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getMainPage();
});

var searchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SearchPage();
});

var dynamicDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  DynamicDetailParam arguments =
      context.settings.arguments as DynamicDetailParam;
  return ProviderUtil.getDynamicDetailPage(
      scrollToComment: arguments.scrollToComment,
      avatarHeroTag: arguments.avatarHeroTag,
      dynamicDetailBean: arguments.dynamicDetailBean);
});

var mediaViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  MediaViewPageParam arguments =
      context.settings.arguments as MediaViewPageParam;
  return MediaViewPage(
    mediaList: arguments.mediaList,
    currentIndex: arguments.currentIndex,
  );
});

var postDynamicHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getPostDynamicPage();
});

var postTogetherHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getPostTogetherPage();
});

var postRecruitHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getPostRecruitPage();
});

var locationChooseHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String longitude = params["longitude"][0];
  String latitude = params["latitude"][0];
  String type = params["type"][0];
  return ProviderUtil.getLocationChoosePage(
      longitude: longitude, latitude: latitude, type: type);
});

var assetViewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  AssetViewPageParam arguments =
      context.settings.arguments as AssetViewPageParam;
  return AssetViewPage(
    assetList: arguments.assetList,
    currentIndex: arguments.currentIndex,
  );
});

var togetherDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  TogetherDetailParam arguments =
      context.settings.arguments as TogetherDetailParam;
  return ProviderUtil.getTogetherDetailPage(
      scrollToComment: arguments.scrollToComment,
      avatarHeroTag: arguments.avatarHeroTag,
      togetherInfoBean: arguments.togetherInfoBean);
});

var recruitDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  RecruitDetailPageParam arguments =
      context.settings.arguments as RecruitDetailPageParam;
  return ProviderUtil.getRecruitDetailPage(
      recruitDetailInfoBean: arguments.recruitDetailInfoBean);
});


var privateChatHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  PrivateChatParam arguments = context.settings.arguments as PrivateChatParam;
  return ProviderUtil.getPrivateChatPage(
      username: arguments.username,
      userId: arguments.userId,
      avatar: arguments.avatar,
  );
});
