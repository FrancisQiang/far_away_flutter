class UserIdListBean {

  List<String> userIdList;

  UserIdListBean({this.userIdList});

  UserIdListBean.fromJson(Map<String, dynamic> json) {
    userIdList = json['userIdList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userIdList'] = this.userIdList;
    return data;
  }
}
