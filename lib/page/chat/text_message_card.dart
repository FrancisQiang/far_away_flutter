import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TextMessageCard extends StatelessWidget {
  final String content;

  TextMessageCard({this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setWidth(80),
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(18),
            horizontal: ScreenUtil().setWidth(20)),
        child: Text('$content'),
      ),
    );
  }
}
