import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/constant/my_color.dart';
import 'package:far_away_flutter/page/chat/chat_page.dart';
import 'package:far_away_flutter/page/home/home_page.dart';
import 'package:far_away_flutter/page/post/post_choose_widget.dart';
import 'package:far_away_flutter/page/user/user_center_page.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/properties/shared_preferences_keys.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/dio_factory.dart';
import 'package:far_away_flutter/util/logger_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/sp_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  final bool isLogin;

  MainPage({this.isLogin = false});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  bool isLogin;

  int _currentIndex = 0;

  // BottomNavigatorItem 控制器
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = PageController(initialPage: this._currentIndex);
    isLogin = widget.isLogin;
    // 如果此时是从登录页面进入的则直接通行
    if (isLogin) {
      return;
    }
    // 否则是打开应用进入的，那么此时会对应两种情况
    // 1. sharedPreference中存在jwt，那么登录态允许
    // 2. sharedPreference中不存在jwt，那么跳转到登录页面
    SharedPreferenceUtil.instance
        .getString(SharedPreferencesKeys.userToken)
        .then((value) async {
      // 通过token获取用户信息
      if (!StringUtil.isEmpty(value)) {
        try {
          // token暂存在内存中
          ProviderUtil.globalInfoProvider.jwt = value;
          DioFactory.setAuthorization(value);
          // 获取关注列表
          await ProviderUtil.globalInfoProvider.refreshFollowList();
          // 更新用户信息
          ResponseBean response = await ApiMethodUtil.getUserInfo();
          ProviderUtil.globalInfoProvider.userInfoBean =
              UserInfoBean.fromJson(response.data);
          // IM系统登录
          ApiMethodUtil.rongCloudConnect(
              imToken: ProviderUtil.globalInfoProvider.userInfoBean.IMToken);
        } catch (ex) {
          LoggerUtil.logger.e("Error! login session error!", ex);
          NavigatorUtil.toLoginChoosePage(context);
        }
        setState(() {
          isLogin = true;
        });
      } else {
        NavigatorUtil.toLoginChoosePage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
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
          isLogin
              ? HomePage()
              : InitRefreshWidget.instance,
          isLogin
              ? ChatPage()
              : InitRefreshWidget.instance,
          Container(),
          isLogin
              ? Container()
              : InitRefreshWidget.instance,
          isLogin
              ? UserCenterPage()
              : InitRefreshWidget.instance,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: this._currentIndex,
        onTap: (index) {
          if (index == 2) {
            showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return PostChooseWidget();
                });
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
              AssetProperties.HOME_INACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
            label: '首页',
            activeIcon: Image.asset(
              AssetProperties.HOME_ACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AssetProperties.MESSAGE_INACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
            label: '',
            activeIcon: Image.asset(
              AssetProperties.MESSAGE_ACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: ScreenUtil().setWidth(70),
              height: ScreenUtil().setWidth(55),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).primaryColor
              ),
              child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.black,
                size: ScreenUtil().setSp(30),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AssetProperties.MESSAGE_INACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
            label: '',
            activeIcon: Image.asset(
              AssetProperties.MESSAGE_ACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AssetProperties.PROFILE_INACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
            label: '',
            activeIcon: Image.asset(
              AssetProperties.PROFILE_ACTIVE,
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
          ),
        ],
      ),
    );
  }
}
