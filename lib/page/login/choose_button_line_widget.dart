import 'dart:async';

import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_token_bean.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/properties/certificate_properties.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/dio_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tencent_kit/tencent_kit.dart';

class ChooseButtonLineWidget extends StatefulWidget {
  @override
  _ChooseButtonLineWidgetState createState() => _ChooseButtonLineWidgetState();
}

class _ChooseButtonLineWidgetState extends State<ChooseButtonLineWidget> {

  Tencent _tencent = Tencent()
    ..registerApp(appId: CertificateProperties.TENCENT_APP_ID);

  StreamSubscription<TencentLoginResp> _login;

  TencentLoginResp _loginResp;

  void _listenLogin(TencentLoginResp resp) {
    _loginResp = resp;
    print("openid: ${resp.openid}, accessToken: ${resp.accessToken}");
    ApiMethodUtil.instance.qqRegisterOrLogin(
      success: (data) {
        ResponseBean responseBean = ResponseBean.fromJson(data);
        if(responseBean.isSuccess()) {
          UserTokenBean userTokenBean = UserTokenBean.fromJson(responseBean.data);
          // 暂存token 通过token获取用户信息
        } else {
          print(responseBean.message);
        }
      },
      params: {
        "accessToken": resp.accessToken,
        "openId": resp.openid,
        "locationArea": ""
      },
    );
  }

  @override
  void dispose() {
    _login?.cancel();
    _login = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _login = _tencent.loginResp().listen(_listenLogin);
  }

  /// 第三方登录Widget
  Widget _getGradientIcon(context, VoidCallback redirectHandle, {Icon icon}) {
    return Container(
      height: ScreenUtil().setWidth(100),
      width: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.grey.withOpacity(0.5)),
      child: IconButton(
        onPressed: redirectHandle,
        icon: icon == null ? Icon(Icons.clear) : icon,
        color: Colors.white.withOpacity(0.95),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(500)),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: ScreenUtil().setWidth(550),
                  height: ScreenUtil().setHeight(90),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    color: Colors.white.withOpacity(0.8),
                    onPressed: () {
                      NavigatorUtil.toPhoneLoginPage(context);
                    },
                    child: Text(
                      '手机号登录注册',
                      style: TextStyle(
                          color: Colors.black87.withOpacity(0.7),
                          fontSize: ScreenUtil().setSp(26),
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w600,
                          fontFamily: AssetProperties.LOBSTER_FONT_FAMILY),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _getGradientIcon(
                  context,
                  () {
//                    _weibo.auth(appKey: _WEIBO_APP_KEY, scope: _WEIBO_SCOPE);
                  },
                  icon: Icon(
                    FontAwesomeIcons.weibo,
                    size: ScreenUtil().setSp(40),
                  ),
                ),
                _getGradientIcon(context, () {
                  _tencent.login(
                    scope: <String>[TencentScope.GET_USER_INFO],
                  );
                  // 获取到对应的auth token以及
                },
                    icon: Icon(
                      FontAwesomeIcons.qq,
                      size: ScreenUtil().setSp(40),
                    )),
                _getGradientIcon(context, () {},
                    icon: Icon(
                      FontAwesomeIcons.weixin,
                      size: ScreenUtil().setSp(40),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
