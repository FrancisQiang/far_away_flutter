import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UserMoreServiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(15)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20),
                left: ScreenUtil().setWidth(25)),
            child: Text(
              '更多服务',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Column(
              children: ListTile.divideTiles(context: context, tiles: [
                UserMoreServiceItem(
                  svgUri: 'assets/svg/verification.svg',
                  title: '实名认证',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/hotel.svg',
                  title: '我是旅店',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/feedback.svg',
                  title: '意见反馈',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/moon.svg',
                  title: '夜间模式',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/settings.svg',
                  title: '账号设置',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/about.svg',
                  title: '关于乏味',
                ),
                UserMoreServiceItem(
                  svgUri: 'assets/svg/partner.svg',
                  title: '乏味合伙人',
                ),
              ]).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class UserMoreServiceItem extends StatelessWidget {

  final String svgUri;

  final String title;

  UserMoreServiceItem({@required this.svgUri, @required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: ScreenUtil().setWidth(40),
        width: ScreenUtil().setWidth(40),
        child: SvgPicture.asset(svgUri),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
