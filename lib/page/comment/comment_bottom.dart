import 'dart:io';

import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/always_disabled_focus_noe.dart';
import 'package:far_away_flutter/page/comment/comment_input_bottom_page.dart';
import 'package:far_away_flutter/page/comment/image_choose_button.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class CommentBottom extends StatefulWidget {
  /// 当前底部评论栏需要评论的信息
  final int bizType;

  final String bizId;

  final String pid;

  final String toUserId;

  // 如果传入 则评论能添加图片
  final List<File> imageFileList;

  final Function loadPictures;

  // 同步编辑
  final TextEditingController commentEditController;

  final Function refreshCallback;

  CommentBottom({
    this.imageFileList,
    @required this.commentEditController,
    @required this.bizType,
    @required this.bizId,
    @required this.toUserId,
    this.refreshCallback,
    this.loadPictures,
    this.pid = '0',
  });

  @override
  _CommentBottomState createState() => _CommentBottomState();
}

class _CommentBottomState extends State<CommentBottom> {

  _generateCommentImageList() {
    return widget.imageFileList != null && widget.imageFileList.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
            ),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            height: ScreenUtil().setWidth(200),
            child: ListView.builder(
              itemCount: widget.imageFileList.length,
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
                              BoxShadow(color: Colors.grey, blurRadius: 1)
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              widget.imageFileList[index],
                              height: ScreenUtil().setWidth(160),
                              width: ScreenUtil().setWidth(160),
                              fit: BoxFit.cover,
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: [
          _generateCommentImageList(),
          // 地下bottom
          EditBottom(
            bizType: widget.bizType,
            bizId: widget.bizId,
            pid: widget.pid,
            toUserId: widget.toUserId,
            loadPictures: widget.loadPictures,
            commentEditController: widget.commentEditController,
            imageFileList: widget.imageFileList,
            refreshCallback: widget.refreshCallback,
          ),
        ],
      ),
    );
  }
}

class EditBottom extends StatefulWidget {
  /// 当前底部评论栏需要评论的信息
  final int bizType;

  final String bizId;

  final String pid;

  final String toUserId;

  final Function loadPictures;

  final TextEditingController commentEditController;

  final List<File> imageFileList;

  final Function refreshCallback;

  EditBottom(
      {@required this.loadPictures,
      @required this.commentEditController,
      @required this.bizType,
      @required this.bizId,
      @required this.toUserId,
      this.pid = '0',
      this.refreshCallback,
      this.imageFileList});

  @override
  _EditBottomState createState() => _EditBottomState();
}

class _EditBottomState extends State<EditBottom> {
  Widget _generateCommentEdit() {
    return Container(
      width: widget.imageFileList == null ? ScreenUtil().setWidth(560): ScreenUtil().setWidth(500),
      child: TextField(
        controller: widget.commentEditController,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) {
                return CommentInputBottomPage(
                  toUserId: widget.toUserId,
                  bizType: widget.bizType,
                  bizId: widget.bizId,
                  pid: widget.pid,
                  commentEditController: widget.commentEditController,
                  imageFileList: widget.imageFileList,
                  loadPictures: widget.loadPictures,
                  refreshCallback: widget.refreshCallback,
                );
              },
            ),
          );
        },
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: '请输入评论的内容',
          hintStyle:
              TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30)),
          isDense: true,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(10),
              horizontal: ScreenUtil().setWidth(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            gapPadding: 0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.01,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            gapPadding: 0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.01,
            ),
          ),
        ),
        minLines: 1,
        maxLines: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(100)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 0.05)),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(5), horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _generateCommentEdit(),
          ImageChooseButton(loadPictures: widget.loadPictures),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  String pictureList =
                      await ApiMethodUtil.uploadPictureGetString(
                          widget.imageFileList);
                  ToastUtil.showNoticeToast("评论发布中");
                  ResponseBean responseBean = await ApiMethodUtil.postComment(
                      pid: widget.pid,
                      bizId: widget.bizId,
                      toUserId: widget.toUserId,
                      content: widget.commentEditController.text,
                      bizType: widget.bizType,
                      pictureList: pictureList);
                  widget.commentEditController.clear();
                  widget.imageFileList.clear();
                  widget.refreshCallback();
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
