import 'dart:io';

import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/page/comment/children_comment_widget.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'comment_detail_widget.dart';
import 'comment_input_bottom_page.dart';

class CommentWidget extends StatelessWidget {
  final int bizType;

  final String bizId;

  final CommentListBean commentListBean;

  final List<File> imageFileList;

  final TextEditingController commentEditController;

  final Function loadPictures;

  final EdgeInsets padding;

  final Function refreshCallback;

  CommentWidget(
      {@required this.bizType,
      @required this.commentListBean,
      @required this.commentEditController,
      @required this.bizId,
      this.loadPictures,
      this.padding,
      this.refreshCallback,
      this.imageFileList});

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: InkWell(
        splashColor: Theme.of(context).backgroundColor,
        highlightColor: Theme.of(context).backgroundColor,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) {
                return CommentInputBottomPage(
                  avatar: commentListBean.fromUserAvatar,
                  content: commentListBean.content,
                  toUserId: commentListBean.fromUserId,
                  bizType: bizType,
                  bizId: bizId,
                  pid: commentListBean.id,
                  commentEditController: commentEditController,
                  imageFileList: imageFileList,
                  loadPictures: loadPictures,
                  refreshCallback: refreshCallback,
                );
              },
            ),
          );
        },
        child: Container(
          padding: padding != null ? padding : EdgeInsets.zero,
          child: Column(
            children: [
              CommentDetailWidget(
                avatar: commentListBean.fromUserAvatar,
                username: commentListBean.fromUsername,
                publishTime: commentListBean.publishTime,
                content: commentListBean.content,
                pictureList: _getPictureList(commentListBean.pictureUrlList),
              ),
              commentListBean.children.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(100),
                      ),
                      child: Ink(
                        color: Theme.of(context).backgroundColor,
                        child: InkWell(
                          onTap: () {
                            showMaterialModalBottomSheet(
                                backgroundColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                context: context,
                                builder: (context) =>
                                    ProviderUtil.getCommentDrawPage(
                                        commentListBean: commentListBean,
                                        bizType: bizType,
                                        bizId: bizId,
                                      containsImage: imageFileList != null,
                                    ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: ChildrenCommentWidget(
                              bizId: bizId,
                              bizType: bizType,
                              parentComment: commentListBean,
                              commentEditController: commentEditController,
                              imageFileList: imageFileList,
                              loadPictures: loadPictures,
                              refreshCallback: refreshCallback,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
