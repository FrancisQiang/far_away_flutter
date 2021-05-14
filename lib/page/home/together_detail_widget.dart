import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

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
                  width: ScreenUtil().setWidth(470),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          togetherInfoBean.username,
                          style: TextStyleTheme.h3,
                        ),
                      ),
                      Container(
                        child: Text(togetherInfoBean.signature,
                            style: TextStyleTheme.subH5),
                      )
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().setWidth(110),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: () {},
                    color: Colors.orangeAccent,
                    child: Text(
                      '关 注',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
            height: ScreenUtil().setHeight(50),
            margin: EdgeInsets.only(top: 8),
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
                          child: Text("分享"),
                        )
                      ],
                    )),
                FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/png/comment.png',
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(40),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                              '${togetherInfoBean.commentsCount}'
                          ),
                        )
                      ],
                    )),
                FlatButton(
                    onPressed: () async {
                      // TODO 跳转到私聊界面
                      Response<dynamic> response = await ApiMethodUtil.togetherSignUp(
                          token: ProviderUtil.globalInfoProvider.jwt,
                          id: togetherInfoBean.id);
                      if (ResponseBean.fromJson(response.data).isSuccess()) {
                        togetherInfoBean.signUp = true;
                      } else {
                        ToastUtil.showErrorToast("网络异常，请稍后再试");
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        togetherInfoBean.signUp
                            ? Image.asset(
                          'assets/png/handed.png',
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(40),
                        )
                            : Image.asset(
                          'assets/png/hands.png',
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(40),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text('${togetherInfoBean.signUpCount}', style: TextStyle(
                              color: togetherInfoBean.signUpCount > 0 ? Color.fromRGBO(255, 122, 0, 1) : Colors.black
                          ),),
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
