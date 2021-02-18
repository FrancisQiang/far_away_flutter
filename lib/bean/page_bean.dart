class PageBean {

  int currentPage;
  int totalPage;
  int totalCount;
  int size;
  bool hasNextPage;
  List<dynamic> list;

  PageBean({this.currentPage, this.totalPage, this.totalCount, this.size,
      this.hasNextPage, this.list});


  PageBean.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalCount = json['totalCount'];
    size = json['size'];
    hasNextPage = json['hasNextPage'];
    list = json['list'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    data['totalCount'] = this.totalCount;
    data['size'] = this.size;
    data['hasNextPage'] = this.hasNextPage;
    data['list'] = this.list;
    return data;
  }

}