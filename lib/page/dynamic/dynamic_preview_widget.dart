import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/link_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/component/user_info_header.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/param/dynamic_detail_param.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:like_button/like_button.dart';

class DynamicPreviewWidget extends StatelessWidget {
  /// 点击头像的动作
  final AvatarAction avatarAction;

  final DynamicDetailBean dynamicDetailBean;

  final bool showFollowButton;

  final String avatarHeroTag;

  DynamicPreviewWidget({
    @required this.dynamicDetailBean,
    @required this.avatarAction,
    @required this.showFollowButton,
    @required this.avatarHeroTag,
  });

  Widget _buildMediaWrap() {
    if (dynamicDetailBean.type == 1 || dynamicDetailBean.mediaList.isEmpty) {
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(10),
      ),
      child: MediaPreview(
        mediaList: dynamicDetailBean.mediaList,
      ),
    );
  }

  Widget _buildLink() {
    if (dynamicDetailBean.type == 0) {
      return SizedBox();
    }
    return Container(
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(22),
        vertical: 5,
      ),
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoHeader(
            userId: dynamicDetailBean.userId,
            userAvatar: dynamicDetailBean.userAvatar,
            username: dynamicDetailBean.username,
            signature: dynamicDetailBean.signature,
            showFollowButton: showFollowButton,
            avatarAction: avatarAction,
            avatarHeroTag: avatarHeroTag,
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
                    likeCountAnimationType: dynamicDetailBean.thumbCount < 1000
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
  }
}
