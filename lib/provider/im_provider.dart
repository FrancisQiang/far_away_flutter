import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/simple_user_info_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class ImProvider with ChangeNotifier{

  ImProvider() {
    //消息接收回调
    RongIMClient.onMessageReceived = (Message msg,int left) async {
      await refreshConversationList();
      PrivateMessageWrapper messageWrapper = PrivateMessageWrapper();
      TextMessage textMessage = msg.content as TextMessage;
      messageWrapper.content = textMessage.content;
      messageWrapper.type = 0;
      messageWrapper.userId = msg.senderUserId;
      List<PrivateMessageWrapper> msgList = messages[msg.senderUserId];
      if (msgList == null) {
        msgList = [];
        msgList.add(messageWrapper);
      } else {
        msgList.insert(0, messageWrapper);
      }
      print('msg::' + messageWrapper.content);
      messages[msg.senderUserId] = msgList;
      notifyListeners();
    };
  }

  List<ConversationWrapper> conversations = [];

  Map<String, List<PrivateMessageWrapper>> messages = {};

  refreshConversationList() async {
    conversations = [];
    List conversationList = await RongIMClient.getConversationList([RCConversationType.Private,RCConversationType.Group,RCConversationType.System]);
    if (conversationList == null) {
      return;
    }
    List<String> idList = [];
    for(Conversation conversation in conversationList) {
      idList.add(conversation.targetId);
      TextMessage message = conversation.latestMessageContent as TextMessage;
      ConversationWrapper conversationWrapper = ConversationWrapper(
        content: message.content,
        unReadMessageCount: conversation.unreadMessageCount,
        sendTime: conversation.sentTime,
      );
      conversations.add(conversationWrapper);
    }
    Response<dynamic> response = await ApiMethodUtil.getSimpleUserInfoList(userIds: idList);
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    SimpleUserInfoList userList = SimpleUserInfoList.fromJson(responseBean.data);
    for (int i = 0; i < conversations.length; i++) {
      SimpleUserInfo simpleUserInfo = SimpleUserInfo.fromJson(userList.list[i]);
      ConversationWrapper conversationWrapper = conversations[i];
      conversationWrapper.username = simpleUserInfo.username;
      conversationWrapper.avatar = simpleUserInfo.avatar;
      conversationWrapper.userId = simpleUserInfo.userId;
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

}