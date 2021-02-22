import 'package:far_away_flutter/page/login/phone_login_form_widget.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhoneLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                // 首先关闭键盘 防止溢出
                FocusScope.of(context).unfocus();
                NavigatorUtil.toLoginChoosePage(context);
              },
              child: Container(
                child: Icon(FontAwesomeIcons.angleLeft, color: Colors.black87),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(ScreenUtil().setHeight(50))),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  // alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(150)
                  ),
                  height: ScreenUtil().setHeight(400),
                  width: ScreenUtil().setWidth(600),
                  child: Image.asset(
                    "assets/png/login_bg.png"
                  )
                ),
                Container(
                  height: ScreenUtil().setHeight(180),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(150),
                    left: ScreenUtil().setWidth(80),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '无穷的远方',
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: ScreenUtil().setSp(55),
                            fontFamily: AssetProperties.FZ_SIMPLE,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                        ),
                        child: Text(
                          '与我有关',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(55),
                              fontFamily: AssetProperties.FZ_SIMPLE,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(50)
                ),
                child: PhoneLoginForm(),
              ),
            )
          ],
        ),
      )
    );
  }
}
