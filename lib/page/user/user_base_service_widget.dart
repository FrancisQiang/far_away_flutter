import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UserBaseServiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(30), bottom: ScreenUtil().setHeight(30)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserBaseServiceItem(
            title: '我的点赞',
            svgUri: 'assets/svg/my_thumbed.svg',
          ),
          UserBaseServiceItem(
            title: '我的收藏',
            svgUri: 'assets/svg/my_collection.svg',
          ),
          UserBaseServiceItem(
            title: '我的发布',
            svgUri: 'assets/svg/my_post.svg',
          ),
          UserBaseServiceItem(
            title: '我的评论',
            svgUri: 'assets/svg/my_comment.svg',
          ),
        ],
      ),
    );
  }
}

class UserBaseServiceItem extends StatelessWidget {
  final String svgUri;

  final String title;

  UserBaseServiceItem({@required this.svgUri, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setWidth(60),
            width: ScreenUtil().setWidth(60),
            child: SvgPicture.asset(svgUri),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: ScreenUtil().setSp(22),
                  letterSpacing: 0.6),
            ),
          )
        ],
      ),
    );
  }
}
