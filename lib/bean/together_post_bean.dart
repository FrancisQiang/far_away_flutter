class TogetherPostBean {
  String content;
  String location;
  double longitude;
  double latitude;

  TogetherPostBean(
      {this.content,
        this.location,
        this.longitude,
        this.latitude});

  TogetherPostBean.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}