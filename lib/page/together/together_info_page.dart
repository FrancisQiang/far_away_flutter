import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/component/list_empty_widget.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/page/together/together_info_preview_widget.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class TogetherInfoPage extends StatefulWidget {
  @override
  _TogetherInfoPageState createState() => _TogetherInfoPageState();
}

class _TogetherInfoPageState extends State<TogetherInfoPage>
    with AutomaticKeepAliveClientMixin {
  int timestamp;

  @override
  bool get wantKeepAlive => true;

  List<TogetherInfoBean> togetherList = [];

  int currentPage = 1;

  _loadTogetherData(String jwt) async {
    ResponseBean responseBean;
    PageBean pageBean;
    try {
      responseBean = await ApiMethodUtil.getTogetherInfoList(
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
        TogetherInfoBean bean = TogetherInfoBean.fromJson(pageBean.list[i]);
        togetherList.add(bean);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return EasyRefresh(
        header: EasyRefreshWidget.getRefreshHeader(
            Colors.white, Theme.of(context).primaryColor),
        footer: EasyRefreshWidget.getRefreshFooter(
            Colors.white, Theme.of(context).primaryColor),
        firstRefresh: true,
        firstRefreshWidget: InitRefreshWidget(
          color: Theme.of(context).primaryColor,
        ),
        emptyWidget: togetherList.length == 0
            ? ListEmptyWidget(
                width: ScreenUtil().setWidth(380),
                height: ScreenUtil().setHeight(300),
              )
            : null,
        onRefresh: () async {
          togetherList = [];
          currentPage = 1;
          timestamp = DateTime.now().millisecondsSinceEpoch;
          await _loadTogetherData(globalInfoProvider.jwt);
        },
        onLoad: () async {
          await _loadTogetherData(globalInfoProvider.jwt);
        },
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: togetherList.length,
          itemBuilder: (context, index) {
            return Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () => NavigatorUtil.toTogetherDetailPage(context,
                    param: TogetherDetailParam(
                        avatarHeroTag: 'together_${togetherList[index].id}',
                        togetherInfoBean: togetherList[index])),
                splashColor: Theme.of(context).backgroundColor,
                highlightColor: Theme.of(context).backgroundColor,
                child: TogetherInfoPreviewWidget(
                  togetherInfoBean: togetherList[index],
                  avatarHeroTag: 'together[${togetherList[index].id}]',
                  avatarAction: AvatarAction.toUserInfoPage,
                  showFollowButton: false,
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
        ),
      );
    });
  }
}
