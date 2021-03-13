import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PostChooseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        color: Colors.white,
      ),
      height: ScreenUtil().setHeight(220),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PostChooseItem(
              title: '发动态',
              colors: [Colors.amber, Colors.amberAccent],
              icon: FontAwesomeIcons.paperPlane,
              onTap: () {
                Navigator.pop(context);
                NavigatorUtil.toPostDynamicPage(context);
              }),
          PostChooseItem(
            title: '发结伴',
            colors: [Colors.cyan, Colors.cyanAccent],
            icon: FontAwesomeIcons.userFriends,
            onTap: () {
              Navigator.pop(context);
              NavigatorUtil.toPostTogetherPage(context);
            },
          ),
          PostChooseItem(
            title: '招义工',
            colors: [Colors.lightGreen, Colors.lightGreenAccent],
            icon: FontAwesomeIcons.userGraduate,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class PostChooseItem extends StatelessWidget {
  final String title;

  final List<Color> colors;

  final IconData icon;

  final GestureTapCallback onTap;

  PostChooseItem(
      {@required this.title,
      @required this.colors,
      @required this.icon,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(
                ScreenUtil().setWidth(35)
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
            child: Text(
              title,
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: ScreenUtil().setSp(25),
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
