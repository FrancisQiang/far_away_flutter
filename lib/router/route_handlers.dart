import 'package:far_away_flutter/page/login/login_choose_page.dart';
import 'package:far_away_flutter/page/login/phone_login_page.dart';
import 'package:far_away_flutter/page/photo/asset_view_page.dart';
import 'package:far_away_flutter/page/photo/media_view_page.dart';
import 'package:far_away_flutter/page/search/search_page.dart';
import 'package:far_away_flutter/param/asset_view_page_param.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/param/image_crop_param.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/param/recruit_param.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
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

var userInfoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String userId = params["userId"][0];
  return ProviderUtil.getUserInfoPage(
    userId: userId,
  );
});

var myThumbsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getMyThumbsPage();
});

var profileEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getProfileEditPage();
});

var usernameEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getUsernameEditPage(username: params['username'][0]);
});

var signatureEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getSignatureEditPage(signature: params["signature"][0]);
});

var genderEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getGenderEditPage(gender: int.parse(params["gender"][0]));
});

var emotionEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getEmotionEditPage(
      emotionStatus: int.parse(params["emotionStatus"][0]));
});

var birthdayEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getBirthdayEditPage(
      birthday: int.parse(params["birthday"][0]));
});

var imageCropHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  ImageCropParam arguments = context.settings.arguments as ImageCropParam;
  return ProviderUtil.getImageCropPage(
      url: arguments.url,
      confirmCallback: arguments.confirmCallback,
      aspectRatio: arguments.aspectRatio);
});

var schoolSearchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getSchoolSearchPage();
});

var majorEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ProviderUtil.getMajorEditPage(major: params['major'][0]);
});

var industryEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ProviderUtil.getIndustryEditPage(industry: params['industry'][0]);
    });

