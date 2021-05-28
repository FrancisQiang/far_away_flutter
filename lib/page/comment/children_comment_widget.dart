
import 'dart:io';

import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class ChildrenCommentWidget extends StatelessWidget {

  final String bizId;

  final int bizType;

  final CommentListBean parentComment;

  final TextEditingController commentEditController;

  final List<File> imageFileList;

  final Function loadPictures;

  final Function refreshCallback;

  ChildrenCommentWidget(
      {@required this.parentComment, this.refreshCallback, @required this.bizType, @required this.bizId, this.commentEditController, this.imageFileList, this.loadPictures});

  Widget generateChildComment(CommentListBean item, context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 2,
      ),
      alignment: Alignment.centerLeft,
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(children: [
          TextSpan(
            text: item.toUserId == item.fromUserId
                ? '${item.fromUsername}: '
                : '${item.fromUsername} ',
            style: TextStyle(
                color: Colors.blueAccent, fontSize: ScreenUtil().setSp(25)),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("点击了");
              },
          ),
          TextSpan(
            text: item.toUserId == item.fromUserId
                ? ''
                : ' 回复 ${item.toUsername}: ',
            style: TextStyle(
                color: Colors.black54, fontSize: ScreenUtil().setSp(25)),
          ),
          TextSpan(
            text: item.content,
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(25),
                letterSpacing: 0.4),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CommentListBean> childrenList = parentComment.children;
    int showLength = childrenList.length > 2 ? 2 : childrenList.length;
    List<Widget> childrenWidget = List<Widget>.generate(showLength, (index) {
      return generateChildComment(childrenList[index], context);
    });
    if (childrenList.length > 2) {
      childrenWidget.add(Container(
        margin: EdgeInsets.only(top: 2),
        child: Text(
          '查看全部${childrenList.length}条评论',
          style: TextStyle(
              color: Colors.blueAccent, fontSize: ScreenUtil().setSp(25)),
        ),
      ));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: childrenWidget),
    );
  }
}