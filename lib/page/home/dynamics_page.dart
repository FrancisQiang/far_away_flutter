import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/animated_follow_button.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/component/link_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/provider/dynamics_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import 'dynamic_empty_widget.dart';

class DynamicsPage extends StatefulWidget {
  @override
  _DynamicsPageState createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer2<GlobalInfoProvider, DynamicsProvider>(
        builder: (context, globalInfoProvider, dynamicsProvider, child) {
      return EasyRefresh(
        header: EasyRefreshWidget.refreshHeader,
        footer: EasyRefreshWidget.refreshFooter,
        firstRefresh: true,
        firstRefreshWidget: InitRefreshWidget(
          color: Theme.of(context).primaryColor,
        ),
        emptyWidget: dynamicsProvider.dynamicList.length == 0
            ? ListEmptyWidget(
                width: ScreenUtil().setWidth(380),
                height: ScreenUtil().setHeight(300),
              )
            : null,
        onRefresh: () async {
          dynamicsProvider.dynamicList = [];
          dynamicsProvider.currentPage = 1;
          dynamicsProvider.timestamp = DateTime.now().millisecondsSinceEpoch;
          await dynamicsProvider.loadDynamicData(globalInfoProvider.jwt);
        },
        onLoad: () async {
          await dynamicsProvider.loadDynamicData(globalInfoProvider.jwt);
        },
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => NavigatorUtil.toDynamicDetailPage(
                context,
                param: DynamicDetailParam(
                  avatarHeroTag:
                  'dynamic_${dynamicsProvider.dynamicList[index].id}',
                  dynamicDetailBean: dynamicsProvider.dynamicList[index],
                ),
              ),
              child: DynamicPreviewCard(
                index: index,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 5,
              color: Colors.blueGrey.withOpacity(0.1),
            );
          },
          itemCount: dynamicsProvider.dynamicList.length,
        ),
      );
    });
  }
}

class DynamicPreviewCard extends StatelessWidget {
  final int index;

  DynamicPreviewCard({@required this.index});

