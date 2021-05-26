import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/bean/user_token_bean.dart';
import 'package:far_away_flutter/component/animated_login_button.dart';
import 'package:far_away_flutter/page/login/phone_login_bottom.dart';
import 'package:far_away_flutter/page/login/send_code_widget.dart';
import 'package:far_away_flutter/properties/rong_cloud_properties.dart';
import 'package:far_away_flutter/properties/shared_preferences_keys.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/logger_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/reg_exp_util.dart';
import 'package:far_away_flutter/util/sp_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

import 'login_input_text_field.dart';

InputDecoration _inputDecoration({@required String hintText}) {
  return InputDecoration(
      contentPadding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          bottom: ScreenUtil().setHeight(20),
          top: ScreenUtil().setHeight(20)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown),
          borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey));
}

class PhoneLoginForm extends StatefulWidget {
  @override
  _PhoneLoginFormState createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends State<PhoneLoginForm> {

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final AnimatedLoginButtonStatusController _loginController = AnimatedLoginButtonStatusController();
  final SendCodeWidgetStatusController _sendingController = SendCodeWidgetStatusController();

  bool _mobileComplete = false;

  bool _codeComplete = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(115),
      ),
      child: Column(
        children: [
          Container(
              height: ScreenUtil().setHeight(80),
              child: LoginInputTextField(
                controller: _mobileController,
                autoFocus: true,
                onChange: (phone) {
                  if (RegExpUtil.isPhone(phone)) {
                    _mobileComplete = true;
                    _sendingController.setStatus(SendStatus.available);
                    if (_codeComplete) {
                      _loginController.setStatus(LoginStatus.available);
                    }
                  } else {
                    _mobileComplete = false;
                    _sendingController.setStatus(SendStatus.disable);
                    _loginController.setStatus(LoginStatus.disable);
                  }
                  setState(() {});
                },
                inputDecoration: _inputDecoration(hintText: "请输入手机号"),
              )),
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(80),
                      child: LoginInputTextField(
                        controller: _codeController,
                        onChange: (code) {
                          if (RegExpUtil.isValidateCaptcha(code)) {
                            _codeComplete = true;
                            if (_mobileComplete) {
                              _loginController.setStatus(LoginStatus.available);
                            }
                          } else {
                            _codeComplete = false;
                            _loginController.setStatus(LoginStatus.disable);
                          }
                          setState(() {});
                        },
                        inputDecoration:
                        _inputDecoration(hintText: "输入验证码"),
                      )),
                  SendCodeWidget(
                      controller: _sendingController,
                      fontSize: ScreenUtil().setSp(22),
                      color: Colors.black12,
                      textColor: Colors.brown,
                      disabledColor: Colors.black54,
                      disabledTextColor: Colors.white70,
                      send: () {
                        ApiMethodUtil.instance.getMobileCode(
                            success: (data) {
                              ToastUtil.showSuccessToast("发送成功");
                            },
                            failed: (data) {
                              ToastUtil.showErrorToast("发送失败");
                              _sendingController
                                  .setStatus(SendStatus.available);
                            },
                            error: (data) {
                              // 弹出totast 验证码重新回显
                              ToastUtil.showErrorToast("发送失败");
                              _sendingController
                                  .setStatus(SendStatus.available);
                            },
                            mobile: _mobileController.text);
                      })
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
            child: AnimatedLoginButton(
              height: ScreenUtil().setHeight(80),
              controller: _loginController,
              loginChild: Text(
                '登录',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(35),
                ),
              ),
              loadingChild: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                strokeWidth: 4,
              ),
              originLength: ScreenUtil().setWidth(400),
              criticalLength: ScreenUtil().setWidth(150),
              login: () async {
                // 此时登录会直接调用ProviderUtil中的Provider实例，虽然不标准，但问题不大。。
                ResponseBean responseBean = await ApiMethodUtil.mobileRegisterOrLogin(
                    mobile: _mobileController.text,
                    code: _codeController.text
                );
                if (responseBean == null) {
                  ToastUtil.showErrorToast("网络异常!");
                  _loginController.setStatus(LoginStatus.error);
                }
                if(responseBean.isSuccess()) {
                  UserTokenBean userTokenBean = UserTokenBean.fromJson(responseBean.data);
                  // 暂存token 通过token获取用户信息
                  responseBean = await ApiMethodUtil.getUserInfo(token: userTokenBean.token);
                  if(responseBean == null) {
                    ToastUtil.showErrorToast("网络异常!");
                    _loginController.setStatus(LoginStatus.error);
                  }
                  ProviderUtil.globalInfoProvider.userInfoBean = UserInfoBean.fromJson(responseBean.data);
                  ApiMethodUtil.rongCloudConnect(imToken: ProviderUtil.globalInfoProvider.userInfoBean.IMToken);
                  await SharedPreferenceUtil.instance.setString(SharedPreferencesKeys.userToken, userTokenBean.token);
                  NavigatorUtil.toMainPage(context);
                  return;
                }
                ToastUtil.showErrorToast(responseBean.message);
                _loginController.setStatus(LoginStatus.error);
              },
            ),
          ),
          Expanded(
            child: PhoneLoginBottom(),
          )
        ],
      ),
    );
  }
}
