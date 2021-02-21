import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/my_icons.dart';
import 'package:far_away_flutter/page/home/home_page.dart';
import 'package:far_away_flutter/page/post/post_choose_widget.dart';
import 'package:far_away_flutter/page/user/user_center_page.dart';
import 'package:far_away_flutter/properties/shared_preferences_keys.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/sp_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert' as convert;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  int _currentIndex = 0;

  // BottomNavigatorItem 控制器
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    bool occurException = false;
    SharedPreferenceUtil.instance.getString(SharedPreferencesKeys.userToken).then((value) async {
      // 通过token获取用户信息
      if(!StringUtil.isEmpty(value)) {
        try {
          // token暂存在内存中
          ProviderUtil.globalInfoProvider.jwt = value;
          print(ProviderUtil.globalInfoProvider.jwt);
          Response<dynamic> userInfoResponse = await ApiMethodUtil.getUserInfo(token: value);
          ResponseBean response = ResponseBean.fromJson(userInfoResponse.data);
          // 存放在全局变量中
          ProviderUtil.globalInfoProvider.userInfoBean = UserInfoBean.fromJson(response.data);
        } catch (ex) {
          print(ex);
          occurException = true;
          NavigatorUtil.toLoginChoosePage(context);
        }
      } else {
        occurException = true;
        NavigatorUtil.toLoginChoosePage(context);
      }
    });
    if(occurException) {
      return;
    }
    this._pageController = PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor:Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(

      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: this._pageController,
        children: [
          HomePage(),
          Container(
            child: Text('2'),
          ),
          Container(),
          Container(
            child: Text('3'),
          ),
          UserCenterPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        fixedColor: Colors.deepOrangeAccent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: this._currentIndex,
        onTap: (index) {
          print(index);
          if (index == 2) {
            showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return PostChooseWidget();
                }
            );
            return;
          }
          setState(() {
            this._currentIndex = index;
            this._pageController.jumpToPage(this._currentIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/png/home_inactive.png',
              width: ScreenUtil().setWidth(36),
              height: ScreenUtil().setWidth(36),
            ),
            label: '首页',
            activeIcon: SvgPicture.asset(
              'assets/svg/home_active.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/message_inactive.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
            label: '',
            activeIcon: SvgPicture.asset(
              'assets/svg/message_active.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: ScreenUtil().setWidth(65),
              height: ScreenUtil().setWidth(50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.orange),
              child: Icon(
                MyIcons.PLUS,
                color: Colors.black,
                size: ScreenUtil().setSp(25),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/message_inactive.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
            label: '',
            activeIcon: SvgPicture.asset(
              'assets/svg/message_active.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/profile_inactive.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
            label: '',
            activeIcon: SvgPicture.asset(
              'assets/svg/profile_active.svg',
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(35),
            ),
          ),
        ],
      ),
    );
  }
}

