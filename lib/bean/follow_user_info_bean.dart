class FollowListVO {
  List<FollowUserInfo> list;

  FollowListVO({this.list});

  FollowListVO.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<FollowUserInfo>();
      json['list'].forEach((v) {
        list.add(new FollowUserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowUserInfo {
  String userId;
  String username;
  String userAvatar;

  FollowUserInfo({this.userId, this.username, this.userAvatar});

  FollowUserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    userAvatar = json['userAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['userAvatar'] = this.userAvatar;
    return data;
  }
}