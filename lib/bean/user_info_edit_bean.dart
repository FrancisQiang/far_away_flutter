class UserInfoEditBean {
  String id;
  String userName;
  String location;
  String school;
  String major;
  String industry;
  int emotionState;
  int birthday;
  String constellation;
  String signature;
  String avatar;
  String cover;
  int gender;

  UserInfoEditBean(
      {this.id,
        this.userName,
        this.location,
        this.school,
        this.major,
        this.industry,
        this.emotionState,
        this.birthday,
        this.constellation,
        this.signature,
        this.avatar,
        this.cover,
        this.gender});

  UserInfoEditBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    location = json['location'];
    school = json['school'];
    major = json['major'];
    industry = json['industry'];
    emotionState = json['emotionState'];
    birthday = json['birthday'];
    constellation = json['constellation'];
    signature = json['signature'];
    avatar = json['avatar'];
    cover = json['cover'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['location'] = this.location;
    data['school'] = this.school;
    data['major'] = this.major;
    data['industry'] = this.industry;
    data['emotionState'] = this.emotionState;
    data['birthday'] = this.birthday;
    data['constellation'] = this.constellation;
    data['signature'] = this.signature;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['gender'] = this.gender;
    return data;
  }
}
