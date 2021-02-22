import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/upload_response_bean.dart';
import 'package:far_away_flutter/bean/upload_token_bean.dart';
import 'package:far_away_flutter/page/post/post_dynamic_page.dart';
import 'package:far_away_flutter/properties/api_properties.dart';
import 'package:far_away_flutter/provider/dynamic_comment_chosen_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/asset_picker_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CommentBottom extends StatefulWidget {
  @override
  _CommentBottomState createState() => _CommentBottomState();
}

class _CommentBottomState extends State<CommentBottom> {
  _loadPictures(
      DynamicCommentChosenProvider dynamicCommentChosenProvider) async {
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
      dynamicCommentChosenProvider.assetList = resultList;
      dynamicCommentChosenProvider.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: [
          // 已选择的图片列表
          Consumer<DynamicCommentChosenProvider>(
              builder: (context, dynamicCommentChosenProvider, child) {
            return dynamicCommentChosenProvider.assetList.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 2)
                        ]),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    height: ScreenUtil().setWidth(200),
                    child: ListView.builder(
                      itemCount: dynamicCommentChosenProvider.assetList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(6)),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 1)
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: ExtendedImage(
                                    width: ScreenUtil().setWidth(160),
                                    height: ScreenUtil().setWidth(160),
                                    image: AssetEntityImageProvider(
                                      dynamicCommentChosenProvider
                                          .assetList[index],
                                      isOriginal: false,
                                      thumbSize: [160, 160],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox();
          }),
          // 地下bottom
          EditBottom(loadPictures: _loadPictures),
        ],
      ),
    );
  }
}

class EditBottom extends StatelessWidget {
  final Function loadPictures;

  // final Function sendComment;

  EditBottom({@required this.loadPictures});

  final TextEditingController _controller = TextEditingController();

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

  Future<String> _uploadPicture(String token, List<AssetEntity> assets) async {
    Response<dynamic> response =
        await ApiMethodUtil.getUploadToken(userToken: token);
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    UploadTokenBean uploadTokenBean =
        UploadTokenBean.fromJson(responseBean.data);
    List<String> pictureURLList = [];
    for (int i = 0; i < assets.length; i++) {
      File file = await assets[i].file;
      Response<dynamic> uploadResult = await ApiMethodUtil.uploadPicture(
          token: uploadTokenBean.token, file: file, filename: '${Uuid().v4()}');
      UploadResponseBean uploadResponseBean =
          UploadResponseBean.fromJson(uploadResult.data);
      pictureURLList
          .add(ApiProperties.ASSET_PREFIX_URL + uploadResponseBean.key);
    }
    return pictureURLList.join(",");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 1.2)],
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(10), horizontal: 2),
        child: Consumer<DynamicCommentChosenProvider>(
          builder: (context, dynamicCommentChosenProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8)),
                  width: ScreenUtil().setWidth(450),
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(15),
                            top: ScreenUtil().setHeight(5),
                            bottom: ScreenUtil().setHeight(5)),
                        border: InputBorder.none,
                        hintText:
                            '回复 ${dynamicCommentChosenProvider.targetUsername}: ',
                        hintStyle: TextStyleTheme.subH4),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await loadPictures(dynamicCommentChosenProvider);
                  },
                  child: Container(
                      width: ScreenUtil().setWidth(55),
                      height: ScreenUtil().setWidth(55),
                      child: Image.asset('assets/png/album.png')),
                ),
                Container(
                    width: ScreenUtil().setWidth(55),
                    height: ScreenUtil().setWidth(55),
                    child: Image.asset('assets/png/expression.png')),
                InkWell(
                  onTap: () async {
                    // 保存一份资源列表
                    List<AssetEntity> duplicateAssets = [];
                    dynamicCommentChosenProvider.assetList.forEach((asset) {
                      duplicateAssets.add(asset);
                    });
                    String duplicateContent = _controller.text;
                    _controller.text = '';
                    dynamicCommentChosenProvider.assetList.clear();
                    dynamicCommentChosenProvider.refresh();
                    FocusScope.of(context).requestFocus(FocusNode());
                    ToastUtil.showNoticeToast("评论发布中");
                    String jwt = ProviderUtil.globalInfoProvider.jwt;
                    print('PID ${dynamicCommentChosenProvider.pid}'
                        'CONTENT ${dynamicCommentChosenProvider.content}'
                        'targetUserId ${dynamicCommentChosenProvider.targetUserId}'
                        'targetBizId ${dynamicCommentChosenProvider.targetBizId}'
                        'targetUsername ${dynamicCommentChosenProvider.targetUsername}');
                    Response<dynamic> response =
                        await ApiMethodUtil.postComment(
                            token: jwt,
                            bizId: dynamicCommentChosenProvider.targetBizId,
                            toUserId: dynamicCommentChosenProvider.targetUserId,
                            content: duplicateContent,
                            pid: dynamicCommentChosenProvider.pid,
                            bizType: "2",
                            pictureList:
                                await _uploadPicture(jwt, duplicateAssets));
                    ResponseBean responseBean =
                        ResponseBean.fromJson(response.data);
                    if (responseBean.isSuccess()) {
                      ToastUtil.showSuccessToast("评论成功");
                    }
                  },
                  child: Container(
                    child: Text(
                      '发送',
                      style: TextStyleTheme.h3,
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
