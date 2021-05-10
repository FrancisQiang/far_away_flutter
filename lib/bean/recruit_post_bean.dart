
class RecruitPostBean {
  String title;
  String content;
  String location;
  String cover;

  RecruitPostBean({this.title, this.content, this.location, this.cover});

  RecruitPostBean.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    location = json['location'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['location'] = this.location;
    data['cover'] = this.cover;
    return data;
  }
}