import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
            width: ScreenUtil().setWidth(60),
            child: Icon(
              Icons.search,
              size: ScreenUtil().setSp(38),
              color: Color(0xFF999999),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // 跳转到搜索页
                NavigatorUtil.toSearchPage(context);
              },
              child: Text(
                '请输入关键字',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
