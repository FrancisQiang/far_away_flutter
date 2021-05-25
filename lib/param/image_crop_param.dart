import 'dart:io';

class ImageCropParam {

  String url;

  Function(File file) confirmCallback;

  double aspectRatio;

  ImageCropParam({this.url, this.confirmCallback, this.aspectRatio});

}