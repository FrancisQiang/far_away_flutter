import 'package:far_away_flutter/page/post/post_asset_item.dart';
import 'package:far_away_flutter/param/asset_view_page_param.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostAssetWrapBuilder extends StatelessWidget {

  final List<AssetEntity> assets;

  final double itemWidth;

  PostAssetWrapBuilder({@required this.assets,@required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    print(assets.length);
    return Wrap(
      runSpacing: 2,
      children: List<Widget>.generate(assets.length, (index) {
        print(index);
        AssetEntity assetEntity = assets[index];
        return GestureDetector(
          onTap: () {
            NavigatorUtil.toAssetViewPage(context, param: AssetViewPageParam(assetList: assets, currentIndex: assets.indexOf(assetEntity)));
          },
          child: PostAssetItem(
            assetEntity: assetEntity,
            sideLength: itemWidth,
            remove: () {
              print(assets);
              assets.remove(assetEntity);
              print(assets);
            },
          ),
        );
      }),
    );
  }
}

