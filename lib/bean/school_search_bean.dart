class SchoolSearchBean {

  String name;
  String schoolType;
  String address;

  SchoolSearchBean({this.name, this.schoolType, this.address});

  SchoolSearchBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    schoolType = json['school_type'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['school_type'] = this.schoolType;
    data['address'] = this.address;
    return data;
  }
}