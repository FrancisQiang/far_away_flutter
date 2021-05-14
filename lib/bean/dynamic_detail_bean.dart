class DynamicDetailBean {
  String id;
  String userId;
  int type;
  String link;
  String linkImage;
  String linkTitle;
  String username;
  String userAvatar;
  String signature;
  String content;
  List<MediaList> mediaList;
  bool thumbed;
  int thumbCount;
  int commentsCount;
  bool collected;
  String location;
  double longitude;
  double latitude;
  int publishTime;
  bool follow;

  DynamicDetailBean({
    this.id,
    this.userId,
    this.type,
    this.link,
    this.linkTitle,
    this.linkImage,
    this.username,
    this.userAvatar,
    this.signature,
    this.content,
    this.mediaList,
    this.thumbed,
    this.thumbCount,
    this.commentsCount,
    this.collected,
    this.location,
    this.longitude,
    this.latitude,
    this.publishTime,
    this.follow,
  });

  DynamicDetailBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    link = json['link'];
    linkTitle = json['linkTitle'];
    linkImage = json['linkImage'];
    username = json['username'];
    userAvatar = json['userAvatar'];
    signature = json['signature'];
    content = json['content'];
    if (json['mediaList'] != null) {
      mediaList = new List<MediaList>();
      json['mediaList'].forEach((v) {
        mediaList.add(new MediaList.fromJson(v));
      });
    }
    thumbed = json['thumbed'];
    thumbCount = json['thumbCount'];
    commentsCount = json['commentsCount'];
    collected = json['collected'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    publishTime = json['publishTime'];
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['link'] = this.link;
    data['linkImage'] = this.linkImage;
    data['linkTitle'] = this.linkTitle;
    data['username'] = this.username;
    data['userAvatar'] = this.userAvatar;
    data['signature'] = this.signature;
    data['content'] = this.content;
    if (this.mediaList != null) {
      data['mediaList'] = this.mediaList.map((v) => v.toJson()).toList();
    }
    data['thumbed'] = this.thumbed;
    data['thumbCount'] = this.thumbCount;
    data['commentsCount'] = this.commentsCount;
    data['collected'] = this.collected;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['publishTime'] = this.publishTime;
    data['follow'] = this.follow;
    return data;
  }
}

class MediaList {
  int type;
  String url;

  MediaList({this.type, this.url});

  MediaList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
