class ListBean {

  List<dynamic> listData;

  ListBean({this.listData});


  ListBean.fromJson(Map<String, dynamic> json) {
    listData = json['listData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listData'] = this.listData;
    return data;
  }

}