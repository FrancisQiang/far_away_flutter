import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

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
                  assetsPath: 'assets/png/verification.png',
                  title: '实名认证',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/hotel.png',
                  title: '我是旅店',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/feedback.png',
                  title: '意见反馈',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/night_mode.png',
                  title: '夜间模式',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/settings.png',
                  title: '账号设置',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/about.png',
                  title: '关于乏味',
                ),
                UserMoreServiceItem(
                  assetsPath: 'assets/png/partner.png',
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

  final String assetsPath;

  final String title;

  UserMoreServiceItem({@required this.assetsPath, @required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        assetsPath,
        height: ScreenUtil().setWidth(50),
        width: ScreenUtil().setWidth(50),
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
