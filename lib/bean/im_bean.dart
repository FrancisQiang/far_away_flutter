

class ConversationWrapper {
  ConversationWrapper({this.content, this.username, this.userId, this.avatar, this.sendTime, this.unReadMessageCount});

  String content;

  String userId;

  String username;

  String avatar;

  int sendTime;

  int unReadMessageCount;
}

class PrivateMessageWrapper {
  String userId;

  // 消息内容
  String content;

  // 消息类型 默认0 文字
  int type;
}