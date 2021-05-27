import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import 'MediaPreview.dart';
import 'animated_follow_button.dart';
import 'image_error_widget.dart';
import 'image_holder.dart';
import 'link_widget.dart';

enum AvatarAction {
  toUserInfoPage,
  preview,
  shake,
}

class DynamicPreviewWidget extends StatelessWidget {
  /// 点击头像的动作
  final AvatarAction avatarAction;

  final DynamicDetailBean dynamicDetailBean;

  final bool showFollowButton;

  DynamicPreviewWidget(
      {@required this.dynamicDetailBean,
      this.avatarAction = AvatarAction.preview, this.showFollowButton = true});

  Widget _buildMediaWrap() {
    return dynamicDetailBean.type == 1 || dynamicDetailBean.mediaList.isEmpty
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

  Widget _buildLink() {
    return dynamicDetailBean.type == 0
        ? SizedBox()
        : Container(
            width: ScreenUtil().setWidth(660),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
            child: LinkWidget(
              linkURL: dynamicDetailBean.link,
              linkImg: dynamicDetailBean.linkImage,
              linkTitle: dynamicDetailBean.linkTitle,
              imgSideLength: ScreenUtil().setWidth(120),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  // 头像
                  GestureDetector(
                    onTap: () {
                      switch (avatarAction) {
                        case AvatarAction.toUserInfoPage:
                          {
                            NavigatorUtil.toUserInfoPage(context,
                                userId: dynamicDetailBean.userId);
                            return;
                          }
                        case AvatarAction.preview:
                          {
                            // TODO
                            return;
                          }
                        case AvatarAction.shake:
                          {
                            // TODO
                            return;
                          }
                        default:
                          return;
                      }
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(90),
                      child: Hero(
                        tag: "dynamic_${dynamicDetailBean.id}",
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: dynamicDetailBean.userAvatar,
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
                      ),
                    ),
                  ),
                  // 用户名和用户签名
                  Container(
                    width: showFollowButton ? ScreenUtil().setWidth(480): ScreenUtil().setWidth(590),
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
                          child: Text(
                            dynamicDetailBean.signature,
                            maxLines: 1,
                            style: TextStyleTheme.subH5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  showFollowButton ?
                  AnimatedFollowButton(
                    height: ScreenUtil().setHeight(45),
                    width: ScreenUtil().setWidth(110),
                    onPressed: () async {
                      ResponseBean responseBean = await ApiMethodUtil.followChange(
                        targetUserId: dynamicDetailBean.userId,
                      );
                      FollowStatusBean followStatusBean = FollowStatusBean.fromJson(responseBean.data);
                      if (followStatusBean.follow) {
                        FollowUserInfo followUserInfo = FollowUserInfo();
                        followUserInfo.userId = dynamicDetailBean.userId;
                        followUserInfo.username = dynamicDetailBean.username;
                        followUserInfo.userAvatar = dynamicDetailBean.userAvatar;
                        globalInfoProvider.followUserMap[dynamicDetailBean.userId] = followUserInfo;
                      } else {
                        globalInfoProvider.followUserMap.remove(dynamicDetailBean.userId);
                      }
                      globalInfoProvider.refresh();
                    },
                    follow: globalInfoProvider.followUserMap.containsKey(dynamicDetailBean.userId),
                  ): SizedBox(),
                ],
              ),
            ),
            // 动态内容
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(22),
              ),
              child: Text(
                dynamicDetailBean.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyleTheme.body,
              ),
            ),
            // 媒体资源
            _buildMediaWrap(),
            // 链接
            _buildLink(),
            TimeLocationBar(
              time: DateUtil.getTimeString(
                DateTime.fromMillisecondsSinceEpoch(
                    dynamicDetailBean.publishTime),
              ),
              location: dynamicDetailBean.location,
              width: ScreenUtil().setWidth(750),
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(18),
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
                          AssetProperties.SHARE_RECT,
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
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      NavigatorUtil.toDynamicDetailPage(
                        context,
                        param: DynamicDetailParam(
                          scrollToComment: true,
                          dynamicDetailBean: dynamicDetailBean,
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetProperties.COMMENT,
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
                        ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: LikeButton(
                      size: ScreenUtil().setSp(40),
                      onTap: (bool isLiked) async {
                        await ApiMethodUtil.dynamicThumbChange(
                          thumb: !isLiked,
                          dynamicId: dynamicDetailBean.id,
                        );
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
                      likeCount: dynamicDetailBean.thumbCount,
                      likeCountPadding: EdgeInsets.only(left: 5),
                      likeCountAnimationType:
                          dynamicDetailBean.thumbCount < 1000
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
