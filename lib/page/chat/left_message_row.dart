import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LeftMessageRow extends StatelessWidget {
  final String avatar;

  final Widget messageBody;

  LeftMessageRow({@required this.messageBody, @required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(15),
        vertical: ScreenUtil().setHeight(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(12),
              top: 4,
              bottom: 4,
            ),
            child: ClipOval(
                child: CachedNetworkImage(
              imageUrl: avatar,
              width: ScreenUtil().setWidth(85),
              height: ScreenUtil().setWidth(85),
              fit: BoxFit.cover,
            )),
          ),
          Container(
              constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(550)),
              child: messageBody,
          ),
        ],
      ),
    );
  }
}
