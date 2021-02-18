import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:flutter/material.dart';

class GlobalInfoProvider with ChangeNotifier{

  String jwt;

  UserInfoBean userInfoBean;

  void refresh() {
    notifyListeners();
  }

}