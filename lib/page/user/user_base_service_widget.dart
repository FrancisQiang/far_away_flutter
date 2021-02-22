import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserBaseServiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(15)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserBaseServiceItem(
            title: '我的点赞',
            boxColor: Colors.deepOrangeAccent,
            iconData: FontAwesomeIcons.heartbeat,
          ),
          UserBaseServiceItem(
            title: '我的收藏',
            boxColor: Colors.orangeAccent,
            iconData: FontAwesomeIcons.star,
          ),
          UserBaseServiceItem(
            title: '我的发布',
            boxColor: Colors.greenAccent,
            iconData: FontAwesomeIcons.fileAlt,
          ),
          UserBaseServiceItem(
            title: '我的评论',
            boxColor: Colors.blueAccent,
            iconData: FontAwesomeIcons.solidComments,
          ),
        ],
      ),
    );
  }
}

class UserBaseServiceItem extends StatelessWidget {

  final Color boxColor;

  final IconData iconData;

  final String title;

  UserBaseServiceItem({@required this.boxColor, @required this.iconData, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  boxColor.withOpacity(0.7),
                  boxColor.withOpacity(0.8),
                  boxColor.withOpacity(0.9),
                  boxColor.withOpacity(1.0),
                ]
              ),
              color: boxColor,
            ),
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(100),
            child: Icon(
              iconData,
              color: Colors.white,
              size: ScreenUtil().setSp(50),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Text(
              title,
              style: TextStyleTheme.h4,
            ),
          )
        ],
      ),
    );
  }
}
