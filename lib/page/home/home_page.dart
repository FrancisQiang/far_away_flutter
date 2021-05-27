
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/constant/my_color.dart';
import 'package:far_away_flutter/page/home/search_text_field.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'hotel_recruitment_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {

  TabController _tabController;

  final List<Tab> _tabs = [
    Tab(
      text: '动态圈',
    ),
    Tab(
      text: '结伴广场',
    ),
    Tab(
      text: '义工招聘',
    ),
  ];

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        bottom: PreferredSize(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 30,
            child: TabBar(
              isScrollable: true,
              labelColor: Theme.of(context).primaryColorDark,
              indicatorColor: Theme.of(context).primaryColorDark,
              labelStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: Colors.black54,
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.5,
              tabs: _tabs,
            ),
          ),
          preferredSize: Size(double.infinity, 30),
        )
      ),
      body: ScrollConfiguration(
        behavior: OverScrollBehavior.instance,
        child: TabBarView(
          controller: _tabController,
          children: [
            ProviderUtil.getDynamicsPage(),
            ProviderUtil.getTogetherPage(),
            RecruitInfoPage(),
          ],
        ),
      )
    );
  }
}
