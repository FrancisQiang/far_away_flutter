import 'dart:ui';

import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'comment_bottom.dart';
import 'dynamic_detail_component.dart';

class DynamicDetailPage extends StatelessWidget {
  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final DynamicDetailBean dynamicDetailBean;

  DynamicDetailPage(
      {this.scrollToComment, this.avatarHeroTag, this.dynamicDetailBean});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          elevation: 0.0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(FontAwesomeIcons.angleLeft),
            ),
          ),
          centerTitle: true,
          title: Text(
            '乏味',
            style: TextStyle(
                fontFamily: AssetProperties.FZ_SIMPLE,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(40),
                letterSpacing: 3),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30)),
                  child: SvgPicture.asset(
                    'assets/svg/three_dots.svg',
                    width: ScreenUtil().setWidth(30),
                  )),
            )
          ],
        ),
        body: KeyboardDismissOnTap(
          child: Stack(
            children: [
              Container(
                  child: DynamicDetailComponent(
                scrollToComment: scrollToComment,
                avatarHeroTag: avatarHeroTag,
                dynamicDetailBean: dynamicDetailBean,
              )),
              Positioned(left: 0, bottom: 0, child: CommentBottom())
            ],
          ),
        ));
  }
}
