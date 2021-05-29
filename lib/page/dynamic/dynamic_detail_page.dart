import 'dart:io';
import 'dart:ui';

import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/measure_size.dart';
import 'package:far_away_flutter/constant/biz_type.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/asset_picker_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../comment/comment_bottom.dart';
import 'dynamic_detail_component.dart';

class DynamicDetailPage extends StatefulWidget {
  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final DynamicDetailBean dynamicDetailBean;

  DynamicDetailPage(
      {this.scrollToComment, this.avatarHeroTag, this.dynamicDetailBean});

  @override
  _DynamicDetailPageState createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState extends State<DynamicDetailPage> {
  List<File> imageFileList = [];

  TextEditingController commentEditController = TextEditingController();

  double bottomMargin = ScreenUtil().setHeight(100);

  /// 选择照片回调函数
  _loadPictures() async {
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
      imageFileList.clear();
      for (int i = 0; i < resultList.length; i++) {
        File file = await resultList[i].file;
        imageFileList.add(file);
      }
      setState(() {});
    }
  }

  _refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          '乏味',
          style: TextStyle(
            fontFamily: AssetProperties.FZ_SIMPLE,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(40),
            letterSpacing: 3,
          ),
        ),
        actions: [IconButton(icon: Icon(Icons.more_horiz), onPressed: () {})],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: bottomMargin,
            ),
            child: DynamicDetailComponent(
              scrollToComment: widget.scrollToComment,
              avatarHeroTag: widget.avatarHeroTag,
              dynamicDetailBean: widget.dynamicDetailBean,
              commentEditController: commentEditController,
              imageFileList: imageFileList,
              loadPictures: _loadPictures,
              refreshCallback: _refreshCallback,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: MeasureSize(
              child: CommentBottom(
                bizType: BizType.DYNAMIC_COMMENT,
                bizId: widget.dynamicDetailBean.id,
                toUserId: widget.dynamicDetailBean.userId,
                imageFileList: imageFileList,
                commentEditController: commentEditController,
                loadPictures: _loadPictures,
                refreshCallback: _refreshCallback,
              ),
              onChange: (size) {
                setState(() {
                  bottomMargin = size.height;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
