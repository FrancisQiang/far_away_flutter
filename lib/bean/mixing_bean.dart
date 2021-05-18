class MixingBean {

  List<dynamic> dynamics;
  List<dynamic> togethers;
  List<dynamic> recruits;

  MixingBean({this.dynamics, this.togethers, this.recruits});


  MixingBean.fromJson(Map<String, dynamic> json) {
    dynamics = json['dynamics'];
    togethers = json['togethers'];
    recruits = json['recruits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dynamics'] = this.dynamics;
    data['togethers'] = this.togethers;
    data['recruits'] = this.recruits;
    return data;
  }

}