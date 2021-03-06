import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TimeLocationBar extends StatelessWidget {
  final String time;

  final String location;

  final double width;

  final EdgeInsetsGeometry margin;

  final EdgeInsetsGeometry padding;

  TimeLocationBar(
      {@required this.time,
      this.location,
      this.width = double.infinity,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(time, style: TextStyleTheme.subH5),
          ),
          StringUtil.isEmpty(location)
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(left: 5, right: 2),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.orangeAccent,
                    size: ScreenUtil().setSp(30),
                  ),
          ),
          StringUtil.isEmpty(location)
              ? SizedBox()
              : Expanded(
                  child: Container(
                    child: Text(
                      location,
                      style: TextStyleTheme.subH5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
