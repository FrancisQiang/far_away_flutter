import 'package:far_away_flutter/page/chat/message_page.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin<ChatPage> {

  // TabBar控制器
  TabController _tabController;

  final List<Tab> _tabs = [
    Tab(
      text: '消息',
    ),
    Tab(
      text: '与我相关',
    ),
  ];

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).primaryColorDark,
            indicatorColor: Theme.of(context).primaryColorDark,
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
      ),
      body: TabBarView(
          controller: _tabController,
          physics: BouncingScrollPhysics(),
          children: [
            ProviderUtil.getMessagePage(),
            Container(child: Text('与我相关'),),
          ],
      ),
    );
  }
}

