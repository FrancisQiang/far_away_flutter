import 'package:far_away_flutter/bean/find_user_info_bean.dart';
import 'package:far_away_flutter/bean/list_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/page/activity/user_info_card.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'change_user_list_card.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool load = false;

  List<FindUserInfoBean> userList = [];

  @override
  void initState() {
    getRandUserList();
    super.initState();
  }

  getRandUserList() async {
    ResponseBean responseBean = await ApiMethodUtil.getRandUserList();
    ListBean listBean = ListBean.fromJson(responseBean.data);
    for (var element in listBean.listData) {
      userList.add(FindUserInfoBean.fromJson(element));
    }
    setState(() {
      load = true;
    });
  }

  buildBody() {
    if (!load) {
      return InitRefreshWidget.instance;
    }
    return ScrollConfiguration(
      behavior: OverScrollBehavior(),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(370),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                      child: UserInfoCard(
                        findUserInfoBean: userList[index],
                      ),
                    );
                  },
                  itemCount: userList.length,
                  viewportFraction: 0.48,
                  scale: 0.8,
                  loop: false,
                  index: 2,
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(22)),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      userList.clear();
                      await getRandUserList();
                    },
                    child: Text(
                      '换一批',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 6,
                color: Theme.of(context).backgroundColor,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(22),
                  vertical: ScreenUtil().setHeight(12)
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '近期活动',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: SizedBox(),
        title: Text(
          '探索',
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(38),
            letterSpacing: 5,
          ),
        ),
      ),
      body: buildBody(),
    );
  }
}
