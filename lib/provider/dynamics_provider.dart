import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';

class DynamicsProvider with ChangeNotifier {
  List<DynamicDetailBean> dynamicList = [];

  int currentPage = 1;

  int timestamp = DateTime.now().millisecondsSinceEpoch;

  loadDynamicData(String jwt) async {
    ResponseBean responseBean;
    PageBean pageBean;
    try {
      responseBean = await ApiMethodUtil.getDynamicList(
        timestamp: timestamp,
        currentPage: currentPage,
      );
      pageBean = PageBean.fromJson(responseBean.data);
    } catch (ex) {
      return;
    }
    if (pageBean.list.isEmpty) {
      ToastUtil.showNoticeToast("没有数据啦");
      return;
    }
    currentPage++;
    for (int i = 0; i < pageBean.list.length; i++) {
      DynamicDetailBean bean = DynamicDetailBean.fromJson(pageBean.list[i]);
      dynamicList.add(bean);
    }
    notifyListeners();
  }

  onRefresh(jwt) async {
    dynamicList = [];
    currentPage = 1;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    await loadDynamicData(jwt);
  }

  void refresh() => notifyListeners();
}
