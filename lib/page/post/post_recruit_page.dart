import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/recruit_post_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/upload_response_bean.dart';
import 'package:far_away_flutter/bean/upload_token_bean.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/buttons.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/editor.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/image.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/scaffold.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/toolbar.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/provider/post_recruit_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert' as convert;
import 'package:city_pickers/city_pickers.dart';
import 'package:quill_delta/quill_delta.dart';

class PostRecruitPage extends StatelessWidget {

  postRecruitInfo(BuildContext context, PostRecruitProvider provider) async {
    print('title: ${provider.titleController.text}');
    print('content: ${convert.jsonEncode(provider.markdownController.document.toJson())}');
    print('cover: ${provider.cover}');
    print('location: ${provider.locationDetail}');
    RecruitPostBean recruitPostBean = RecruitPostBean(
        title: provider.titleController.text,
        content: convert.jsonEncode(provider.markdownController.document.toJson()),
        cover: provider.cover,
        location: provider.locationDetail
    );
    Navigator.pop(context);
    ToastUtil.showNoticeToast("发布中请稍后");
    provider.titleController.clear();
    provider.locationDetail = null;
    provider.cover = null;
    provider.refresh();
    Response postResponse = await ApiMethodUtil.postRecruit(token: ProviderUtil.globalInfoProvider.jwt, recruitPostBean: recruitPostBean);
    ResponseBean postResponseBean = ResponseBean.fromJson(postResponse.data);
    if (postResponseBean.isSuccess()) {
      ToastUtil.showSuccessToast("发布成功");
    } else {
      ToastUtil.showSuccessToast("发布失败 ${postResponseBean.message}");
    }
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
            Consumer<PostRecruitProvider>(
              builder: (context, postRecruitProvider, child) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    right: ScreenUtil().setWidth(15),
                  ),
                  width: ScreenUtil().setWidth(160),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: RaisedButton(
                    disabledColor: Colors.orangeAccent[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.orangeAccent,
                    child: Text(
                      '发布',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          fontWeight: FontWeight.w600,
                          color: postRecruitProvider.postEnable()
                              ? Colors.black
                              : Colors.black38,
                          letterSpacing: 2),
                    ),
                    onPressed: postRecruitProvider.postEnable() ? () {
                      postRecruitInfo(context, postRecruitProvider);
                    } : null,
                  ),
                );
              },
            )
          ],
        ),
        body: ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: AbsorbPointer(
              absorbing: false,
              child: Container(
                child: ZefyrScaffold(
                  child: Consumer<PostRecruitProvider>(
                    builder: (context, postRecruitProvider, child) {
                      return ZefyrEditor(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                          vertical: ScreenUtil().setHeight(20),
                        ),
                        controller: postRecruitProvider.markdownController,
                        focusNode: postRecruitProvider.markdownFocusNode,
                        imageDelegate: MarkdownImageDelegate(),
                        toolbarDelegate: MarkdownToolbarDelegate(),
                        customAboveWidget: Container(
                            child: Column(
                              children: [
                                Consumer<PostRecruitProvider>(
                                  builder: (context, postRecruitProvider, child) {
                                    return TextField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
                                      controller: postRecruitProvider.titleController,
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
                                            borderSide: BorderSide(
                                                color: Colors.black12, width: 1.5)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12, width: 1.5)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12, width: 1.5)),
                                      ),
                                    );
                                  },
                                ),
                                Consumer<PostRecruitProvider>(
                                  builder: (context, postRecruitProvider, child) {
                                    if (postRecruitProvider.cover == null) {
                                      return Container();
                                    }
                                    return Container(
                                        margin: EdgeInsets.only(top: 20),
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              child: CachedNetworkImage(
                                                height: ScreenUtil().setHeight(250),
                                                width: double.infinity,
                                                imageUrl: postRecruitProvider.cover,
                                                fit: BoxFit.cover,
                                              ),
                                            )));
                                  },
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ),
              ),
            )));
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
          ),
        )
      );
    } else {
      return Container(
        constraints: BoxConstraints(
            maxWidth: ScreenUtil().setWidth(720),
            maxHeight: ScreenUtil().setWidth(720) * 9 / 16),
        child: Center(
            child: ImageHolder()
        ),
      );
    }
  }
}

class MarkdownToolbarDelegate implements ZefyrToolbarDelegate {
  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.galleryImage: Icons.photo,
    ZefyrToolbarAction.coverImage: Icons.photo_outlined,
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
            locationCode: ProviderUtil.postRecruitProvider.locationCode == null
                ? "321171"
                : ProviderUtil.postRecruitProvider.locationCode,
          );
          ProviderUtil.postRecruitProvider.locationDetail = result.provinceName + "·" + result.cityName;
          ProviderUtil.postRecruitProvider.locationCode = result.areaId;
          ProviderUtil.postRecruitProvider.refresh();
        };
      } else if (action == ZefyrToolbarAction.coverImage) {
        onPressed = () async {
          final ImagePicker _picker = ImagePicker();
          final PickedFile file =
              await _picker.getImage(source: ImageSource.gallery);
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
          ProviderUtil.postRecruitProvider.cover =
              ApiProperties.ASSET_PREFIX_URL + uploadResponseBean.key;
          ProviderUtil.postRecruitProvider.refresh();
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
