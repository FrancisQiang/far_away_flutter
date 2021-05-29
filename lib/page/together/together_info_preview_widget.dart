import 'dart:convert' as convert;

import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/time_location_bar.dart';
import 'package:far_away_flutter/component/user_info_header.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/param/together_detail_param.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class TogetherInfoPreviewWidget extends StatelessWidget {
  /// 点击头像的动作
  final AvatarAction avatarAction;

  final TogetherInfoBean togetherInfoBean;

  final bool showFollowButton;

  final String avatarHeroTag;

  TogetherInfoPreviewWidget({
    @required this.togetherInfoBean,
    @required this.showFollowButton,
    @required this.avatarAction,
    @required this.avatarHeroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
      builder: (context, globalInfoProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(22), vertical: 8),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoHeader(
                avatarHeroTag: avatarHeroTag,
                avatarAction: avatarAction,
                showFollowButton: showFollowButton,
                userId: togetherInfoBean.userId,
                userAvatar: togetherInfoBean.userAvatar,
                username: togetherInfoBean.username,
                signature: togetherInfoBean.signature,
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
                time: DateUtil.getTimeString(
                    DateTime.fromMillisecondsSinceEpoch(
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
                          NavigatorUtil.toTogetherDetailPage(
                            context,
                            param: TogetherDetailParam(
                                scrollToComment: true,
                                togetherInfoBean: togetherInfoBean),
                          );
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
                          if (ProviderUtil.globalInfoProvider.userInfoBean.id ==
                              togetherInfoBean.userId) {
                            ToastUtil.showNoticeToast("您是发布者，不能报名哦！");
                            return;
                          }
                          ResponseBean responseBean =
                              await ApiMethodUtil.togetherSignUp(
                                  id: togetherInfoBean.id);
                          if (responseBean.isSuccess()) {
                            // 发送结伴消息
                            TextMessage textMessage = TextMessage();
                            MessageContentJson json = MessageContentJson(
                                content: "",
                                type: MessageType.TOGETHER,
                                extraInfo: convert.jsonEncode(
                                    TogetherMessageJson(
                                        togetherId: togetherInfoBean.id,
                                        username: togetherInfoBean.username,
                                        togetherInfo: togetherInfoBean.content,
                                        avatar: togetherInfoBean.userAvatar,
                                        title: "我想和你结伴同行")));
                            textMessage.content = convert.jsonEncode(json);
                            Message msg = await RongIMClient.sendMessage(
                                RCConversationType.Private,
                                togetherInfoBean.userId,
                                textMessage);
                            PrivateMessageWrapper messageWrapper =
                                PrivateMessageWrapper();
                            messageWrapper.msgId = msg.messageId;
                            messageWrapper.content = convert.jsonEncode(json);
                            messageWrapper.type = MessageType.TOGETHER;
                            messageWrapper.userId =
                                ProviderUtil.globalInfoProvider.userInfoBean.id;
                            messageWrapper.read = true;
                            if (ProviderUtil.imProvider
                                    .messages[togetherInfoBean.userId] ==
                                null) {
                              ProviderUtil.imProvider
                                  .messages[togetherInfoBean.userId] = [];
                            }
                            ProviderUtil
                                .imProvider.messages[togetherInfoBean.userId]
                                .insert(0, messageWrapper);
                            NavigatorUtil.toPrivateChatPage(context,
                                param: PrivateChatParam(
                                    username: togetherInfoBean.username,
                                    userId: togetherInfoBean.userId,
                                    avatar: togetherInfoBean.userAvatar));
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
                                '${togetherInfoBean.signUpCount}',
                                style: TextStyle(
                                    color: togetherInfoBean.signUp
                                        ? Color.fromRGBO(255, 122, 0, 1)
                                        : Colors.black),
                              ),
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
