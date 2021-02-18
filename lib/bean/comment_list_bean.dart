class CommentListBean {
  String id;
  String parentId;
  String fromUserId;
  String fromUsername;
  String fromUserAvatar;
  String fromUserSignature;
  String toUserId;
  String toUsername;
  int thumbCount;
  String content;
  int publishTime;
  String pictureUrlList;
  int childrenListSize;
  List<CommentListBean> children;

  CommentListBean(
      {this.id,
        this.parentId,
        this.fromUserId,
        this.fromUsername,
        this.fromUserAvatar,
        this.fromUserSignature,
        this.toUserId,
        this.toUsername,
        this.thumbCount,
        this.content,
        this.publishTime,
        this.pictureUrlList,
        this.childrenListSize,
        this.children});

  CommentListBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    fromUserId = json['fromUserId'];
    fromUsername = json['fromUsername'];
    fromUserAvatar = json['fromUserAvatar'];
    fromUserSignature = json['fromUserSignature'];
    toUserId = json['toUserId'];
    toUsername = json['toUsername'];
    thumbCount = json['thumbCount'];
    content = json['content'];
    publishTime = json['publishTime'];
    pictureUrlList = json['pictureUrlList'];
    childrenListSize = json['childrenListSize'];
    if (json['children'] != null) {
      children = new List<CommentListBean>();
      json['children'].forEach((v) {
        children.add(new CommentListBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['fromUserId'] = this.fromUserId;
    data['fromUsername'] = this.fromUsername;
    data['fromUserAvatar'] = this.fromUserAvatar;
    data['fromUserSignature'] = this.fromUserSignature;
    data['toUserId'] = this.toUserId;
    data['toUsername'] = this.toUsername;
    data['thumbCount'] = this.thumbCount;
    data['content'] = this.content;
    data['publishTime'] = this.publishTime;
    data['pictureUrlList'] = this.pictureUrlList;
    data['childrenListSize'] = this.childrenListSize;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}