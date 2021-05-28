import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/measure_size.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/page/comment/parent_comment_detail_widget.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/asset_picker_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'file:///I:/flutter/new_travel/far_away_flutter/lib/page/comment/comment_bottom.dart';

import 'comment_input_bottom_page.dart';

class CommentDrawPage extends StatefulWidget {
  final int bizType;

  final String bizId;

  final CommentListBean comment;

  final bool containsImage;

  CommentDrawPage({
    @required this.comment,
    @required this.bizId,
    @required this.bizType,
    this.containsImage = true
  });

  @override
  _CommentDrawPageState createState() => _CommentDrawPageState();
}

class _CommentDrawPageState extends State<CommentDrawPage> {

  TextEditingController _commentEditController = TextEditingController();

  List<File> imageFileList = [];

  double bottomMargin = ScreenUtil().setHeight(100);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(50), bottom: bottomMargin),
            height: ScreenUtil().setHeight(1100),
            width: ScreenUtil().setWidth(750),
            child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) {
                                  return CommentInputBottomPage(
                                    bizType: widget.bizType,
                                    bizId: widget.bizId,
                                    avatar: widget.comment.fromUserAvatar,
                                    content: widget.comment.content,
                                    toUserId: widget.comment.fromUserId,
                                    pid: widget.comment.id,
                                    commentEditController: _commentEditController,
                                    imageFileList: widget.containsImage ? imageFileList : null,
                                    loadPictures: widget.containsImage ? _loadPictures : null,
                                    refreshCallback: _refreshCallback,
                                  );
                                },
                              ),
                            );
                          },
                          highlightColor: Theme.of(context).backgroundColor,
                          splashColor: Theme.of(context).backgroundColor,
                          child: ParentCommentDetailWidget(
                            commentListBean: widget.comment,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: ScreenUtil().setWidth(22)),
                      width: double.infinity,
                      child: Text(
                        '共${widget.comment.children.length}条回复',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: List.generate(
                          widget.comment.children.length,
                          (index) {
                            return Ink(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) {
                                        return CommentInputBottomPage(
                                          avatar: widget.comment.children[index]
                                              .fromUserAvatar,
                                          content: widget
                                              .comment.children[index].content,
                                          toUserId: widget.comment
                                              .children[index].fromUserId,
                                          bizId: widget.bizId,
                                          bizType: widget.bizType,
                                          pid: widget.comment.id,
                                          commentEditController:
                                              _commentEditController,
                                          refreshCallback: _refreshCallback,
                                          imageFileList: widget.containsImage ? imageFileList : null,
                                          loadPictures: widget.containsImage ? _loadPictures : null,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20),
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(90),
                                        child: ClipOval(
                                            child: CachedNetworkImage(
                                          imageUrl: widget.comment
                                              .children[index].fromUserAvatar,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                      Container(
                                        width: ScreenUtil().setWidth(520),
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    widget
                                                        .comment
                                                        .children[index]
                                                        .fromUsername,
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: ScreenUtil()
                                                          .setSp(30),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Container(
                                              child: Text(
                                                DateUtil.getTimeString(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        widget
                                                            .comment
                                                            .children[index]
                                                            .publishTime)),
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize:
                                                      ScreenUtil().setSp(25),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: ScreenUtil()
                                                      .setHeight(8)),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: widget
                                                                  .comment
                                                                  .children[
                                                                      index]
                                                                  .toUserId ==
                                                              widget.comment
                                                                  .fromUserId
                                                          ? ''
                                                          : '回复 ',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  TextSpan(
                                                      text: widget
                                                                  .comment
                                                                  .children[
                                                                      index]
                                                                  .toUserId ==
                                                              widget.comment
                                                                  .fromUserId
                                                          ? ''
                                                          : '${widget.comment.children[index].toUsername}: ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blueAccent)),
                                                  TextSpan(
                                                    text: widget
                                                        .comment
                                                        .children[index]
                                                        .content,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: ScreenUtil()
                                                          .setSp(28),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 5
                                              ),
                                              child: MediaPreview(
                                                flex: false,
                                                rowCount: 3,
                                                mediaList: List.generate(
                                                    _getPictureList(widget
                                                            .comment
                                                            .children[index]
                                                            .pictureUrlList)
                                                        .length,
                                                    (i) => MediaList(
                                                        type: 1,
                                                        url: _getPictureList(widget
                                                                .comment
                                                                .children[index]
                                                                .pictureUrlList)[
                                                            i])),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(750),
            child: Center(
              child: Text(
                '乏味',
                style: TextStyle(
                  fontFamily: AssetProperties.FZ_SIMPLE,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(36),
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: MeasureSize(
            child: CommentBottom(
              bizType: widget.bizType,
              bizId: widget.bizId,
              toUserId: widget.comment.fromUserId,
              imageFileList: widget.containsImage ? imageFileList : null,
              commentEditController: _commentEditController,
              pid: widget.comment.id,
              loadPictures: widget.containsImage ? _loadPictures :null,
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
    );
  }
}
