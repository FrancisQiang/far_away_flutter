
class TogetherInfoBean {
  String id;
  String userId;
  String username;
  String userAvatar;
  String signature;
  String content;
  String location;
  double longitude;
  double latitude;
  int status;
  bool signUp;
  int commentsCount;
  int signUpCount;
  int publishTime;

  TogetherInfoBean(
      {this.id,
        this.userId,
        this.username,
        this.userAvatar,
        this.signature,
        this.content,
        this.location,
        this.longitude,
        this.latitude,
        this.status,
        this.signUp,
        this.commentsCount,
        this.signUpCount,
        this.publishTime});

  TogetherInfoBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    username = json['username'];
    userAvatar = json['userAvatar'];
    signature = json['signature'];
    content = json['content'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    signUp = json['signUp'];
    commentsCount = json['commentsCount'];
    signUpCount = json['signUpCount'];
    publishTime = json['publishTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['userAvatar'] = this.userAvatar;
    data['signature'] = this.signature;
    data['content'] = this.content;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    data['signUp'] = this.signUp;
    data['commentsCount'] = this.commentsCount;
    data['signUpCount'] = this.signUpCount;
    data['publishTime'] = this.publishTime;
    return data;
  }
}