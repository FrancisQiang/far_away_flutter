import 'package:multi_image_picker/multi_image_picker.dart';

class MultiImagePickerUtil {

  static Future<List<Asset>> pick(List<Asset> images) {
    return MultiImagePicker.pickImages(
      maxImages: 9,
      enableCamera: true,
      selectedAssets: images,
      materialOptions: MaterialOptions(
        actionBarTitleColor: '#000000',
        actionBarColor: "#FFA500",
        actionBarTitle: "我的相册",
        statusBarColor: '#FFA500',
        allViewTitle: "全部",
        lightStatusBar: true,
        useDetailsView: true,
        selectCircleStrokeColor: "#FFA500",
      ),
    );
  }

}