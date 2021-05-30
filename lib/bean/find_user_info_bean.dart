

class FindUserInfoBean {
  String userId;
  String username;
  String userAvatar;
  String signature;
  String cover;

  FindUserInfoBean({this.userId, this.username, this.userAvatar, this.signature, this.cover});

  FindUserInfoBean.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    userAvatar = json['userAvatar'];
    signature = json['signature'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['userAvatar'] = this.userAvatar;
    data['signature'] = this.signature;
    data['cover'] = this.cover;
    return data;
  }
}