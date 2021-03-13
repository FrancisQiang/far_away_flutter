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

  static void toLocationChoosePage(BuildContext context, {@required String longitude, @required String latitude}) {
    Application.router.navigateTo(
      context,
      "/locationChoose/$longitude/$latitude",
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

}
