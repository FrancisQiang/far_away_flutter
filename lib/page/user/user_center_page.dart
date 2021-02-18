import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/circle_moving_bubble.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/page/user/user_base_service_widget.dart';
import 'package:far_away_flutter/page/user/user_info_widget.dart';
import 'package:far_away_flutter/page/user/user_more_service_widget.dart';
import 'package:far_away_flutter/properties/shared_preferences_keys.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/sp_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class UserCenterPage extends StatefulWidget {
  @override
  _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  /// appbar透明度
  double appbarOpacity = 0;

  /// 小球所需文本列表
  List<String> _textList = [];

  /// 滚动量
  double _scrollPixels = 0;

  /// 小球位置列表
  final List<Offset> _bubbleOffsetList = [];

  /// 圆心坐标 半径
  final double x0 = ScreenUtil().setWidth(320);
  final double y0 = ScreenUtil().setHeight(400);
  final double radius = ScreenUtil().setWidth(320);

  /// 计算小球偏移绝对位置
  _calculateOffset(double realRadius) {
    _bubbleOffsetList.clear();
    if (_textList.isNotEmpty) {
      for (int i = 0; i < _textList.length; i++) {
        Offset offset = Offset(
            x0 + realRadius * math.cos((180 - ((i + 1) * (180 / (_textList.length + 1)))) * math.pi / 180),
            y0 - realRadius * math.sin((180 - ((i + 1) * (180 / (_textList.length + 1)))) * math.pi / 180)
        );
        _bubbleOffsetList.add(offset);
      }
    }
  }

  /// 计算小球直径
  double _calculateBubbleDiameter() {
    return ScreenUtil().setWidth(110 - (_scrollPixels * 0.8) < 0 ? 0 : 110 - (_scrollPixels * 0.8));
  }

  /// 计算小球文本内容大小
  double _calculateBubbleFontSize() {
    return ScreenUtil().setSp(20 - (_scrollPixels * 0.2) < 0 ? 0 : 20 - (_scrollPixels * 0.2));
  }

  /// 计算小球旋转角度
  double _calculateBubbleRadians () {
    return (_scrollPixels / 100 * math.pi);
  }

  /// 获取用户信息并更新
  _getUserInfo(GlobalInfoProvider globalInfoProvider) async {
    // 更新用户信息
    Response<dynamic> userInfoResponse = await ApiMethodUtil.getUserInfo(token: globalInfoProvider.jwt);
    ResponseBean response = ResponseBean.fromJson(userInfoResponse.data);
    globalInfoProvider.userInfoBean = UserInfoBean.fromJson(response.data);
    UserInfoBean userInfoBean = globalInfoProvider.userInfoBean;
    globalInfoProvider.refresh();
    // 重新生成小球
    _generateBubbleList(userInfoBean);
  }

  /// 生成小球列表
  _generateBubbleList(UserInfoBean userInfoBean) {
    _textList.clear();
    if (userInfoBean.birthday != null) {
      DateTime birthday = DateTime.fromMillisecondsSinceEpoch(
          userInfoBean.birthday);
      _textList.add(DateUtil.getBirthdayLabel(birthday));
      if (!StringUtil.isEmpty(userInfoBean.constellation)) {
        _textList.add(userInfoBean.constellation);
      }
    }
    if (!StringUtil.isEmpty(userInfoBean.school)) {
      _textList.add(userInfoBean.school);
    }
    if (!StringUtil.isEmpty(userInfoBean.industry)) {
      _textList.add(userInfoBean.industry);
    }
    _calculateOffset(radius);
    setState(() {});
  }

  /// 滚动监听
  _onScroll(offset) {
    double alpha = offset / ScreenUtil().setHeight(300);
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _scrollPixels = offset;
      appbarOpacity = alpha;
      if (_scrollPixels <= 100) {
        _calculateOffset(radius - (radius * _scrollPixels / 100));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _generateBubbleList(ProviderUtil.globalInfoProvider.userInfoBean);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalInfoProvider>(
      builder: (context, globalInfoProvider, child) {
        return Stack(
          children: [
            NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return true;
                },
                child: EasyRefresh(
                    header: EasyRefreshWidget.refreshHeader,
                    onRefresh: () async {
                      _getUserInfo(globalInfoProvider);
                    },
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          UserInfoWidget(
                            scrollPixels: _scrollPixels,
                            textList: _textList,
                            bubbleOffsetList: _bubbleOffsetList,
                            bubbleRadians: _calculateBubbleRadians(),
                            bubbleDiameter: _calculateBubbleDiameter(),
                            bubbleTextFontSize: _calculateBubbleFontSize(),
                            globalInfoProvider: globalInfoProvider,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserBaseServiceWidget(),
                                UserMoreServiceWidget()
                              ],
                            ),
                          )
                        ],
                      ),
                    ))),
            Opacity(
              opacity: appbarOpacity,
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black)]),
                alignment: Alignment.center,
                height: 70.0,
                child: Text(
                  globalInfoProvider.userInfoBean == null ? '' : globalInfoProvider.userInfoBean.userName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4),
                ),
              ),
            )
          ],
        );
      },
    );
  }

}
