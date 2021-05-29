import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'file:///I:/flutter/new_travel/far_away_flutter/lib/page/dynamic/dynamic_preview_widget.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class DynamicsPage extends StatefulWidget {
  @override
  _DynamicsPageState createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  List<DynamicDetailBean> dynamicList = [];

  int currentPage = 1;

  int timestamp = DateTime.now().millisecondsSinceEpoch;


  loadDynamicData(String jwt) async {
    ResponseBean responseBean;
    PageBean pageBean;
    try {
      responseBean = await ApiMethodUtil.getDynamicList(
        timestamp: timestamp,
        currentPage: currentPage,
      );
      pageBean = PageBean.fromJson(responseBean.data);
    } catch (ex) {
      return;
    }
    if (pageBean.list.isEmpty) {
      ToastUtil.showNoticeToast("没有数据啦");
      return;
    }
    currentPage++;
    for (int i = 0; i < pageBean.list.length; i++) {
      DynamicDetailBean bean = DynamicDetailBean.fromJson(pageBean.list[i]);
      dynamicList.add(bean);
    }
    setState(() {});
  }

  onRefresh(jwt) async {
    dynamicList = [];
    currentPage = 1;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    await loadDynamicData(jwt);
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
        firstRefreshWidget: EasyRefreshWidget.initRefreshWidget,
        onRefresh: () async {
          onRefresh(globalInfoProvider.jwt);
        },
        onLoad: () async {
          await loadDynamicData(globalInfoProvider.jwt);
        },
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Ink(
              color: Colors.white,
              child: InkWell(
                splashColor: Theme.of(context).backgroundColor,
                highlightColor: Theme.of(context).backgroundColor,
                onTap: () => NavigatorUtil.toDynamicDetailPage(
                  context,
                  param: DynamicDetailParam(
                    avatarHeroTag: 'dynamic_${dynamicList[index].id}',
                    dynamicDetailBean: dynamicList[index],
                  ),
                ),
                child: DynamicPreviewWidget(
                  showFollowButton: false,
                  avatarAction: AvatarAction.toUserInfoPage,
                  dynamicDetailBean: dynamicList[index],
                  avatarHeroTag: 'dynamic[${dynamicList[index].id}]',
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 5,
              color: Colors.transparent,
            );
          },
          itemCount: dynamicList.length,
        ),
      );
    });
  }
}