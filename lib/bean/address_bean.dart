class AddressBean {
  double longitude;
  double latitude;
  String addressDetail;
  String name;

  AddressBean({this.longitude, this.latitude, this.addressDetail, this.name});

  AddressBean.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressDetail = json['addressDetail'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['addressDetail'] = this.addressDetail;
    data['name'] = this.name;
    return data;
  }
}
