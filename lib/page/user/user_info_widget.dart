import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/component/circle_moving_bubble.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserInfoWidget extends StatefulWidget {
  final double scrollPixels;

  final List<String> textList;

  final List<Offset> bubbleOffsetList;

  final double bubbleRadians;

  final double bubbleDiameter;

  final double bubbleTextFontSize;

  final GlobalInfoProvider globalInfoProvider;

  UserInfoWidget(
      {@required this.scrollPixels,
      @required this.textList,
      @required this.bubbleOffsetList,
      @required this.bubbleRadians,
      @required this.bubbleDiameter,
      @required this.bubbleTextFontSize,
      @required this.globalInfoProvider});

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(650),
      child: Stack(
        children: [
          // 背景
          Container(
              child: Stack(
            children: [
              // cover背景
              Container(
                  height: ScreenUtil().setHeight(650),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.globalInfoProvider.userInfoBean == null
                        ? ''
                        : widget.globalInfoProvider.userInfoBean.cover,
                    fit: BoxFit.cover,
                  )),
              // cover背景高斯模糊
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          (Color.fromRGBO(225, 225, 225, 1)).withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              // cover背景运动小球 用户属性
              Positioned.fill(
                  child: Stack(
                      children: List.generate(widget.bubbleOffsetList.length,
                          (index) {
                return CircleMovingBubble(
                    top: widget.bubbleOffsetList[index].dy,
                    left: widget.bubbleOffsetList[index].dx,
                    radians: widget.bubbleRadians,
                    diameter: widget.bubbleDiameter,
                    backgroundColor: Colors.black38,
                    child: Text(
                      widget.textList[index],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.bubbleTextFontSize,
                          decoration: TextDecoration.none),
                    ));
              })))
            ],
          )),
          // 用户相关资料
          Positioned(
            top: ScreenUtil().setHeight(200),
            child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(105)),
                height: ScreenUtil().setHeight(550),
                width: ScreenUtil().setWidth(750),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setWidth(200),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 10)
                          ],
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(110))),
                          border: Border.all(
                              width: 1.5,
                              style: BorderStyle.solid,
                              color: Colors.white)),
                      child: ClipOval(
                          child: CachedNetworkImage(
                        imageUrl: widget.globalInfoProvider.userInfoBean == null
                            ? ''
                            : widget.globalInfoProvider.userInfoBean.avatar,
                        fit: BoxFit.cover,
                      )),
                    ),
                    Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            // 用户名
                            Container(
                              child: Text(
                                widget.globalInfoProvider.userInfoBean == null
                                    ? ''
                                    : widget.globalInfoProvider.userInfoBean
                                        .userName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(35),
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            // 性别
                            widget.globalInfoProvider.userInfoBean != null &&
                                    widget.globalInfoProvider.userInfoBean
                                            .gender !=
                                        0
                                ? Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(8)),
                                    height: ScreenUtil().setWidth(45),
                                    width: ScreenUtil().setWidth(45),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.globalInfoProvider
                                          .userInfoBean.gender ==
                                          1
                                          ? Colors.blueAccent
                                          : Colors.pinkAccent,
                                    ),
                                    child: Icon(
                                      widget.globalInfoProvider.userInfoBean
                                                  .gender ==
                                              1
                                          ? FontAwesomeIcons.mars
                                          : FontAwesomeIcons.venus,
                                      size: ScreenUtil().setSp(28),
                                      color: Colors.white
                                    ),
                                  )
                                : Container(),
                          ],
                        )),
                    // 签名
                    Container(
                      width: ScreenUtil().setWidth(500),
                      alignment: Alignment.center,
                      child: Text(
                        widget.globalInfoProvider.userInfoBean == null
                            ? ''
                            : widget.globalInfoProvider.userInfoBean.signature,
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
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UserActiveInfoWidget(
                            title: "获赞",
                            value:
                                widget.globalInfoProvider.userInfoBean == null
                                    ? ''
                                    : widget.globalInfoProvider.userInfoBean
                                        .thumbCount
                                        .toString(),
                          ),
                          UserActiveInfoWidget(
                            title: "关注",
                            value:
                                widget.globalInfoProvider.userInfoBean == null
                                    ? ''
                                    : widget.globalInfoProvider.userInfoBean
                                        .followCount
                                        .toString(),
                          ),
                          UserActiveInfoWidget(
                            title: "粉丝",
                            value:
                                widget.globalInfoProvider.userInfoBean == null
                                    ? ''
                                    : widget.globalInfoProvider.userInfoBean
                                        .fansCount
                                        .toString(),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class UserActiveInfoWidget extends StatelessWidget {
  final String value;

  final String title;

  UserActiveInfoWidget({@required this.value, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              child: Text(
            value,
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w500),
          )),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: ScreenUtil().setSp(25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
