import 'dart:io';

import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'image_choose_button.dart';

class CommentInputBottomPage extends StatefulWidget {

  /// 评论业务类型
  final String bizType;

  /// 回复用户的头像
  final String avatar;

  /// 回复评论的内容
  final String content;

  /// 业务id
  final String bizId;

  /// 回复目标用户
  final String toUserId;

  /// pid
  final String pid;

  /// 评论内容控制器
  final TextEditingController commentEditController;

  /// 评论图片列表
  final List<File> imageFileList;

  /// 设置图片回调函数
  final Function loadPictures;

  final Function refreshCallback;

  CommentInputBottomPage(
      {@required this.bizType,
        @required this.toUserId,
        @required this.pid,
        @required this.commentEditController,
        @required this.bizId,
        this.avatar,
        this.content,
        this.imageFileList,
        this.refreshCallback,
        this.loadPictures});


  @override
  _CommentInputBottomPageState createState() => _CommentInputBottomPageState();
}

class _CommentInputBottomPageState extends State<CommentInputBottomPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.35),
        body: Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              widget.imageFileList != null && widget.imageFileList.isNotEmpty
                  ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 2)
                  ],
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10)),
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
                                  BoxShadow(
                                      color: Colors.grey, blurRadius: 1)
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
                  : SizedBox(),
              widget.pid != '0' && widget.avatar != null && widget.content != null
                  ? Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(22), vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(60),
                      child: ClipOval(
                        child: Image.network(
                          widget.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(550),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(15)),
                      child: Text(
                        widget.content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              )
                  : SizedBox(),
              Container(
                constraints:
                BoxConstraints(minHeight: ScreenUtil().setHeight(100)),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(5), horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 0.08),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: widget.loadPictures == null ? ScreenUtil().setWidth(560) : ScreenUtil().setWidth(500),
                      child: TextField(
                        cursorColor: Colors.orangeAccent,
                        controller: widget.commentEditController,
                        autofocus: true,
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: '请输入评论的内容',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(30)),
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
                    ),
                    Expanded(
                      child: ImageChooseButton(loadPictures: ()async {
                        await widget.loadPictures();
                        setState(() {});
                      }),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            String pictureList = '';
                            if(widget.imageFileList != null && widget.imageFileList.isNotEmpty) {
                              pictureList = await ApiMethodUtil.uploadPictureGetString(widget.imageFileList);
                            }
                            ToastUtil.showNoticeToast("评论发布中");
                            ResponseBean responseBean = await ApiMethodUtil.postComment(
                              pid: widget.pid,
                              bizId: widget.bizId,
                              toUserId: widget.toUserId,
                              content: widget.commentEditController.text,
                              bizType: widget.bizType,
                              pictureList: pictureList,
                            );
                            widget.commentEditController.clear();
                            widget.imageFileList?.clear();
                            widget.refreshCallback();
                            Navigator.pop(context);
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
              )
            ],
          ),
        ));
  }
}
