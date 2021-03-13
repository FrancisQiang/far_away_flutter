import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/constant/my_color.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'dynamic_empty_widget.dart';

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
    Response<dynamic> data;
    ResponseBean response;
    PageBean pageBean;
    try {
      data = await ApiMethodUtil.getTogetherInfoList(
          timestamp: timestamp, currentPage: currentPage, token: jwt);
      response = ResponseBean.fromJson(data.data);
      pageBean = PageBean.fromJson(response.data);
      print(response.data);
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
          header: EasyRefreshWidget.refreshHeader,
          footer: EasyRefreshWidget.refreshFooter,
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
          child: Column(
              children: List.generate(togetherList.length, (index) {
            return GestureDetector(
                onTap: () => print("tap together"),
                child: TogetherInfoPreviewCard(
                    togetherInfoBean: togetherList[index]));
          })));
    });
  }
}

class TogetherInfoPreviewCard extends StatelessWidget {
  final TogetherInfoBean togetherInfoBean;

  TogetherInfoPreviewCard({@required this.togetherInfoBean});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                // 头像
                Container(
                    width: ScreenUtil().setWidth(90),
                    child: Hero(
                      tag: "together_${togetherInfoBean.id}",
                      child: ClipOval(
                          child: CachedNetworkImage(
                              imageUrl: togetherInfoBean.userAvatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ImageHolder(
                                    size: ScreenUtil().setSp(40),
                                  ),
                              errorWidget: (context, url, error) =>
                                  ImageErrorWidget(
                                    size: ScreenUtil().setSp(40),
                                  ))),
                    )),
                // 用户名和用户签名
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Row(
                        children: [
                          Container(
                            child: Text(
                              togetherInfoBean.username,
                              style: TextStyleTheme.h3,
                            ),
                          ),
                        ],
                      )),
                      Container(
                        child: Text(togetherInfoBean.signature,
                            style: TextStyleTheme.subH5),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // 动态内容
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
              right: ScreenUtil().setWidth(20),
            ),
            child: Text(togetherInfoBean.content,
                maxLines: 50,
                overflow: TextOverflow.ellipsis, style: TextStyleTheme.body),
          ),
          TimeLocationBar(
            time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(
                togetherInfoBean.publishTime)),
            location: togetherInfoBean.location,
            width: ScreenUtil().setWidth(500),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.share_outlined),
                        Container(
                          width: ScreenUtil().setWidth(60),
                          margin: EdgeInsets.only(left: 20),
                          child: Text("分享"),
                        )
                      ],
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.comment_outlined),
                        Container(
                          width: ScreenUtil().setWidth(60),
                          margin: EdgeInsets.only(left: 20),
                          child: Text("10"),
                        )
                      ],
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border),
                        Container(
                          width: ScreenUtil().setWidth(60),
                          margin: EdgeInsets.only(left: 20),
                          child: Text("10"),
                        )
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
