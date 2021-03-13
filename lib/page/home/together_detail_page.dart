import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/text_comment_bottom.dart';
import 'package:far_away_flutter/page/home/together_detail_component.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'comment_bottom.dart';

class TogetherDetailPage extends StatelessWidget {
  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final TogetherInfoBean togetherInfoBean;

  TogetherDetailPage(
      {this.scrollToComment, this.avatarHeroTag, this.togetherInfoBean});

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
                  child: Icon(
                      FontAwesomeIcons.ellipsisH
                  )
              ),
            )
          ],
        ),
        body: KeyboardDismissOnTap(
          child: Stack(
            children: [
              Container(
                  child: TogetherDetailComponent(
                    scrollToComment: scrollToComment,
                    avatarHeroTag: avatarHeroTag,
                    togetherInfoBean: togetherInfoBean,
                  )),
              Positioned(left: 0, bottom: 0, child: TextCommentBottom())
            ],
          ),
        ));
  }
}
