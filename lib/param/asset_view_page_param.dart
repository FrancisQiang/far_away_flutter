import 'package:flutter/cupertino.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetViewPageParam {

   List<AssetEntity> assetList;

   int currentIndex;

   AssetViewPageParam({@required this.assetList, this.currentIndex = 0});
}