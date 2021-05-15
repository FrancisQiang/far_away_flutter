import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/animated_follow_button.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/link_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/provider/dynamics_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';


class DynamicDetailWidget extends StatelessWidget {

  final String avatarHeroTag;

  final DynamicDetailBean dynamicDetailBean;

  DynamicDetailWidget(
      {@required this.avatarHeroTag, @required this.dynamicDetailBean});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DynamicsProvider, GlobalInfoProvider>(
      builder: (context, dynamicsProvider, globalInfoProvider, child) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                        width: ScreenUtil().setWidth(100),
                        child: Hero(
                          tag: avatarHeroTag,
                          child: ClipOval(
                            child: CachedNetworkImage(
                                imageUrl: dynamicDetailBean.userAvatar,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => ImageHolder(
                                  size: ScreenUtil().setWidth(100),
                                ),
                                errorWidget: (context, url, error) =>
                                    ImageErrorWidget(
                                      size: ScreenUtil().setWidth(100),
                                    )),
                          ),
                        )),
                    Container(
                      width: ScreenUtil().setWidth(470),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              dynamicDetailBean.username,
                              style: TextStyleTheme.h3,
                            ),
                          ),
                          Container(
                            child: Text(dynamicDetailBean.signature,
                                style: TextStyleTheme.subH5),
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
                          targetUserId: dynamicDetailBean.userId,
                        );
                        ResponseBean responseBean =
                        ResponseBean.fromJson(response.data);
                        FollowStatusBean followStatusBean =
                        FollowStatusBean.fromJson(responseBean.data);
                        if(followStatusBean.follow) {
                          FollowUserInfo followUserInfo = FollowUserInfo();
                          followUserInfo.userId = dynamicDetailBean.userId;
                          followUserInfo.username = dynamicDetailBean.username;
                          followUserInfo.userAvatar = dynamicDetailBean.userAvatar;
                          globalInfoProvider.followUserMap[dynamicDetailBean.userId] = followUserInfo;
                        } else {
                          globalInfoProvider.followUserMap.remove(dynamicDetailBean.userId);
                        }
                        // for (int i = 0; i < dynamicsProvider.dynamicList.length; i++) {
                        //   if (dynamicsProvider.dynamicList[i].userId == dynamicDetailBean.userId) {
                        //     dynamicsProvider.dynamicList[i].follow = followStatusBean.follow;
                        //   }
                        // }
                        globalInfoProvider.refresh();
                        // dynamicsProvider.refresh();
                      },
                      follow: globalInfoProvider.followUserMap.containsKey(dynamicDetailBean.userId),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(15),
                  right: ScreenUtil().setWidth(20),
                ),
                child: Text(
                  dynamicDetailBean.content,
                  textAlign: TextAlign.start,
                  style: TextStyleTheme.body,
                ),
              ),
              dynamicDetailBean.type == 0
                  ? Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                child: MediaPreview(
                  mediaList: dynamicDetailBean.mediaList,
                ),
              )
                  : Container(
                width: ScreenUtil().setWidth(650),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(30)
                ),
                child: LinkWidget(
                    linkURL: dynamicDetailBean.link,
                    linkImg: dynamicDetailBean.linkImage,
                    linkTitle: dynamicDetailBean.linkTitle,
                    imgSideLength: ScreenUtil().setWidth(120)),
              ),
              TimeLocationBar(
                width: ScreenUtil().setWidth(750),
                time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(
                    dynamicDetailBean.publishTime)),
                location: dynamicDetailBean.location,
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              ),
              Container(
                height: ScreenUtil().setHeight(35),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
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
                        )
                    ),
                    FlatButton(
                      onPressed: null,
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
                                  CalculateUtil.simplifyCount(
                                      dynamicDetailBean.commentsCount),
                                ),
                              )
                            ],
                          )
                      ),
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
                              dynamicId: dynamicDetailBean.id);
                          if (!isLiked) {
                            dynamicDetailBean.thumbCount++;
                            dynamicDetailBean.thumbed = true;
                          } else {
                            dynamicDetailBean.thumbCount--;
                            dynamicDetailBean.thumbed = false;
                          }
                          return !isLiked;
                        },
                        isLiked: dynamicDetailBean.thumbed,
                        circleColor: CircleColor(
                            start: Colors.orangeAccent, end: Colors.orange),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: Colors.orangeAccent,
                          dotSecondaryColor: Colors.orange,
                        ),
                        likeCountAnimationType: dynamicDetailBean.thumbCount < 1000
                            ? LikeCountAnimationType.part
                            : LikeCountAnimationType.none,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite_border_outlined,
                            color: isLiked ? Colors.redAccent : Colors.black,
                            size: ScreenUtil().setSp(42),
                          );
                        },
                        likeCount: dynamicDetailBean.thumbCount,
                        likeCountPadding: EdgeInsets.only(left: 8),
                        countBuilder: (int count, bool isLiked, String text) {
                          Color color = isLiked ? Colors.redAccent : Colors.black;
                          Widget result;
                          if (count == 0) {
                            result = SizedBox();
                          } else {
                            result = Text(
                              count >= 1000
                                  ? CalculateUtil.simplifyCount(count)
                                  : text,
                              style: TextStyle(color: color),
                            );
                          }
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
      },
    );
  }
}
