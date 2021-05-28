import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class ImageChooseButton extends StatelessWidget {

  final Function loadPictures;

  ImageChooseButton({this.loadPictures});

  @override
  Widget build(BuildContext context) {
    if (loadPictures == null) {
      return SizedBox();
    }
    return GestureDetector(
      onTap: () async {
        await loadPictures();
      },
      child: Container(
          margin: EdgeInsets.only(left: 8),
          width: ScreenUtil().setWidth(55),
          height: ScreenUtil().setWidth(55),
          child: Image.asset(AssetProperties.ALBUM)),
    );
  }
}
