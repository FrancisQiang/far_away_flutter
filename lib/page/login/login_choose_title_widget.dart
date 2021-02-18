import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/properties/string_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LoginChooseTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(150)),
        child: Column(
          children: [
            Container(
              child: Text(
                StringProperties.APP_NAME_CN,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: AssetProperties.FZ_SIMPLE,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 12.0,
                    fontSize: ScreenUtil().setSp(120)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
              child: Text(
              '探索你的远方',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: ScreenUtil().setWidth(3.0),
                      fontFamily: AssetProperties.FZ_SIMPLE,
                      fontWeight: FontWeight.w100,
                      fontSize: ScreenUtil().setSp(40))),
            )
          ],
        ));
  }
}
