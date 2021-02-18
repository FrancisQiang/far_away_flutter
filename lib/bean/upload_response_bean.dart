class UploadResponseBean {
  String hash;
  String key;

  UploadResponseBean({this.hash, this.key});

  UploadResponseBean.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['key'] = this.key;
    return data;
  }
}