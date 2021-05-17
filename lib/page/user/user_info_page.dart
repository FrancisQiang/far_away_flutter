import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/circle_moving_bubble.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/page/user/user_info_widget.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class UserInfoPage extends StatefulWidget {
  final String userId;

  UserInfoPage({this.userId});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  LinkHeaderNotifier _headerNotifier;

  double overScroll = 0;

  double maxExtentHeight = ScreenUtil().setHeight(650);

  TabController _tabController;

  UserInfoBean userInfoBean;

  bool loaded = false;

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
    setState(() {});
  }

  _getUserInfo() async {
    Response response = await ApiMethodUtil.getUserInfoById(
        token: ProviderUtil.globalInfoProvider.jwt, userId: widget.userId);
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    userInfoBean = UserInfoBean.fromJson(responseBean.data);
    setState(() {
      _generateBubbleList(userInfoBean);
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _tabController = TabController(length: 3, vsync: this);
    _headerNotifier = LinkHeaderNotifier();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  /// 小球所需文本列表
  List<String> _textList = [];

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
    return ScreenUtil()
        .setWidth(110 - (overScroll * 0.8) < 0 ? 0 : 110 - (overScroll * 0.8));
  }

  /// 计算小球文本内容大小
  double _calculateBubbleFontSize() {
    return ScreenUtil()
        .setSp(20 - (overScroll * 0.2) < 0 ? 0 : 20 - (overScroll * 0.2));
  }

  /// 计算小球旋转角度
  double _calculateBubbleRadians() {
    return (overScroll / 100 * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Container();
    }
    return Scaffold(
        body: Stack(
      children: [
        NotificationListener<ScrollUpdateNotification>(
          child: EasyRefresh.custom(
            header: LinkHeader(
              _headerNotifier,
              extent: 70.0,
              triggerDistance: 70.0,
              completeDuration: Duration(milliseconds: 500),
            ),
            firstRefreshWidget: InitRefreshWidget(
              color: Theme.of(context).primaryColor,
            ),
            firstRefresh: true,
            onRefresh: () async {
              await _getUserInfo();
            },
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: SliverCustomHeaderDelegate(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  action: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  title: AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    transitionBuilder: (child, animation) {
                      return RelativePositionedTransition(
                        size: Size(0.0, 0.0),
                        rect: RectTween(
                                begin: Rect.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                end: Rect.fromLTRB(0.0, 0.0, 0.0, 0.0))
                            .animate(animation),
                        child: child,
                      );
                    },
                    child: overScroll >= maxExtentHeight - 100
                        ? Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    child: ClipOval(
                                  child: Image.network(
                                    userInfoBean.avatar,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                )),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            userInfoBean.userName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            userInfoBean.signature,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(120),
                                  height: 26,
                                  child: FlatButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Colors.yellow,
                                    child: Text(
                                      '关注',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                  ),
                  expandedBackgroundWidget: Opacity(
                    opacity: overScroll >= maxExtentHeight - 100 ? 0.0 : 1,
                    child: Container(
                      height: ScreenUtil().setHeight(350),
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                      width: ScreenUtil().setWidth(750),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setWidth(180),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(110))),
                              border: Border.all(
                                width: 1.5,
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userInfoBean == null
                                    ? ''
                                    : userInfoBean.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ProviderUtil.globalInfoProvider.userInfoBean.id ==
                                  userInfoBean.id
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(15)),
                                  width: ScreenUtil().setWidth(150),
                                  height: ScreenUtil().setHeight(40),
                                  child: FlatButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.yellow.withOpacity(0.6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.black87,
                                          size: ScreenUtil().setSp(20),
                                        ),
                                        Text(
                                          ' 编辑资料',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setWidth(20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(15)),
                                  width: ScreenUtil().setWidth(150),
                                  height: ScreenUtil().setHeight(40),
                                  child: FlatButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.yellow.withOpacity(0.6),
                                    child: Text(
                                      '关 注',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(25),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 用户名
                                Container(
                                  child: Text(
                                    userInfoBean == null
                                        ? ''
                                        : userInfoBean.userName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(32),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // 性别
                                userInfoBean != null && userInfoBean.gender != 0
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(8)),
                                        child: Image.asset(
                                          'assets/png/${userInfoBean.gender == 1 ? 'male' : 'female'}.png',
                                          height: ScreenUtil().setWidth(32),
                                          width: ScreenUtil().setWidth(32),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          // 签名
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                            width: ScreenUtil().setWidth(500),
                            alignment: Alignment.center,
                            child: Text(
                              userInfoBean == null
                                  ? ''
                                  : userInfoBean.signature,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(22),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                UserActiveInfoWidget(
                                  title: "获赞",
                                  value: userInfoBean == null
                                      ? ''
                                      : userInfoBean.thumbCount.toString(),
                                ),
                                UserActiveInfoWidget(
                                  title: "关注",
                                  value: userInfoBean == null
                                      ? ''
                                      : userInfoBean.followCount.toString(),
                                ),
                                UserActiveInfoWidget(
                                  title: "粉丝",
                                  value: userInfoBean == null
                                      ? ''
                                      : userInfoBean.fansCount.toString(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  collapsedHeight: 50,
                  expandedHeight: overScroll < 0
                      ? maxExtentHeight - overScroll
                      : maxExtentHeight,
                  paddingTop: MediaQuery.of(context).padding.top,
                  coverImgUrl: userInfoBean.cover,
                  loading: CircleHeader(
                    _headerNotifier,
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverCustomBottomDelegate(
                  height: 40,
                  tabBar: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.orange,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                    tabs: [
                      Container(
                        child: Text(
                          '动态',
                        ),
                      ),
                      Container(
                        child: Text(
                          '结伴',
                        ),
                      ),
                      Container(
                        child: Text(
                          '招聘',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                  hasScrollBody: true,
                  fillOverscroll: true,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        color: Colors.red.withOpacity(0.1),
                        height: 1800,
                      ),
                      Container(
                        color: Colors.orange.withOpacity(0.1),
                        height: 1800,
                      ),
                      Container(
                        color: Colors.yellow.withOpacity(0.1),
                        height: 1800,
                      )
                    ],
                  ))
            ],
          ),
          onNotification: (ScrollUpdateNotification notification) {
            // 监听滑动
            setState(() {
              if (notification.metrics.axisDirection == AxisDirection.down ||
                  notification.metrics.axisDirection == AxisDirection.up)
                overScroll = notification.metrics.pixels;
            });
            return false;
          },
        ),
        Positioned.fill(
          child: Stack(
            children: List.generate(_bubbleOffsetList.length, (index) {
              return CircleMovingBubble(
                top: _bubbleOffsetList[index].dy,
                left: _bubbleOffsetList[index].dx,
                radians: _calculateBubbleRadians(),
                diameter: _calculateBubbleDiameter(),
                backgroundColor: Colors.black38,
                child: Text(
                  _textList[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _calculateBubbleFontSize(),
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    ));
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final Widget title;
  final Widget loading;
  final Widget leading;
  final Widget action;
  final Widget expandedBackgroundWidget;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
    this.loading,
    this.leading,
    this.action,
    this.expandedBackgroundWidget,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  set maxExtent(double maxExtent) {
    this.maxExtent = maxExtent;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(child: Image.network(this.coverImgUrl, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x90000000),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: expandedBackgroundWidget,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              // color: Colors.white,
              child: loading,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: Colors.transparent,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leading,
                      title != null ? Expanded(child: title) : SizedBox(),
                      action,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverCustomBottomDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final double height;

  SliverCustomBottomDelegate({
    this.tabBar,
    this.height,
  });

  @override
  double get minExtent => this.height;

  @override
  double get maxExtent => this.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      height: this.maxExtent,
      child: tabBar,
    );
  }
}

class CircleHeader extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;

  const CircleHeader(this.linkNotifier, {Key key}) : super(key: key);

  @override
  CircleHeaderState createState() {
    return CircleHeaderState();
  }
}

class CircleHeaderState extends State<CircleHeader> {
  // 指示器值
  double _indicatorValue = 0.0;

  Color backgroundColor = Colors.transparent;

  RefreshMode get _refreshState => widget.linkNotifier.refreshState;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  @override
  void initState() {
    super.initState();
    widget.linkNotifier.addListener(onLinkNotify);
  }

  @override
  void dispose() {
    super.dispose();
    widget.linkNotifier.dispose();
  }

  void onLinkNotify() {
    print("listen");
    setState(() {
      if (_refreshState == RefreshMode.armed ||
          _refreshState == RefreshMode.refresh) {
        _indicatorValue = null;
        backgroundColor = Colors.white;
      } else if (_refreshState == RefreshMode.refreshed ||
          _refreshState == RefreshMode.done) {
        _indicatorValue = 1.0;
        backgroundColor = Colors.white;
      } else {
        if (_refreshState == RefreshMode.inactive) {
          _indicatorValue = 0.0;
          backgroundColor = Colors.transparent;
        } else {
          double indicatorValue = _pulledExtent / 70.0 * 0.8;
          _indicatorValue = indicatorValue < 0.8 ? indicatorValue : 0.8;
          backgroundColor = Colors.white;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        alignment: Alignment.center,
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(
          value: _indicatorValue,
          valueColor: AlwaysStoppedAnimation(Colors.orange),
          strokeWidth: 2.4,
        ),
      ),
    );
  }
}
