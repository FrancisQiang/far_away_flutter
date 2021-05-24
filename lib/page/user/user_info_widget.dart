import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/circle_moving_bubble.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
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

  final UserInfoBean userInfoBean;

  UserInfoWidget(
      {@required this.scrollPixels,
      @required this.textList,
      @required this.bubbleOffsetList,
      @required this.bubbleRadians,
      @required this.bubbleDiameter,
      @required this.bubbleTextFontSize,
      @required this.userInfoBean});

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(640),
      child: Stack(
        children: [
          // 背景
          Container(
            child: Stack(
              children: [
                // cover背景
                Container(
                  height: ScreenUtil().setHeight(640),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.userInfoBean == null
                        ? ''
                        : widget.userInfoBean.cover,
                    fit: BoxFit.cover,
                  ),
                ),
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
                    children:
                        List.generate(widget.bubbleOffsetList.length, (index) {
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
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // 用户相关资料
          Positioned(
            top: ScreenUtil().setHeight(180),
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
                          imageUrl: widget.userInfoBean == null
                              ? ''
                              : widget.userInfoBean.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ProviderUtil.globalInfoProvider.userInfoBean.id ==
                            widget.userInfoBean.id
                        ? Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(15)),
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(40),
                            child: FlatButton(
                              onPressed: () {
                                NavigatorUtil.toProfileEditPage(context);
                              },
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.yellow.withOpacity(0.6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10)),
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
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 用户名
                            Container(
                              child: Text(
                                widget.userInfoBean == null
                                    ? ''
                                    : widget.userInfoBean.userName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // 性别
                            widget.userInfoBean != null &&
                                    widget.userInfoBean.gender != 0
                                ? Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(8)),
                                    child: Image.asset(
                                      'assets/png/${widget.userInfoBean.gender == 1 ? 'male' : 'female'}.png',
                                      height: ScreenUtil().setWidth(32),
                                      width: ScreenUtil().setWidth(32),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                          ],
                        )),
                    // 签名
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                      width: ScreenUtil().setWidth(500),
                      alignment: Alignment.center,
                      child: Text(
                        widget.userInfoBean == null
                            ? ''
                            : widget.userInfoBean.signature,
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
                            value: widget.userInfoBean == null
                                ? ''
                                : widget.userInfoBean.thumbCount.toString(),
                          ),
                          UserActiveInfoWidget(
                            title: "关注",
                            value: widget.userInfoBean == null
                                ? ''
                                : widget.userInfoBean.followCount.toString(),
                          ),
                          UserActiveInfoWidget(
                            title: "粉丝",
                            value: widget.userInfoBean == null
                                ? ''
                                : widget.userInfoBean.fansCount.toString(),
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
      height: ScreenUtil().setHeight(30),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(30),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' $title',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
        ]),
      ),
    );
  }
}
