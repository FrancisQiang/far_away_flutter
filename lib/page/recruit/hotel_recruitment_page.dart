import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
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
              return Card(
                color: Colors.transparent,
                elevation: 0,
                child: PhysicalModel(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        NavigatorUtil.toRecruitDetailPage(context,
                            param: RecruitDetailPageParam(
                                recruitDetailInfoBean:
                                recruitInfoList[index]));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              Image.network(recruitInfoList[index].cover),
                              Positioned(
                                left: ScreenUtil().setWidth(8),
                                bottom: ScreenUtil().setHeight(8),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(5)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black38,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white70,
                                          size: ScreenUtil().setSp(20),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          recruitInfoList[index].location,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize:
                                              ScreenUtil().setSp(20)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: ScreenUtil().setWidth(8),
                                bottom: ScreenUtil().setHeight(8),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Icon(
                                          FontAwesomeIcons.heart,
                                          color: Colors.white70,
                                          size: ScreenUtil().setSp(24),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          ' ${recruitInfoList[index].thumbCount}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize:
                                              ScreenUtil().setSp(24),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding:
                            EdgeInsets.all(ScreenUtil().setWidth(15)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: ScreenUtil().setWidth(38),
                                  height: ScreenUtil().setWidth(38),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        recruitInfoList[index].userAvatar),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(8)),
                                    child: Text(
                                      recruitInfoList[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(25),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.4,
                                          color: Colors.black87),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}
