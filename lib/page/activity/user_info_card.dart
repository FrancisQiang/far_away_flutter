import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/find_user_info_bean.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/animated_follow_button.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatelessWidget {
  final FindUserInfoBean findUserInfoBean;

  UserInfoCard({@required this.findUserInfoBean});

  followOnPressed(GlobalInfoProvider globalInfoProvider) async {
    ResponseBean responseBean = await ApiMethodUtil.followChange(
      targetUserId: findUserInfoBean.userId,
    );
    FollowStatusBean followStatusBean =
        FollowStatusBean.fromJson(responseBean.data);
    if (followStatusBean.follow) {
      FollowUserInfo followUserInfo = FollowUserInfo();
      followUserInfo.userId = findUserInfoBean.userId;
      followUserInfo.username = findUserInfoBean.username;
      followUserInfo.userAvatar = findUserInfoBean.userAvatar;
      globalInfoProvider.followUserMap[findUserInfoBean.userId] =
          followUserInfo;
    } else {
      globalInfoProvider.followUserMap.remove(findUserInfoBean.userId);
    }
    globalInfoProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              colorFilter:
                  ColorFilter.mode(Color(0x40000000), BlendMode.darken),
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                findUserInfoBean.cover,
              )),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setWidth(120),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(110))),
                border: Border.all(
                  width: 1.5,
                  style: BorderStyle.solid,
                  color: Colors.white,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: findUserInfoBean.userAvatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
              alignment: Alignment.center,
              child: Text(
                findUserInfoBean.username,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(5),
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
              ),
              alignment: Alignment.center,
              child: Text(
                findUserInfoBean.signature,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
            Consumer<GlobalInfoProvider>(
                builder: (context, globalInfoProvider, child) {
              return Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                ),
                alignment: Alignment.center,
                child: AnimatedFollowButton(
                  width: ScreenUtil().setWidth(180),
                  height: ScreenUtil().setHeight(45),
                  onPressed: () async {
                    await followOnPressed(globalInfoProvider);
                  },
                  follow: globalInfoProvider.followUserMap
                      .containsKey(findUserInfoBean.userId),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
