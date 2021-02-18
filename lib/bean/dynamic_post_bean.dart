class DynamicPostBean {
  String content;
  int type;
  String link;
  String linkImage;
  String linkTitle;
  List<MediaList> mediaList;
  String location;
  double longitude;
  double latitude;

  DynamicPostBean(
      {this.content,
        this.mediaList,
        this.location,
        this.longitude,
        this.latitude});

  DynamicPostBean.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    type = json['type'];
    link = json['link'];
    linkImage = json['linkImage'];
    linkTitle = json['linkTitle'];
    if (json['mediaList'] != null) {
      mediaList = new List<MediaList>();
      json['mediaList'].forEach((v) {
        mediaList.add(new MediaList.fromJson(v));
      });
    }
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['type'] = this.type;
    data['link'] = this.link;
    data['linkImage'] = this.linkImage;
    data['linkTitle'] = this.linkTitle;
    if (this.mediaList != null) {
      data['mediaList'] = this.mediaList.map((v) => v.toJson()).toList();
    }
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}

class MediaList {
  int type;
  String url;

  MediaList({this.type, this.url});

  MediaList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
