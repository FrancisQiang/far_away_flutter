import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/follow_user_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GlobalInfoProvider with ChangeNotifier{

  GlobalInfoProvider() {
    Timer.periodic(Duration(seconds: 30), (timer) async {
      if(jwt == null || jwt.isEmpty) {
        return;
      }
      Response<dynamic> response = await ApiMethodUtil.getFollowList(token: jwt);
      print('response: ${response.data.toString()}');
      ResponseBean responseBean = ResponseBean.fromJson(response.data);
      FollowListVO followListVO = FollowListVO.fromJson(responseBean.data);
      Map<String, FollowUserInfo> followUserMap = HashMap();
      for(FollowUserInfo item in followListVO.list) {
        followUserMap[item.userId] = item;
      }
      this.followUserMap = followUserMap;
      notifyListeners();
    });
  }

  refreshFollowList() async {
    Response<dynamic> response = await ApiMethodUtil.getFollowList(token: jwt);
    print('response: ${response.data.toString()}');
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    FollowListVO followListVO = FollowListVO.fromJson(responseBean.data);
    Map<String, FollowUserInfo> followUserMap = HashMap();
    for(FollowUserInfo item in followListVO.list) {
      followUserMap[item.userId] = item;
    }
    this.followUserMap = followUserMap;
  }

  String jwt;

  UserInfoBean userInfoBean;

  Map<String, FollowUserInfo> followUserMap;

  void refresh() {
    notifyListeners();
  }

}