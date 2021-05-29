import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/page/recruit/recruit_info_preview_card.dart';
import 'package:far_away_flutter/param/recruit_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecruitInfoPage extends StatefulWidget {
  @override
  _RecruitInfoPageState createState() => _RecruitInfoPageState();
}

class _RecruitInfoPageState extends State<RecruitInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int timestamp;

  int currentPage = 1;

  List<RecruitDetailInfoBean> recruitInfoList = [];

  _loadRecruitData(String jwt) async {
    ResponseBean responseBean;
    PageBean pageBean;
    try {
      responseBean = await ApiMethodUtil.getRecruitInfoList(
          timestamp: timestamp, currentPage: currentPage);
      pageBean = PageBean.fromJson(responseBean.data);
    } catch (ex) {
      print('error');
      return;
    }
    if (pageBean.list.isEmpty) {
      ToastUtil.showNoticeToast("没有数据啦");
      return;
    }
    currentPage++;
    setState(() {
      for (int i = 0; i < pageBean.list.length; i++) {
        RecruitDetailInfoBean bean =
            RecruitDetailInfoBean.fromJson(pageBean.list[i]);
        recruitInfoList.add(bean);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalInfoProvider>(
      builder: (context, globalInfoProvider, child) {
        return EasyRefresh(
          header: EasyRefreshWidget.getRefreshHeader(Colors.white, Theme.of(context).primaryColor),
          footer: EasyRefreshWidget.getRefreshFooter(Colors.white, Theme.of(context).primaryColor),
          firstRefresh: true,
          onRefresh: () async {
            recruitInfoList = [];
            currentPage = 1;
            timestamp = DateTime.now().millisecondsSinceEpoch;
            await _loadRecruitData(globalInfoProvider.jwt);
          },
          onLoad: () async {
            await _loadRecruitData(globalInfoProvider.jwt);
          },
          child: StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: ScreenUtil().setWidth(20),
            mainAxisSpacing: ScreenUtil().setHeight(15),
            itemCount: recruitInfoList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return RecruitInfoPreviewCard(
                recruitDetailInfoBean: recruitInfoList[index],
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}
