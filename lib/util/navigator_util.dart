import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/param/recruit_param.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
import 'package:far_away_flutter/param/asset_view_page_param.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/router/application.dart';
import 'package:far_away_flutter/router/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {

  static void toPhoneLoginPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.phoneLogin, transition: TransitionType.cupertino);
  }

  static void toLoginChoosePage(BuildContext context) {
    Application.router.navigateTo(context, Routes.loginChoose, transition: TransitionType.inFromBottom, replace: true);
  }

  static void toMainPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.main, transition: TransitionType.inFromBottom, replace: true);
  }

  static void toSearchPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.search, transition: TransitionType.materialFullScreenDialog);
  }

  static void toDynamicDetailPage(BuildContext context, {@required DynamicDetailParam param}) {
    Application.router.navigateTo(
        context,
        Routes.dynamicDetail,
        routeSettings: RouteSettings(
          arguments: param
        ),
        transition: TransitionType.inFromRight
    );
  }

  static void toMediaViewPage(BuildContext context, {@required MediaViewPageParam param}) {
    Application.router.navigateTo(
        context,
        Routes.mediaView,
        routeSettings: RouteSettings(
            arguments: param
        ),
        transition: TransitionType.fadeIn,
    );
  }

  static void toPostDynamicPage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.postDynamic,
      transition: TransitionType.fadeIn,
    );
  }

  static void toPostTogetherPage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.postTogether,
      transition: TransitionType.fadeIn,
    );
  }

  static void toPostRecruitPage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.postRecruit,
      transition: TransitionType.fadeIn,
    );
  }

  static void toLocationChoosePage(BuildContext context, {@required String longitude, @required String latitude, @required String type}) {
    Application.router.navigateTo(
      context,
      "/locationChoose/$longitude/$latitude/$type",
      transition: TransitionType.fadeIn,
    );
  }

  static void toAssetViewPage(BuildContext context, {@required AssetViewPageParam param}) {
    Application.router.navigateTo(
      context,
      Routes.assetView,
      routeSettings: RouteSettings(
          arguments: param
      ),
      transition: TransitionType.fadeIn,
    );
  }

  static void toTogetherDetailPage(BuildContext context, {@required TogetherDetailParam param}) {
    Application.router.navigateTo(
        context,
        Routes.togetherDetail,
        routeSettings: RouteSettings(
            arguments: param
        ),
        transition: TransitionType.inFromRight
    );
  }

  static void toPrivateChatPage(BuildContext context, {@required PrivateChatParam param}) {
    Application.router.navigateTo(
        context,
        Routes.privateChat,
        routeSettings: RouteSettings(
            arguments: param
        ),
        transition: TransitionType.inFromRight
    );
  }

  static void toRecruitDetailPage(BuildContext context, {@required RecruitDetailPageParam param}) {
    Application.router.navigateTo(
        context,
        Routes.recruitDetail,
        routeSettings: RouteSettings(
            arguments: param
        ),
        transition: TransitionType.inFromRight
    );
  }

  static void toRecruitCommentBottomPage(BuildContext context) {
    Application.router.navigateTo(
        context,
        Routes.recruitComment,
        transition: TransitionType.materialFullScreenDialog
    );
  }

  static void toUserInfoPage(BuildContext context, {@required String userId}) {
    Application.router.navigateTo(
        context,
        '/userInfo/$userId',
        transition: TransitionType.inFromRight
    );
  }

  static void toMyThumbsPage(BuildContext context) {
    Application.router.navigateTo(
        context,
        Routes.myThumbs,
        transition: TransitionType.inFromRight
    );
  }

  static void toProfileEditPage(BuildContext context) {
    Application.router.navigateTo(
        context,
        Routes.profileEdit,
        transition: TransitionType.inFromRight
    );
  }

  static void toUsernameEditPage(BuildContext context, {@required String username}) {
    Application.router.navigateTo(
        context,
        "/usernameEdit/$username",
        transition: TransitionType.inFromRight
    );
  }

  static void toSignatureEditPage(BuildContext context, {@required String signature}) {
    Application.router.navigateTo(
        context,
        "/signatureEdit/$signature",
        transition: TransitionType.inFromRight
    );
  }

  static void toGenderEditPage(BuildContext context, {@required int gender}) {
    Application.router.navigateTo(
        context,
        "/genderEdit/$gender",
        transition: TransitionType.inFromRight
    );
  }

  static void toEmotionEditPage(BuildContext context, {@required int emotionStatus}) {
    Application.router.navigateTo(
        context,
        "/emotionEdit/$emotionStatus",
        transition: TransitionType.inFromRight
    );
  }



}
