import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/upload_response_bean.dart';
import 'package:far_away_flutter/bean/upload_token_bean.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'dart:ui' as ui;
import 'dart:convert' as convert;
import 'package:city_pickers/city_pickers.dart';

class PostRecruitPage extends StatefulWidget {
  @override
  _PostRecruitPageState createState() => _PostRecruitPageState();
}

class _PostRecruitPageState extends State<PostRecruitPage> {
  ZefyrController _controller;

  FocusNode _focusNode;

  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    var json = convert.jsonDecode(
        '[{\"insert\": \"Ghjvc\\n\" }, { 	\"insert\": \"​\", 	\"attributes\": { 		\"embed\": { 			\"type\": \"image\", 			\"source\": \"http://faraway.francisqiang.top/FjoKvvpRkHck_7p6RTEY40Xp7_DB\" 		} 	} }, { 	\"insert\": \"\\n\" }]');
    // final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromJson(json);
    // return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: ScreenUtil().setHeight(80),
          brightness: Brightness.light,
          leading: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
              child: Icon(FontAwesomeIcons.angleLeft)),
          title: Text(
            '招义工',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 2,
                bottom: 2,
                right: ScreenUtil().setWidth(15),
              ),
              width: ScreenUtil().setWidth(160),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.orangeAccent,
                child: Text(
                  '发布',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 2),
                ),
                onPressed: () {
                  print(convert.jsonEncode(_controller.document.toJson()));
                  // NotusDocument.fromJson(data)
                },
              ),
            )
          ],
        ),
        body: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: Container(
            child: ZefyrScaffold(
              child: ZefyrEditor(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30),
                  vertical: ScreenUtil().setHeight(20),
                ),
                controller: _controller,
                focusNode: _focusNode,
                imageDelegate: MarkdownImageDelegate(),
                toolbarDelegate: MarkdownToolbarDelegate(),
                customAboveWidget: Container(
                  child: Column(
                    children: [
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        controller: _titleController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '请输入一个完整的标题',
                          hintStyle: TextStyle(
                            color: Colors.black12,
                            fontSize: ScreenUtil().setSp(35),
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black12, width: 1.5)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black12, width: 1.5)),
                          border: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black12, width: 1.5)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final PickedFile file = await _picker.getImage(source: ImageSource.gallery);
                          if (file == null) return null;
                          Response<dynamic> response = await ApiMethodUtil.getUploadToken(
                              userToken: ProviderUtil.globalInfoProvider.jwt);
                          ResponseBean responseBean = ResponseBean.fromJson(response.data);
                          UploadTokenBean uploadTokenBean =
                          UploadTokenBean.fromJson(responseBean.data);

                          Response<dynamic> uploadResult = await ApiMethodUtil.uploadPicture(
                              token: uploadTokenBean.token,
                              file: File(file.path),
                              filename: '${Uuid().v4()}');
                          UploadResponseBean uploadResponseBean =
                          UploadResponseBean.fromJson(uploadResult.data);
                          return ApiProperties.ASSET_PREFIX_URL + uploadResponseBean.key;
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 20
                          ),
                          child: Card(
                            elevation: 2,
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(250),
                              width: double.infinity,
                              child: Text(
                                '点击设置封面',
                                style: TextStyle(
                                    color: Colors.black12,
                                    fontSize: ScreenUtil().setSp(35),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        )
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
        ));
  }
}

class MarkdownImageDelegate implements ZefyrImageDelegate<ImageSource> {
  MarkdownImageDelegate();

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile file = await _picker.getImage(source: source);
    if (file == null) return null;
    Response<dynamic> response = await ApiMethodUtil.getUploadToken(
        userToken: ProviderUtil.globalInfoProvider.jwt);
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    UploadTokenBean uploadTokenBean =
        UploadTokenBean.fromJson(responseBean.data);

    Response<dynamic> uploadResult = await ApiMethodUtil.uploadPicture(
        token: uploadTokenBean.token,
        file: File(file.path),
        filename: '${Uuid().v4()}');
    UploadResponseBean uploadResponseBean =
        UploadResponseBean.fromJson(uploadResult.data);
    return ApiProperties.ASSET_PREFIX_URL + uploadResponseBean.key;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    return MarkdownImage(key);
  }
}

class MarkdownImage extends StatefulWidget {
  final String imageUrl;

  MarkdownImage(this.imageUrl);

  @override
  _MarkdownImageState createState() => _MarkdownImageState();
}

class _MarkdownImageState extends State<MarkdownImage> {
  double scale;

  @override
  void initState() {
    super.initState();
    Image image = Image.network(widget.imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo image, bool synchronousCall) {
      scale = image.image.height / image.image.width;
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (scale != null) {
      return Container(
        constraints: BoxConstraints(
            maxWidth: ScreenUtil().setWidth(720),
            maxHeight: ScreenUtil().setWidth(720) * scale),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.orange),
      ));
    }
  }
}

class MarkdownToolbarDelegate implements ZefyrToolbarDelegate {
  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.galleryImage: Icons.photo,
    ZefyrToolbarAction.location: Icons.location_on,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
  };

  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    if (kDefaultButtonIcons.containsKey(action)) {
      if (action == ZefyrToolbarAction.location) {
        // 设置location回调
        onPressed = () async {
          Result result = await CityPickers.showCityPicker(
            context: context,
            height: ScreenUtil().setHeight(400),
            locationCode: "321171",
          );
        };
      }
      final icon = kDefaultButtonIcons[action];
      return ZefyrButton.icon(
        action: action,
        icon: icon,
        onPressed: onPressed,
      );
    } else {
      return SizedBox();
    }
  }
}
