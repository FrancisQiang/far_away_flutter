import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetPickerUtil {

  static Future<List<AssetEntity>> pickerCommon(context) async {
    return await AssetPicker.pickAssets(context,
        requestType: RequestType.common,
        // themeColor: Colors.orange,
        pickerTheme: ThemeData.light().copyWith(
          // appbar 和 bottomBar颜色
          primaryColor: Colors.white,
          // 当前选择相册的背景颜色
          canvasColor: Colors.white,
          // 长按按钮颜色
          highlightColor: Colors.grey[200],
          // 预览选择的颜色
          toggleableActiveColor: Colors.orangeAccent,
          colorScheme: ColorScheme(
            // 图片选中颜色 选择相册指示器箭头颜色
            primary: Colors.white,
            // 不知道干啥的
            primaryVariant: Colors.white,
            secondary: Colors.orangeAccent,
            secondaryVariant: Colors.orangeAccent,
            // 选择相册的背景颜色
            background: Colors.white,
            surface: Colors.white,
            brightness: Brightness.light,
            error: const Color(0xffcf6679),
            onPrimary: Colors.transparent,
            onSecondary: Colors.transparent,
            onSurface: Colors.transparent,
            onBackground: Colors.transparent,
            onError: Colors.transparent,
          ),
        )
    );
  }

  static Future<List<AssetEntity>> pickerPicture(context) async {
    return await AssetPicker.pickAssets(context,
        requestType: RequestType.image,
        // themeColor: Colors.orange,
        pickerTheme: ThemeData.light().copyWith(
          // appbar 和 bottomBar颜色
          primaryColor: Colors.white,
          // 当前选择相册的背景颜色
          canvasColor: Colors.white,
          // 长按按钮颜色
          highlightColor: Colors.grey[200],
          // 预览选择的颜色
          toggleableActiveColor: Colors.orangeAccent,
          colorScheme: ColorScheme(
            // 图片选中颜色 选择相册指示器箭头颜色
            primary: Colors.white,
            // 不知道干啥的
            primaryVariant: Colors.white,
            secondary: Colors.orangeAccent,
            secondaryVariant: Colors.orangeAccent,
            // 选择相册的背景颜色
            background: Colors.white,
            surface: Colors.white,
            brightness: Brightness.light,
            error: const Color(0xffcf6679),
            onPrimary: Colors.transparent,
            onSecondary: Colors.transparent,
            onSurface: Colors.transparent,
            onBackground: Colors.transparent,
            onError: Colors.transparent,
          ),
        )
    );
  }

}