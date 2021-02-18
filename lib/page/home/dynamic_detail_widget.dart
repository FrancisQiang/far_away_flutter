import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';

class DynamicDetailWidget extends StatefulWidget {

  final String avatarHeroTag;

  final DynamicDetailBean dynamicDetailBean;

  DynamicDetailWidget({@required this.avatarHeroTag, @required this.dynamicDetailBean});

  @override
  _DynamicDetailWidgetState createState() => _DynamicDetailWidgetState();

}

class _DynamicDetailWidgetState extends State<DynamicDetailWidget> {
  @override
  void initState() {
    super.initState();
  }

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
                      tag: widget.avatarHeroTag,
                      child: ClipOval(
                        child: CachedNetworkImage(
                            imageUrl: widget.dynamicDetailBean.userAvatar,
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
                  margin:
                  EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  widget.dynamicDetailBean.username,
                                  style: TextStyleTheme.h3,
                                ),
                              ),
                            ],
                          )),
                      Container(
                        child: Text(widget.dynamicDetailBean.signature,
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
              widget.dynamicDetailBean.content,
              textAlign: TextAlign.start,
              style: TextStyleTheme.body,
            ),
          ),
          widget.dynamicDetailBean.mediaList == null ||
              widget.dynamicDetailBean.mediaList.isEmpty
              ? SizedBox()
              : Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(15),
              ),
              width: ScreenUtil().setWidth(750),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: ScreenUtil().setWidth(8),
                  runSpacing: ScreenUtil().setHeight(10),
                  children: List.generate(
                      widget.dynamicDetailBean.mediaList.length, (mediaIndex) {
                    return Container(
                      width: ScreenUtil().setWidth(
                          CalculateUtil.calculateWrapElementWidth(
                              widget.dynamicDetailBean.mediaList.length)),
                      height: ScreenUtil().setWidth(
                          CalculateUtil.calculateWrapElementWidth(
                              widget.dynamicDetailBean.mediaList.length)),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0)),
                        child: CachedNetworkImage(
                          imageUrl: widget.dynamicDetailBean
                              .mediaList[mediaIndex].url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: ScreenUtil().setWidth(
                                CalculateUtil
                                    .calculateWrapElementWidth(
                                    widget.dynamicDetailBean
                                        .mediaList.length)),
                            height: ScreenUtil().setWidth(
                                CalculateUtil
                                    .calculateWrapElementWidth(
                                    widget.dynamicDetailBean
                                        .mediaList.length)),
                            alignment: Alignment.center,
                            child: SpinKitPumpingHeart(
                              color: Theme.of(context).primaryColor,
                              size: ScreenUtil().setSp(40),
                              duration:
                              Duration(milliseconds: 2000),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          new Icon(
                            Icons.error,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    );
                  }))),
          TimeLocationBar(
            width: ScreenUtil().setWidth(750),
            time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(widget.dynamicDetailBean.publishTime)),
            location: widget.dynamicDetailBean.location,
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
                  child: LikeButton(
                    size: ScreenUtil().setSp(40),
                    onTap: (bool isLiked) async {
                      await ApiMethodUtil.dynamicThumbChange(
                          token: ProviderUtil.globalInfoProvider.jwt,
                          thumb: !isLiked,
                          dynamicId: widget.dynamicDetailBean.id);
                      if(!isLiked) {
                        widget.dynamicDetailBean.thumbCount++;
                        widget.dynamicDetailBean.thumbed = true;
                      } else {
                        widget.dynamicDetailBean.thumbCount--;
                        widget.dynamicDetailBean.thumbed = false;
                      }
                      return !isLiked;
                    },
                    isLiked: widget.dynamicDetailBean.thumbed,
                    circleColor: CircleColor(
                        start: Colors.orangeAccent, end: Colors.orange),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Colors.orangeAccent,
                      dotSecondaryColor: Colors.orange,
                    ),
                    likeCountAnimationType: widget.dynamicDetailBean.thumbCount < 1000
                        ? LikeCountAnimationType.part
                        : LikeCountAnimationType.none,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.redAccent : Colors.black,
                        size: ScreenUtil().setSp(42),
                      );
                    },
                    likeCount: widget.dynamicDetailBean.thumbCount,
                    likeCountPadding: EdgeInsets.only(
                        left: 8
                    ),
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
                          '  ${CalculateUtil.simplifyCount(widget.dynamicDetailBean.commentsCount)}',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              letterSpacing: 0.2),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    size: ScreenUtil().setSp(30),
                    color: widget.dynamicDetailBean.collected
                        ? Colors.deepOrangeAccent
                        : Colors.black,
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
