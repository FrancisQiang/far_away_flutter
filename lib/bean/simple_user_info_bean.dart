
class SimpleUserInfoList {

  List<dynamic> list;

  SimpleUserInfoList(
      {this.list});

  SimpleUserInfoList.fromJson(Map<String, dynamic> json) {
    list = json['list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list'] = this.list;
    return data;
  }

}


class SimpleUserInfo {
  String userId;
  String username;
  String avatar;

  SimpleUserInfo(
      {this.userId,
        this.username,
        this.avatar});

  SimpleUserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    return data;
  }
}
