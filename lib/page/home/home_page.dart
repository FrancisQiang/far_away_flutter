
import 'package:far_away_flutter/page/home/aid_education_page.dart';
import 'package:far_away_flutter/page/home/dynamics_page.dart';
import 'package:far_away_flutter/page/home/search_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'go_with_page.dart';
import 'hotel_recruitment_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {

  // TabBar控制器
  TabController _tabController;

  final List<Tab> _tabs = [
    Tab(
      text: '动态圈',
    ),
    Tab(
      text: '结伴广场',
    ),
    Tab(
      text: '旅舍招聘',
    ),
    Tab(
      text: '支教信息',
    ),
  ];

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        leading: InkWell(
          onTap: () => {},
          child: Icon(
            Icons.menu_rounded,
            color: Colors.black,
          ),
        ),
        title: SearchTextField(),
        actions: [
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            width: ScreenUtil().setWidth(80),
            child: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          )
        ],
        bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.deepOrangeAccent,
            indicatorColor: Colors.deepOrangeAccent,
            labelStyle: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black54,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.5,
            tabs: _tabs),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: BouncingScrollPhysics(),
          children: [
            DynamicsPage(),
            GoWithPage(),
            HotelRecruitmentPage(),
            AidEducationPage(),
          ]),
    );
  }
}
