class UserInfoBean {
  String id;
  String mobile;
  String userName;
  String location;
  String school;
  String major;
  int enrollmentYear;
  String industry;
  int emotionState;
  int birthday;
  String constellation;
  String signature;
  String avatar;
  String cover;
  String IMToken;
  int thumbCount;
  int followCount;
  int fansCount;
  int gender;
  int gmtCreate;

  UserInfoBean(
      {this.id,
        this.mobile,
        this.userName,
        this.location,
        this.school,
        this.major,
        this.enrollmentYear,
        this.industry,
        this.emotionState,
        this.birthday,
        this.constellation,
        this.signature,
        this.avatar,
        this.cover,
        this.thumbCount,
        this.followCount,
        this.fansCount,
        this.gender,
        this.IMToken,
        this.gmtCreate});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    userName = json['userName'];
    location = json['location'];
    school = json['school'];
    major = json['major'];
    enrollmentYear = json['enrollmentYear'];
    industry = json['industry'];
    emotionState = json['emotionState'];
    birthday = json['birthday'];
    constellation = json['constellation'];
    signature = json['signature'];
    avatar = json['avatar'];
    cover = json['cover'];
    thumbCount = json['thumbCount'];
    followCount = json['followCount'];
    fansCount = json['fansCount'];
    gender = json['gender'];
    gmtCreate = json['gmtCreate'];
    IMToken = json['imtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['userName'] = this.userName;
    data['location'] = this.location;
    data['school'] = this.school;
    data['major'] = this.major;
    data['enrollmentYear'] = this.enrollmentYear;
    data['industry'] = this.industry;
    data['emotionState'] = this.emotionState;
    data['birthday'] = this.birthday;
    data['constellation'] = this.constellation;
    data['signature'] = this.signature;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['thumbCount'] = this.thumbCount;
    data['followCount'] = this.followCount;
    data['fansCount'] = this.fansCount;
    data['gender'] = this.gender;
    data['gmtCreate'] = this.gmtCreate;
    data['IMToken'] = this.IMToken;
    return data;
  }
}
