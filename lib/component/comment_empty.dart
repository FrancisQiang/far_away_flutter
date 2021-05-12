import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentEmpty extends StatelessWidget {
  final double iconHeight;

  final double iconWidth;

  CommentEmpty({this.iconHeight = 200, this.iconWidth = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setHeight(30)),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconWidth,
              height: iconHeight,
              child: Image.asset('assets/png/blank_comment.png'),
            ),
          ],
        ));
  }
}
