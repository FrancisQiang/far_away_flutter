import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import 'animated_follow_button.dart';
import 'image_error_widget.dart';
import 'image_holder.dart';

class UserInfoHeader extends StatelessWidget {
  final String avatarHeroTag;

  final AvatarAction avatarAction;

  final bool showFollowButton;

  final String userId;

  final String userAvatar;

  final String username;

  final String signature;

  UserInfoHeader({
    @required this.avatarHeroTag,
    @required this.avatarAction,
    @required this.showFollowButton,
    @required this.userId,
    @required this.userAvatar,
    @required this.username,
    @required this.signature,
  });

  avatarOnTap(context) {
    switch (avatarAction) {
      case AvatarAction.toUserInfoPage:
        {
          NavigatorUtil.toUserInfoPage(context, userId: userId);
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
  }

  followButtonOnPressed(GlobalInfoProvider globalInfoProvider) async {
    ResponseBean responseBean = await ApiMethodUtil.followChange(
      targetUserId: userId,
    );
    FollowStatusBean followStatusBean =
        FollowStatusBean.fromJson(responseBean.data);
    if (followStatusBean.follow) {
      FollowUserInfo followUserInfo = FollowUserInfo();
      followUserInfo.userId = userId;
      followUserInfo.username = username;
      followUserInfo.userAvatar = userAvatar;
      globalInfoProvider.followUserMap[userId] = followUserInfo;
    } else {
      globalInfoProvider.followUserMap.remove(userId);
    }
    globalInfoProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return Container(
        child: Row(
          children: [
            // 头像
            GestureDetector(
              onTap: () => avatarOnTap(context),
              child: Container(
                width: ScreenUtil().setWidth(90),
                child: Hero(
                  tag: avatarHeroTag,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userAvatar,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ImageHolder(
                        size: ScreenUtil().setSp(40),
                      ),
                      errorWidget: (context, url, error) => ImageErrorWidget(
                        size: ScreenUtil().setSp(40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 用户名和用户签名
            Container(
              width: showFollowButton
                  ? ScreenUtil().setWidth(480)
                  : ScreenUtil().setWidth(590),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      username,
                      style: TextStyleTheme.h3,
                    ),
                  ),
                  Container(
                    child: Text(
                      signature,
                      maxLines: 1,
                      style: TextStyleTheme.subH5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            showFollowButton
                ? AnimatedFollowButton(
                    height: ScreenUtil().setHeight(45),
                    width: ScreenUtil().setWidth(110),
                    onPressed: () async {
                      await followButtonOnPressed(globalInfoProvider);
                    },
                    follow:
                        globalInfoProvider.followUserMap.containsKey(userId),
                  )
                : SizedBox(),
          ],
        ),
      );
    });
  }
}
