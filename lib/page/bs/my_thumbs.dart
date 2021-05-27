import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/mixing_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/dynamic_preview_widget.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/page/user/user_info_page.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class MyThumbsPage extends StatefulWidget {
  @override
  _MyThumbsPageState createState() => _MyThumbsPageState();
}

class _MyThumbsPageState extends State<MyThumbsPage> with TickerProviderStateMixin<MyThumbsPage>{


  TabController _tabController;

  final List<Tab> _tabs = [
    Tab(
      text: '动态',
    ),
    Tab(
      text: '结伴',
    ),
    Tab(
      text: '招聘',
    ),
  ];

  _getMyThumbsData() async {
    ResponseBean responseBean = await ApiMethodUtil.getMyThumbs();
    MixingBean mixingBean = MixingBean.fromJson(responseBean.data);
    mixingBean.dynamics.forEach((element) {
      dynamicList.add(DynamicDetailBean.fromJson(element));
    });
    mixingBean.togethers.forEach((element) {
      togetherList.add(TogetherInfoBean.fromJson(element));
    });
    mixingBean.recruits.forEach((element) {
      recruitList.add(RecruitDetailInfoBean.fromJson(element));
    });
    setState(() {});
  }

  List<DynamicDetailBean> dynamicList = [];
  List<TogetherInfoBean> togetherList = [];
  List<RecruitDetailInfoBean> recruitList = [];

  @override
  void initState() {
    super.initState();
    _getMyThumbsData();
    this._tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TabBar(
            isScrollable: true,
            labelColor: Colors.deepOrangeAccent,
            indicatorColor: Colors.deepOrangeAccent,
            labelStyle: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle:  TextStyle(
                fontSize: ScreenUtil().setSp(28),
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black54,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.5,
            tabs: _tabs
        ),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: OverScrollBehavior(),
        child: TabBarView(
          controller: _tabController,
          children: [
            ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () =>
                      NavigatorUtil.toDynamicDetailPage(
                        context,
                        param: DynamicDetailParam(
                          avatarHeroTag:
                          'dynamic_${dynamicList[index].id}',
                          dynamicDetailBean: dynamicList[index],
                        ),
                      ),
                  child: DynamicPreviewWidget(
                    dynamicDetailBean: dynamicList[index],
                    avatarAction: AvatarAction.toUserInfoPage,
                    showFollowButton: false,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 5,
                  color: Colors.blueGrey.withOpacity(0.1),
                );
              },
              itemCount: dynamicList.length,
            ),
            ListView(),
            ListView(),
          ],
        ),
      ),
    );
  }
}