  Widget _buildMediaWrap(DynamicsProvider dynamicsProvider) {
    DynamicDetailBean dynamicDetailBean = dynamicsProvider.dynamicList[index];
    return dynamicDetailBean.type == 1 ||
            dynamicDetailBean.mediaList.isEmpty ||
            dynamicDetailBean.mediaList == null
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10),
            ),
            child: MediaPreview(
              mediaList: dynamicDetailBean.mediaList,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicsProvider>(
        builder: (context, dynamicsProvider, child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
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
                        tag:
                            "dynamic_${dynamicsProvider.dynamicList[index].id}",
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                dynamicsProvider.dynamicList[index].userAvatar,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ImageHolder(
                              size: ScreenUtil().setSp(40),
                            ),
                            errorWidget: (context, url, error) =>
                                ImageErrorWidget(
                              size: ScreenUtil().setSp(40),
                            ),
                          ),
                        ),
                      )),
                  // 用户名和用户签名
                  Container(
                    width: ScreenUtil().setWidth(470),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            dynamicsProvider.dynamicList[index].username,
                            style: TextStyleTheme.h3,
                          ),
                        ),
                        Container(
                          child: Text(
                            dynamicsProvider.dynamicList[index].signature,
                            style: TextStyleTheme.subH5,
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedFollowButton(
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(110),
                    onPressed: () async {
                      Response<dynamic> response =
                          await ApiMethodUtil.followChange(
                        token: ProviderUtil.globalInfoProvider.jwt,
                        targetUserId:
                            dynamicsProvider.dynamicList[index].userId,
                      );
                      ResponseBean responseBean =
                          ResponseBean.fromJson(response.data);
                      FollowStatusBean followStatusBean =
                          FollowStatusBean.fromJson(responseBean.data);
                      for (DynamicDetailBean item
                          in dynamicsProvider.dynamicList) {
                        if (item.userId ==
                            dynamicsProvider.dynamicList[index].userId) {
                          item.follow = followStatusBean.follow;
                        }
                      }
                      return followStatusBean.follow;
                    },
                    follow: dynamicsProvider.dynamicList[index].follow,
                  ),
                ],
              ),
            ),
            // 动态内容
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(20),
              ),
              child: Text(dynamicsProvider.dynamicList[index].content,
                  overflow: TextOverflow.ellipsis, style: TextStyleTheme.body),
            ),
            // 媒体资源
            _buildMediaWrap(dynamicsProvider),
            dynamicsProvider.dynamicList[index].type == 0
                ? SizedBox()
                : Container(
                    width: ScreenUtil().setWidth(650),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(30)),
                    child: LinkWidget(
                      linkURL: dynamicsProvider.dynamicList[index].link,
                      linkImg: dynamicsProvider.dynamicList[index].linkImage,
                      linkTitle: dynamicsProvider.dynamicList[index].linkTitle,
                      imgSideLength: ScreenUtil().setWidth(120),
                    ),
                  ),
            Container(
              child: TimeLocationBar(
                time: DateUtil.getTimeString(
                    DateTime.fromMillisecondsSinceEpoch(
                        dynamicsProvider.dynamicList[index].publishTime)),
                location: dynamicsProvider.dynamicList[index].location,
                width: ScreenUtil().setWidth(750),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(18),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(45),
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/png/share_rect.png',
                            width: ScreenUtil().setWidth(45),
                            height: ScreenUtil().setWidth(40),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "分享",
                            ),
                          )
                        ],
                      )),
                  FlatButton(
                    onPressed: () {
                      NavigatorUtil.toDynamicDetailPage(
                        context,
                        param: DynamicDetailParam(
                            scrollToComment: true,
                            dynamicDetailBean:
                                dynamicsProvider.dynamicList[index]),
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/png/comment.png',
                              width: ScreenUtil().setWidth(45),
                              height: ScreenUtil().setWidth(40),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                CalculateUtil.simplifyCount(dynamicsProvider
                                    .dynamicList[index].commentsCount),
                              ),
                            )
                          ],
                        )),
                  ),
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: LikeButton(
                      size: ScreenUtil().setSp(40),
                      onTap: (bool isLiked) async {
                        await ApiMethodUtil.dynamicThumbChange(
                          token: ProviderUtil.globalInfoProvider.jwt,
                          thumb: !isLiked,
                          dynamicId: dynamicsProvider.dynamicList[index].id,
                        );
                        if (!isLiked) {
                          dynamicsProvider.dynamicList[index].thumbCount++;
                          dynamicsProvider.dynamicList[index].thumbed = true;
                        } else {
                          dynamicsProvider.dynamicList[index].thumbCount--;
                          dynamicsProvider.dynamicList[index].thumbed = false;
                        }
                        return !isLiked;
                      },
                      isLiked: dynamicsProvider.dynamicList[index].thumbed,
                      circleColor: CircleColor(
                          start: Colors.orangeAccent, end: Colors.orange),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Colors.orangeAccent,
                        dotSecondaryColor: Colors.orange,
                      ),
                      likeBuilder: (bool isLiked) {
                        if (isLiked) {
                          return Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: ScreenUtil().setSp(40),
                          );
                        } else {
                          return Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.black,
                            size: ScreenUtil().setSp(40),
                          );
                        }
                      },
                      likeCount: dynamicsProvider.dynamicList[index].thumbCount,
                      likeCountPadding: EdgeInsets.only(left: 5),
                      likeCountAnimationType:
                          dynamicsProvider.dynamicList[index].thumbCount < 1000
                              ? LikeCountAnimationType.part
                              : LikeCountAnimationType.none,
                      countBuilder: (int count, bool isLiked, String text) {
                        Color color = isLiked ? Colors.redAccent : Colors.black;
                        Widget result;
                        return Container(
                          child: Text(
                            count >= 1000
                                ? CalculateUtil.simplifyCount(count)
                                : text,
                            style: TextStyle(color: color),
                          ),
                        );
                        return result;
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
