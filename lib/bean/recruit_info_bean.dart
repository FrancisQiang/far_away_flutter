class RecruitDetailInfoBean {
  String id;
  String username;
  String userId;
  String signature;
  String userAvatar;
  String title;
  String content;
  String cover;
  String location;
  bool thumbed;
  int thumbCount;
  bool signUp;
  int signUpCount;
  int publishTime;
  int commentsCount;

  RecruitDetailInfoBean(
      {this.id,
        this.username,
        this.userId,
        this.signature,
        this.userAvatar,
        this.title,
        this.content,
        this.cover,
        this.location,
        this.thumbed,
        this.thumbCount,
        this.signUp,
        this.signUpCount,
        this.publishTime,
        this.commentsCount});

  RecruitDetailInfoBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    userId = json['userId'];
    signature = json['signature'];
    userAvatar = json['userAvatar'];
    title = json['title'];
    content = json['content'];
    cover = json['cover'];
    location = json['location'];
    thumbed = json['thumbed'];
    thumbCount = json['thumbCount'];
    signUp = json['signUp'];
    signUpCount = json['signUpCount'];
    publishTime = json['publishTime'];
    commentsCount = json['commentsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['userId'] = this.userId;
    data['signature'] = this.signature;
    data['userAvatar'] = this.userAvatar;
    data['title'] = this.title;
    data['content'] = this.content;
    data['cover'] = this.cover;
    data['location'] = this.location;
    data['thumbed'] = this.thumbed;
    data['thumbCount'] = this.thumbCount;
    data['signUp'] = this.signUp;
    data['signUpCount'] = this.signUpCount;
    data['publishTime'] = this.publishTime;
    data['commentsCount'] = this.commentsCount;
    return data;
  }
}