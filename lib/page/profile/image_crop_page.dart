import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_crop/image_crop.dart';

class ImageCropPage extends StatefulWidget {

  final String url;

  final Function(File file) confirmCallback;

  final double aspectRatio;

  ImageCropPage({@required this.url, this.confirmCallback, this.aspectRatio});

  @override
  _ImageCropPageState createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {


  GlobalKey<CropState> _key = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                  alignment: Alignment.center,
                  child: Crop(
                    key: _key,
                    image: FileImage(File(widget.url)),
                    aspectRatio: widget.aspectRatio == null ? 1.0 : widget.aspectRatio,
                    maximumScale: 1.0,
                  )
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
                ),
                width: ScreenUtil().setWidth(750),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        height: 25,
                        minWidth: 25,
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () async {
                          final croppedFile = await ImageCrop.cropImage(
                            file: File(widget.url),
                            area: _key.currentState.area,
                          );
                          await widget.confirmCallback(croppedFile);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
