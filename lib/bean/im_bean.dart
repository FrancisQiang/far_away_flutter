class ConversationWrapper {
  ConversationWrapper(
      {this.content,
      this.username,
      this.userId,
      this.avatar,
      this.sendTime,
      this.unReadMessageCount});

  String content;

  String userId;

  String username;

  String avatar;

  int sendTime;

  int unReadMessageCount;
}

class PrivateMessageWrapper {
  int msgId;

  bool read;

  String userId;

  // 消息内容
  String content;

  String extraInfo;

  // 消息类型 默认0 文字
  int type;
}

class MessageContentJson {
  String content;
  int type;
  String extraInfo;

  MessageContentJson({this.content, this.type, this.extraInfo});

  MessageContentJson.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    type = json['type'];
    extraInfo = json['extraInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['type'] = this.type;
    data['extraInfo'] = this.extraInfo;
    return data;
  }
}

class TogetherMessageJson {
  String username;
  String title;
  String togetherInfo;
  String avatar;
  String togetherId;

  TogetherMessageJson({this.username, this.title, this.togetherInfo, this.avatar, this.togetherId});

  TogetherMessageJson.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    title = json['title'];
    togetherInfo = json['togetherInfo'];
    avatar = json['avatar'];
    togetherId = json['togetherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['title'] = this.title;
    data['togetherInfo'] = this.togetherInfo;
    data['avatar'] = this.avatar;
    data['togetherId'] = this.togetherId;
    return data;
  }
}

class RecruitMessageJson {

  String title;
  String cover;
  String avatar;
  String recruitId;
  // 我是来自xxx的xxx，想要报名这次义工
  String content;

  RecruitMessageJson({this.title, this.cover, this.avatar, this.recruitId, this.content});

  RecruitMessageJson.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    title = json['title'];
    recruitId = json['recruitId'];
    avatar = json['avatar'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['title'] = this.title;
    data['avatar'] = this.avatar;
    data['recruitId'] = this.recruitId;
    data['content'] = this.content;
    return data;
  }
}

class MessageType {

  static const int DEFAULT = 0;

  static const int TOGETHER = 1;

  static const int RECRUIT_SIGN_UP = 2;

}
