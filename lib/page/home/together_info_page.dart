import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/follow_status.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/animated_follow_button.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/component/init_refresh_widget.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

import 'dynamic_empty_widget.dart';

class TogetherInfoPage extends StatefulWidget {
  @override
  _TogetherInfoPageState createState() => _TogetherInfoPageState();
}

class _TogetherInfoPageState extends State<TogetherInfoPage>
    with AutomaticKeepAliveClientMixin {
  int timestamp;

  @override
  bool get wantKeepAlive => true;

  List<TogetherInfoBean> togetherList = [];

  int currentPage = 1;

  _loadTogetherData(String jwt) async {
    Response<dynamic> data;
    ResponseBean response;
    PageBean pageBean;
    try {
      data = await ApiMethodUtil.getTogetherInfoList(
          timestamp: timestamp, currentPage: currentPage, token: jwt);
      response = ResponseBean.fromJson(data.data);
      pageBean = PageBean.fromJson(response.data);
      print(response.data);
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
        TogetherInfoBean bean = TogetherInfoBean.fromJson(pageBean.list[i]);
        togetherList.add(bean);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
          return EasyRefresh(
              header: EasyRefreshWidget.refreshHeader,
              footer: EasyRefreshWidget.refreshFooter,
              firstRefresh: true,
              firstRefreshWidget: InitRefreshWidget(
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              emptyWidget: togetherList.length == 0
                  ? ListEmptyWidget(
                width: ScreenUtil().setWidth(380),
                height: ScreenUtil().setHeight(300),
              )
                  : null,
              onRefresh: () async {
                togetherList = [];
                currentPage = 1;
                timestamp = DateTime
                    .now()
                    .millisecondsSinceEpoch;
                await _loadTogetherData(globalInfoProvider.jwt);
              },
              onLoad: () async {
                await _loadTogetherData(globalInfoProvider.jwt);
              },
              child: Column(
                  children: List.generate(togetherList.length, (index) {
                    return GestureDetector(
                        onTap: () =>
                            NavigatorUtil.toTogetherDetailPage(context,
                                param: TogetherDetailParam(
                                    avatarHeroTag: 'together_${togetherList[index]
                                        .id}',
                                    togetherInfoBean: togetherList[index])),
                        child: TogetherInfoPreviewCard(
                            togetherInfoBean: togetherList[index]));
                  })));
        });
  }
}

class TogetherInfoPreviewCard extends StatelessWidget {
  final TogetherInfoBean togetherInfoBean;

  TogetherInfoPreviewCard({@required this.togetherInfoBean});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
      builder: (context, globalInfoProvider, child) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
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
                          tag: "together_${togetherInfoBean.id}",
                          child: ClipOval(
                              child: CachedNetworkImage(
                                  imageUrl: togetherInfoBean.userAvatar,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      ImageHolder(
                                        size: ScreenUtil().setSp(40),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      ImageErrorWidget(
                                        size: ScreenUtil().setSp(40),
                                      ))),
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
                    AnimatedFollowButton(
                      height: ScreenUtil().setHeight(40),
                      width: ScreenUtil().setWidth(110),
                      onPressed: () async {
                        Response<dynamic> response =
                        await ApiMethodUtil.followChange(
                          token: ProviderUtil.globalInfoProvider.jwt,
                          targetUserId: togetherInfoBean.userId,
                        );
                        ResponseBean responseBean =
                        ResponseBean.fromJson(response.data);
                        FollowStatusBean followStatusBean =
                        FollowStatusBean.fromJson(responseBean.data);
                        if(followStatusBean.follow) {
                          FollowUserInfo followUserInfo = FollowUserInfo();
                          followUserInfo.userId = togetherInfoBean.userId;
                          followUserInfo.username = togetherInfoBean.username;
                          followUserInfo.userAvatar = togetherInfoBean.userAvatar;
                          globalInfoProvider.followUserMap[togetherInfoBean.userId] = followUserInfo;
                        } else {
                          globalInfoProvider.followUserMap.remove(togetherInfoBean.userId);
                        }
                        globalInfoProvider.refresh();
                      },
                      follow: globalInfoProvider.followUserMap.containsKey(togetherInfoBean.userId),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setWidth(20),
                ),
                child: Text(togetherInfoBean.content,
                    maxLines: 50,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleTheme.body),
              ),
              TimeLocationBar(
                time: DateUtil.getTimeString(DateTime.fromMillisecondsSinceEpoch(
                    togetherInfoBean.publishTime)),
                location: togetherInfoBean.location,
                width: ScreenUtil().setWidth(750),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(18)),
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
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          NavigatorUtil.toTogetherDetailPage(context,
                              param: TogetherDetailParam(
                                  scrollToComment: true,
                                  togetherInfoBean: togetherInfoBean));
                        },
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
                              child: Text('${togetherInfoBean.commentsCount}'),
                            )
                          ],
                        )),
                    FlatButton(
                        onPressed: () async {
                          if (ProviderUtil.globalInfoProvider.userInfoBean.id == togetherInfoBean.userId) {
                            ToastUtil.showNoticeToast("您是发布者，不能报名哦！");
                            return;
                          }
                          Response<dynamic> response = await ApiMethodUtil
                              .togetherSignUp(
                              token: ProviderUtil.globalInfoProvider.jwt,
                              id: togetherInfoBean.id);
                          if (ResponseBean.fromJson(response.data).isSuccess()) {
                            // 发送结伴消息
                            TextMessage textMessage = TextMessage();
                            MessageContentJson json = MessageContentJson(
                                content: "",
                                type: MessageType.TOGETHER,
                                extraInfo: convert.jsonEncode(TogetherMessageJson(
                                    togetherId: togetherInfoBean.id,
                                    username: togetherInfoBean.username,
                                    togetherInfo: togetherInfoBean.content,
                                    avatar: togetherInfoBean.userAvatar,
                                    title: "我想和你结伴同行"
                                ))
                            );
                            textMessage.content = convert.jsonEncode(json);
                            Message msg = await RongIMClient.sendMessage(
                                RCConversationType.Private,
                                togetherInfoBean.userId,
                                textMessage);
                            PrivateMessageWrapper messageWrapper = PrivateMessageWrapper();
                            messageWrapper.msgId = msg.messageId;
                            messageWrapper.content = convert.jsonEncode(json);
                            messageWrapper.type = MessageType.TOGETHER;
                            messageWrapper.userId =
                                ProviderUtil.globalInfoProvider.userInfoBean.id;
                            messageWrapper.read = true;
                            if (ProviderUtil.imProvider.messages[togetherInfoBean.userId] == null) {
                              ProviderUtil.imProvider.messages[togetherInfoBean.userId] = [];
                            }
                            ProviderUtil.imProvider.messages[togetherInfoBean.userId].insert(0, messageWrapper);
                            NavigatorUtil.toPrivateChatPage(
                                context,
                                param: PrivateChatParam(
                                    username: togetherInfoBean.username,
                                    userId: togetherInfoBean.userId,
                                    avatar: togetherInfoBean.userAvatar)
                            );
                            if (!togetherInfoBean.signUp) {
                              togetherInfoBean.signUp = true;
                              togetherInfoBean.signUpCount++;
                            }
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
                              child: Text(
                                '${togetherInfoBean.signUpCount}', style: TextStyle(
                                  color: togetherInfoBean.signUp ? Color
                                      .fromRGBO(255, 122, 0, 1) : Colors.black
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
      },
    );
  }
}
