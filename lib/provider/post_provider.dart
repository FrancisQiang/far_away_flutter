import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostProvider with ChangeNotifier {

  PostProvider() {
    dynamicContentController.addListener(() {
      refresh();
    });
    togetherContentController.addListener(() {
      refresh();
    });
  }

  /// 定位选择 通用化
  Map<String, AddressBeanWrapper> addressMapping = {};

  /// -----------------动态相关------------------
  /// 资源列表
  List<AssetEntity> dynamicAssets = [];

  /// 是否添加资源
  bool dynamicAssetChoose = false;

  TextEditingController dynamicLinkController = TextEditingController();

  /// 链接解析后的内容
  Map dynamicLinkData;

  TextEditingController dynamicContentController = TextEditingController();
  /// -----------------动态相关------------------

  TextEditingController togetherContentController = TextEditingController();


  void refresh() {
    notifyListeners();
  }
  
}
