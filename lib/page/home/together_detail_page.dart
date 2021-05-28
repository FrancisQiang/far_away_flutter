import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/measure_size.dart';
import 'package:far_away_flutter/constant/biz_type.dart';
import 'package:far_away_flutter/page/comment/comment_bottom.dart';
import 'package:far_away_flutter/page/home/together_detail_component.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TogetherDetailPage extends StatefulWidget {

  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final TogetherInfoBean togetherInfoBean;

  TogetherDetailPage(
      {this.scrollToComment, this.avatarHeroTag, this.togetherInfoBean});

  @override
  _TogetherDetailPageState createState() => _TogetherDetailPageState();
}

class _TogetherDetailPageState extends State<TogetherDetailPage> {

  final TextEditingController commentEditController = TextEditingController();

  double bottomMargin = ScreenUtil().setHeight(100);

  _refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
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
                  child: Icon(FontAwesomeIcons.ellipsisH)),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: bottomMargin,
              ),
              child: TogetherDetailComponent(
                scrollToComment: widget.scrollToComment,
                avatarHeroTag: widget.avatarHeroTag,
                togetherInfoBean: widget.togetherInfoBean,
                refreshCallback: _refreshCallback,
                commentEditController: commentEditController,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: MeasureSize(
                child: CommentBottom(
                  bizType: BizType.TOGETHER_COMMENT,
                  bizId: widget.togetherInfoBean.id,
                  toUserId: widget.togetherInfoBean.userId,
                  commentEditController: commentEditController,
                  refreshCallback: _refreshCallback,
                ),
                onChange: (size) {
                  setState(() {
                    bottomMargin = size.height;
                  });
                },
              ),
            ),
          ],
        ),);
  }
}

