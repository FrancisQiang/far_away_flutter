import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/dynamic_post_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/upload_response_bean.dart';
import 'package:far_away_flutter/bean/upload_token_bean.dart';
import 'package:far_away_flutter/page/post/location_choose_page.dart';
import 'package:far_away_flutter/page/post/post_asset_wrap_builder.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/provider/post_provider.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/asset_picker_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:link_previewer/link_previewer.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostDynamicPage extends StatefulWidget {
  @override
  _PostDynamicPageState createState() => _PostDynamicPageState();
}

class _PostDynamicPageState extends State<PostDynamicPage> {

  final String postType = "dynamic";

  Future<void> _loadAssets(PostProvider postProvider) async {
    List<AssetEntity> resultList;
    try {
      resultList = await AssetPickerUtil.pickerCommon(context);
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    // 用户选中才进行更改
    if (resultList != null) {
      postProvider.dynamicAssets = resultList;
      if (postProvider.dynamicAssets != null &&
          postProvider.dynamicAssets.isNotEmpty) {
        postProvider.dynamicAssetChoose = true;
      }
      postProvider.refresh();
    }
  }

  _convertAssetToFile(List<AssetEntity> assets) async {
    List<AssetFile> result = [];
    for (int i = 0; i < assets.length; i++) {
      AssetEntity assetEntity = assets[i];
      result.add(AssetFile(
          type: assetEntity.type == AssetType.video ? 2 : 1,
          file: await assetEntity.file));
    }
    return result;
  }

  bool _showLocation(PostProvider postProvider) {
    return postProvider.addressMapping[postType] != null && postProvider.addressMapping[postType].type != AddressBeanWrapper.hideType;
  }

  /// 发布动态
  _postDynamic(PostProvider postProvider, String jwt, String content) async {
    // 暂存
    bool showLocation = _showLocation(postProvider);
    String location = postProvider.addressMapping[postType]?.name;
    double longitude = postProvider.addressMapping[postType]?.longitude;
    double latitude = postProvider.addressMapping[postType]?.latitude;
    List<AssetFile> files =
        await _convertAssetToFile(postProvider.dynamicAssets);
    postProvider.addressMapping[postType] = null;
    postProvider.dynamicAssets.clear();
    if (!StringUtil.isEmpty(jwt)) {
      Navigator.pop(context);
      ToastUtil.showNoticeToast("发布中请稍后");
      try {
        Response<dynamic> response =
            await ApiMethodUtil.getUploadToken(userToken: jwt);
        ResponseBean responseBean = ResponseBean.fromJson(response.data);
        UploadTokenBean uploadTokenBean =
            UploadTokenBean.fromJson(responseBean.data);
        DynamicPostBean dynamicPostBean = DynamicPostBean();
        dynamicPostBean.content = content;
        if (!StringUtil.isEmpty(postProvider.dynamicLinkController.text)) {
          dynamicPostBean.link = postProvider.dynamicLinkController.text;
          dynamicPostBean.linkImage = postProvider.dynamicLinkData['image'];
          dynamicPostBean.linkTitle = postProvider.dynamicLinkData['title'];
          dynamicPostBean.type = 1;
        } else {
          // 上传图片
          dynamicPostBean.mediaList =
              await _uploadAssets(uploadTokenBean.token, files);
          dynamicPostBean.type = 0;
        }
        if (showLocation) {
          dynamicPostBean.location = location;
          dynamicPostBean.longitude = longitude;
          dynamicPostBean.latitude = latitude;
        }
        // 链接信息
        Response<dynamic> postResponse = await ApiMethodUtil.postDynamic(
            token: jwt, dynamicPostBean: dynamicPostBean);
        ResponseBean postResponseBean =
            ResponseBean.fromJson(postResponse.data);
        if (postResponseBean.isSuccess()) {
          ToastUtil.showSuccessToast("发布成功");
        } else {
          ToastUtil.showSuccessToast("发布失败 ${postResponseBean.message}");
        }
      } catch (ex) {
        print(ex);
        ToastUtil.showSuccessToast("网络异常 发布失败");
      }
    } else {
      // 处理异常
      print('token异常');
    }
    postProvider.refresh();
  }

  // 上传图片
  Future<List<MediaList>> _uploadAssets(
      String token, List<AssetFile> files) async {
    List<MediaList> result = [];
    for (int i = 0; i < files.length; i++) {
      Response<dynamic> uploadResult = await ApiMethodUtil.uploadPicture(
          token: token, file: files[i].file, filename: '${Uuid().v4()}');
      UploadResponseBean uploadResponseBean =
          UploadResponseBean.fromJson(uploadResult.data);
      MediaList mediaList = MediaList(
          type: files[i].type,
          url: ApiProperties.ASSET_PREFIX_URL + uploadResponseBean.key);
      result.add(mediaList);
    }
    return result;
  }

  /// 获取定位
  _getLocation() async {
    // 查看权限并校验
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    Position position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    // 获取地址并跳转选择地址详情
    NavigatorUtil.toLocationChoosePage(context,
        longitude: position.longitude.toString(),
        latitude: position.latitude.toString(),
        type: "dynamic");
  }

  /// 超链接对话框
  Future<void> _hyberlinkDialog(
      BuildContext context, PostProvider postProvider) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              '添加链接',
              style: TextStyle(
                  letterSpacing: 0.5, fontSize: ScreenUtil().setSp(36)),
            ),
            titlePadding: EdgeInsets.only(top: 20, bottom: 25, left: 20),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            content: Container(
              height: ScreenUtil().setHeight(75),
              width: ScreenUtil().setWidth(700),
              child: TextField(
                cursorColor: Colors.black,
                controller: postProvider.dynamicLinkController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(20)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: ScreenUtil().setSp(30)),
                  )),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (!StringUtil.isEmpty(
                        postProvider.dynamicLinkController.text)) {
                      http.Response response;
                      try {
                        postProvider.dynamicLinkData = null;
                        response = await http
                            .get(postProvider.dynamicLinkController.text);
                      } catch (e) {
                        print(e);
                        postProvider.dynamicLinkData = {
                          "title": postProvider.dynamicLinkController.text,
                          "image": ''
                        };
                        postProvider.refresh();
                        return;
                      }
                      postProvider.dynamicLinkData =
                          WebPageParser.getDataFromResponse(response,
                              postProvider.dynamicLinkController.text);
                    }
                    postProvider.refresh();
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: ScreenUtil().setSp(30)),
                  ))
            ],
          );
        });
  }

  Widget _buildLinkContent(PostProvider postProvider) {
    if (!StringUtil.isEmpty(postProvider.dynamicLinkController.text)) {
      if (postProvider.dynamicLinkData != null) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(25),
                vertical: ScreenUtil().setHeight(20)),
            height: ScreenUtil().setHeight(150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Row(
              children: [
                Container(
                  child:
                      StringUtil.isEmpty(postProvider.dynamicLinkData['image'])
                          ? Image.asset(
                              'assets/png/network.png',
                              width: ScreenUtil().setWidth(120),
                              height: ScreenUtil().setWidth(120),
                            )
                          : CachedNetworkImage(
                              imageUrl: postProvider.dynamicLinkData['image'],
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setWidth(100),
                            ),
                ),
                Container(
                  width: ScreenUtil().setWidth(420),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Text(
                    StringUtil.isEmpty(postProvider.dynamicLinkData['title'])
                        ? postProvider.dynamicLinkController.text
                        : postProvider.dynamicLinkData['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(27)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    postProvider.dynamicLinkData = null;
                    postProvider.refresh();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black26),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white70,
                      size: ScreenUtil().setSp(30),
                    ),
                  ),
                )
              ],
            ));
      } else {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(25),
                vertical: ScreenUtil().setHeight(20)),
            height: ScreenUtil().setHeight(150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: ScreenUtil().setWidth(40),
                    width: ScreenUtil().setWidth(40),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.orange),
                    )),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                  child: Text(
                    '乏味正在为您解析...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                  ),
                ),
              ],
            ));
      }
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalInfoProvider, PostProvider>(
      builder: (context, globalInfoProvider, postProvider, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  child: Icon(FontAwesomeIcons.angleLeft),
                ),
              ),
              title: Text('发布新动态'),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    color: StringUtil.isEmpty(
                            postProvider.dynamicContentController.text)
                        ? Colors.grey
                        : Colors.yellow,
                    child: Text(
                      '发布',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.w600,
                          color: StringUtil.isEmpty(
                                  postProvider.dynamicContentController.text)
                              ? Colors.white70
                              : Colors.black,
                          letterSpacing: 2),
                    ),
                    onPressed: StringUtil.isEmpty(
                            postProvider.dynamicContentController.text)
                        ? null
                        : () {
                            _postDynamic(postProvider, globalInfoProvider.jwt,
                                postProvider.dynamicContentController.text);
                          },
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Container(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              minLines: 1,
                              maxLines: 100,
                              keyboardType: TextInputType.multiline,
                              controller: postProvider.dynamicContentController,
                              decoration: InputDecoration(
                                  hintText: '分享你的想法...',
                                  hintStyle: TextStyle(color: Colors.black38),
                                  border: InputBorder.none),
                            ),
                          ),
                          _buildLinkContent(postProvider),
                          postProvider.dynamicAssets.isEmpty
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: PostAssetWrapBuilder(
                                    assets: postProvider.dynamicAssets,
                                    itemWidth: ScreenUtil().setWidth(220),
                                    listListener: (assets) {
                                      if (assets.isEmpty) {
                                        postProvider.dynamicAssetChoose = false;
                                        postProvider.refresh();
                                      }
                                    },
                                  ),
                                ),
                          GestureDetector(
                            onTap: _getLocation,
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(80)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color:
                                                _showLocation(postProvider)
                                                    ? Colors.lightBlueAccent
                                                    : Colors.black45,
                                            size: ScreenUtil().setSp(30),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            _showLocation(postProvider)
                                                ? postProvider.addressMapping[postType].name
                                                : "你在哪里？",
                                            style: TextStyle(
                                                color: _showLocation(postProvider)
                                                    ? Colors.lightBlueAccent
                                                    : Colors.black45,
                                                fontSize:
                                                    ScreenUtil().setSp(23)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 0.1)),
                      color: Colors.white,
                    ),
                    height: ScreenUtil().setHeight(90),
                    width: ScreenUtil().setWidth(750),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: !StringUtil.isEmpty(
                                    postProvider.dynamicLinkController.text)
                                ? null
                                : () async {
                                    await _loadAssets(postProvider);
                                  },
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  !StringUtil.isEmpty(postProvider
                                          .dynamicLinkController.text)
                                      ? 'assets/png/album_inactive.png'
                                      : 'assets/png/album.png',
                                  width: ScreenUtil().setWidth(60),
                                  height: ScreenUtil().setHeight(60),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      '/',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(50),
                                          color: !StringUtil.isEmpty(
                                                  postProvider
                                                      .dynamicLinkController
                                                      .text)
                                              ? Colors.black38
                                              : Colors.black),
                                    )),
                                Image.asset(
                                  !StringUtil.isEmpty(postProvider
                                          .dynamicLinkController.text)
                                      ? 'assets/png/video_inactive.png'
                                      : 'assets/png/video_active.png',
                                  width: ScreenUtil().setWidth(60),
                                  height: ScreenUtil().setHeight(60),
                                ),
                              ],
                            )),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: postProvider.dynamicAssetChoose
                              ? null
                              : () {
                                  _hyberlinkDialog(context, postProvider);
                                },
                          child: Image.asset(
                            postProvider.dynamicAssetChoose
                                ? 'assets/png/link_inactive.png'
                                : 'assets/png/link_active.png',
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setHeight(50),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}

class AssetFile {
  int type;
  File file;

  AssetFile({this.type, this.file});
}
