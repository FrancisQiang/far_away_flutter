import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DynamicPostProvider with ChangeNotifier {

  /// 资源列表
  List<AssetEntity> _assets = [];

  /// 地址信息
  String _location = '你在哪里?';

  /// 是否显示地址
  bool _showLocation = false;

  /// 地址包装详细信息
  AddressBeanWrapper _addressBeanWrapper;

  /// 是否添加链接
  bool _linkChoose = false;

  /// 是否添加资源
  bool _assetChoose = false;

  /// 链接地址
  String _link;

  /// 链接解析后的内容
  Map _linkData;

  List<AssetEntity> get assets => _assets;

  set assets(List<AssetEntity> value) {
    _assets = value;
    notifyListeners();
  }

  Map get linkData => _linkData;

  set linkData(Map value) {
    _linkData = value;
    notifyListeners();
  }

  String get link => _link;

  set link(String value) {
    _link = value;
    notifyListeners();
  }

  bool get linkChoose => _linkChoose;

  set linkChoose(bool value) {
    _linkChoose = value;
    notifyListeners();
  }



  String get location => _location;

  set location(String value) {
    _location = value;
    notifyListeners();
  }

  bool get showLocation => _showLocation;

  set showLocation(bool value) {
    _showLocation = value;
    notifyListeners();
  }

  AddressBeanWrapper get addressBeanWrapper => _addressBeanWrapper;

  set addressBeanWrapper(AddressBeanWrapper value) {
    _addressBeanWrapper = value;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  bool get assetChoose => _assetChoose;

  set assetChoose(bool value) {
    _assetChoose = value;
    notifyListeners();
  }
}
