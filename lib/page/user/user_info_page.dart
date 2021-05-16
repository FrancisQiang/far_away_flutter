import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/page/user/user_info_widget.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class UserInfoPage extends StatefulWidget {

  final String userId;

  UserInfoPage({@required this.userId});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  bool loaded = false;

  UserInfoBean userInfoBean;

  /// appbar透明度
  double appbarOpacity = 0;

  /// 小球所需文本列表
  List<String> _textList = [];

  /// 滚动量
  double _scrollPixels = 0;

  /// 小球位置列表
  final List<Offset> _bubbleOffsetList = [];

  /// 圆心坐标 半径
  final double x0 = ScreenUtil().setWidth(340);
  final double y0 = ScreenUtil().setHeight(400);
  final double radius = ScreenUtil().setWidth(320);


  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  /// 计算小球偏移绝对位置
  _calculateOffset(double realRadius) {
    _bubbleOffsetList.clear();
    if (_textList.isNotEmpty) {
      for (int i = 0; i < _textList.length; i++) {
        Offset offset = Offset(
            x0 +
                realRadius *
                    math.cos(
                        (180 - ((i + 1) * (180 / (_textList.length + 1)))) *
                            math.pi /
                            180),
            y0 -
                realRadius *
                    math.sin(
                        (180 - ((i + 1) * (180 / (_textList.length + 1)))) *
                            math.pi /
                            180));
        _bubbleOffsetList.add(offset);
      }
    }
  }

  /// 计算小球直径
  double _calculateBubbleDiameter() {
    return ScreenUtil().setWidth(
        110 - (_scrollPixels * 0.8) < 0 ? 0 : 110 - (_scrollPixels * 0.8));
  }

  /// 计算小球文本内容大小
  double _calculateBubbleFontSize() {
    return ScreenUtil()
        .setSp(20 - (_scrollPixels * 0.2) < 0 ? 0 : 20 - (_scrollPixels * 0.2));
  }

  /// 计算小球旋转角度
  double _calculateBubbleRadians() {
    return (_scrollPixels / 100 * math.pi);
  }

  _getUserInfo() async {
    // 更新用户信息
    Response<dynamic> userInfoResponse = await ApiMethodUtil.getUserInfoById(token: ProviderUtil.globalInfoProvider.jwt, userId: widget.userId);
    ResponseBean response = ResponseBean.fromJson(userInfoResponse.data);
    userInfoBean = UserInfoBean.fromJson(response.data);
    // 重新生成小球
    _generateBubbleList(userInfoBean);
    setState(() {
      loaded = true;
    });
  }

  /// 生成小球列表
  _generateBubbleList(UserInfoBean userInfoBean) {
    _textList.clear();
    if (userInfoBean.birthday != null) {
      DateTime birthday =
          DateTime.fromMillisecondsSinceEpoch(userInfoBean.birthday);
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
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: InitRefreshWidget(
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return Consumer<GlobalInfoProvider>(
      builder: (context, globalInfoProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return true;
                },
                child: EasyRefresh(
                    header: EasyRefreshWidget.refreshHeader,
                    onRefresh: () async {
                      _getUserInfo();
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
                            userInfoBean: userInfoBean,
                          ),
                          Container(
                            height: 600,
                          ),
                        ],
                      ),
                    ),
                ),
              ),
              Opacity(
                opacity: appbarOpacity,
                child: Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black)]),
                  alignment: Alignment.center,
                  height: 70,
                  child: Text(
                    globalInfoProvider.userInfoBean == null
                        ? ''
                        : globalInfoProvider.userInfoBean.userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(
                    top: MediaQueryData.fromWindow(window).padding.top
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8
                        ),
                        child: Icon(FontAwesomeIcons.angleLeft, color: appbarOpacity < 0.5 ? Colors.white70 : Colors.black,),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8
                        ),
                        child: Icon(FontAwesomeIcons.ellipsisH, color: appbarOpacity < 0.5 ? Colors.white70 : Colors.black,),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
