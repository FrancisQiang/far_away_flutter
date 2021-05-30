import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImProvider>(builder: (context, imProvider, child) {
      if (imProvider.needRefreshConversations) {
        imProvider.refreshConversationList();
      }
      return Container(
          child: ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MessageTile(
                    conversationWrapper: imProvider.conversations[index]);
              },
              itemCount: imProvider.conversations.length,
            ),
          ));
    });
  }
}

class MessageTile extends StatelessWidget {
  final ConversationWrapper conversationWrapper;

  MessageTile({@required this.conversationWrapper});

  String parseContent() {
    MessageContentJson messageContentJson = MessageContentJson.fromJson(
        convert.jsonDecode(conversationWrapper.content));
    String content;
    if (messageContentJson.type == MessageType.DEFAULT) {
      content = messageContentJson.content;
    } else if (messageContentJson.type == MessageType.RECRUIT_SIGN_UP) {
      RecruitMessageJson recruitMessageJson = RecruitMessageJson.fromJson(
          convert.jsonDecode(messageContentJson.extraInfo));
      content = recruitMessageJson.content;
    } else {
      TogetherMessageJson togetherJson = TogetherMessageJson.fromJson(
          convert.jsonDecode(messageContentJson.extraInfo));
      content = togetherJson.username + "，我想与你结伴同行";
    }
    return content;
  }


  deleteMessageTile(ImProvider imProvider) {
    RongIMClient.removeConversation(
        RCConversationType.Private, conversationWrapper.userId, (success) {
      if (success) {
        for (int i = 0; i < imProvider.conversations.length; i++) {
          if (imProvider.conversations[i].userId ==
              conversationWrapper.userId) {
            imProvider.conversations.removeAt(i);
            break;
          }
        }
        imProvider.messages.remove(conversationWrapper.userId);
        imProvider.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImProvider>(builder: (context, imProvider, child) {
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete_outline,
            onTap: () => deleteMessageTile(imProvider),
          ),
        ],
        child: FlatButton(
          color: Colors.white,
          highlightColor: Theme
              .of(context)
              .backgroundColor,
          splashColor: Theme
              .of(context)
              .backgroundColor,
          padding: EdgeInsets.zero,
          onPressed: () {
            NavigatorUtil.toPrivateChatPage(context,
                param: PrivateChatParam(
                    username: conversationWrapper.username,
                    userId: conversationWrapper.userId,
                    avatar: conversationWrapper.avatar));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setHeight(25),
            ),
            decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.1))),
            child: Row(children: [
              Container(
                child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: conversationWrapper.avatar,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setWidth(100),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                height: ScreenUtil().setWidth(100),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(500),
                            child: Text(
                              conversationWrapper.username,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                            child: Text(
                              '${DateUtil.getSimpleDate(
                                  conversationWrapper.sendTime)}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(26),
                                  color: Colors.black38),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(480),
                            child: Text(
                              parseContent(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Colors.black38),
                            ),
                          ),
                          conversationWrapper.unReadMessageCount == 0
                              ? Container()
                              : Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15)),
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(70),
                              height: ScreenUtil().setHeight(35),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                '${conversationWrapper.unReadMessageCount > 99
                                    ? "99+"
                                    : conversationWrapper.unReadMessageCount}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}


