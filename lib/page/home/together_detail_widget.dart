import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TogetherDetailWidget extends StatelessWidget {
  final String avatarHeroTag;

  final TogetherInfoBean togetherInfoBean;

  TogetherDetailWidget(
      {@required this.avatarHeroTag, @required this.togetherInfoBean});

  @override
  Widget build(BuildContext context) {
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
                            imageUrl: togetherInfoBean.userAvatar,
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
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20),
            ),
            child: Text(
              togetherInfoBean.content,
              textAlign: TextAlign.start,
              style: TextStyleTheme.body,
            ),
          ),
          TimeLocationBar(
            width: ScreenUtil().setWidth(750),
            time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(
                togetherInfoBean.publishTime)),
            location: togetherInfoBean.location,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
            ),
            padding: EdgeInsets.symmetric(
                // horizontal: ScreenUtil().setWidth(20)
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Icon(
                          FontAwesomeIcons.commentDots,
                          size: ScreenUtil().setSp(32),
                        ),
                      ),
                      Container(
                        child: Text(
                          '100',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              letterSpacing: 0.2),
                        ),
                      )
                    ],
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
