import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/component/avatar_component.dart';
import 'package:far_away_flutter/component/image_error_widget.dart';
import 'package:far_away_flutter/component/image_holder.dart';
import 'package:far_away_flutter/provider/dynamic_comment_chosen_provider.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'comment_draw_widget.dart';

class DynamicCommentWidget extends StatelessWidget {
  final CommentListBean commentListBean;

  DynamicCommentWidget({this.commentListBean});

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicCommentChosenProvider>(
      builder: (context, dynamicCommentChosenProvider, child) {
        return GestureDetector(
          onTap: () {
            dynamicCommentChosenProvider.pid = commentListBean.id;
            dynamicCommentChosenProvider.targetUserId =
                commentListBean.fromUserId;
            dynamicCommentChosenProvider.targetUsername =
                commentListBean.fromUsername;
            dynamicCommentChosenProvider.refresh();
          },
          child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  CommentDetailWidget(
                    avatar: commentListBean.fromUserAvatar,
                    username: commentListBean.fromUsername,
                    publishTime: commentListBean.publishTime,
                    thumbCount: commentListBean.thumbCount,
                    content: commentListBean.content,
                    pictureList:
                    _getPictureList(commentListBean.pictureUrlList),
                  ),
                  commentListBean.children.isNotEmpty
                      ? Container(
                    width: ScreenUtil().setWidth(550),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(90),
                        top: ScreenUtil().setHeight(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(15),
                        vertical: ScreenUtil().setHeight(10)),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: ChildrenCommentPreviewWidget(
                        parentComment: commentListBean),
                  )
                      : SizedBox()
                ],
              )),
        );
      },
    );
  }
}

class CommentDetailWidget extends StatelessWidget {
  final String avatar;

  final String username;

  final int publishTime;

  final int thumbCount;

  final String content;

  final List<String> pictureList;

  CommentDetailWidget({@required this.avatar,
    @required this.username,
    @required this.publishTime,
    @required this.thumbCount,
    @required this.content,
    @required this.pictureList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarComponent(avatar,
              sideLength: ScreenUtil().setWidth(100),
              holderSize: ScreenUtil().setSp(30),
              errorWidgetSize: ScreenUtil().setSp(30)),
          Container(
            width: ScreenUtil().setWidth(560),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            username,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(26),
                                letterSpacing: 0.4),
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Container(
                                child: Text(
                                  CalculateUtil.simplifyCount(thumbCount),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: ScreenUtil().setSp(22)),
                                ),
                              ),
                              Container(
                                child: Icon(
                                  FontAwesomeIcons.thumbsUp,
                                  color: Colors.black54,
                                  size: ScreenUtil().setSp(30),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                Container(
                  child: Text(
                    DateUtil.getTimeString(
                        DateTime.fromMillisecondsSinceEpoch(publishTime)),
                    style: TextStyle(
                        color: Colors.black38,
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                  child: Text(
                    content,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(25), letterSpacing: 0.4),
                  ),
                ),
                pictureList.length == 0
                    ? SizedBox()
                    : Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                    ),
                    width: ScreenUtil().setWidth(750),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: ScreenUtil().setWidth(5),
                        runSpacing: ScreenUtil().setHeight(10),
                        children: List.generate(pictureList.length,
                                (pictureIndex) {
                              return Container(
                                width: ScreenUtil().setWidth(180),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  child: CachedNetworkImage(
                                    imageUrl: pictureList[pictureIndex],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(
                                          width: ScreenUtil().setWidth(180),
                                          height: ScreenUtil().setWidth(180),
                                          alignment: Alignment.center,
                                          child: SpinKitPumpingHeart(
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                            size: ScreenUtil().setSp(40),
                                            duration: Duration(
                                                milliseconds: 2000),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                    new Icon(
                                      Icons.error,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              );
                            }))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChildrenCommentPreviewWidget extends StatelessWidget {

  final CommentListBean parentComment;

  ChildrenCommentPreviewWidget({this.parentComment});

  Widget generateChildComment(item, dynamicCommentChosenProvider) {
    return GestureDetector(
      onTap: () {
        dynamicCommentChosenProvider.targetUsername = item.fromUsername;
        if (item.parentId != "0") {
          dynamicCommentChosenProvider.pid = item.parentId;
        } else {
          dynamicCommentChosenProvider.pid = item.id;
        }
        dynamicCommentChosenProvider.targetUserId = item.fromUserId;
        dynamicCommentChosenProvider.refresh();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          text: TextSpan(children: [
            TextSpan(
                text: item.toUserId == item.fromUserId ? '${item.fromUsername}: ' : '${item.fromUsername} ',
                style: TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()..onTap = () {
                    print("点击了");
                  }),
            TextSpan(
              text: item.toUserId == item.fromUserId ? '' : ' 回复 ${item.toUsername}: ',
              style: TextStyle(color: Colors.black54),
            ),
            TextSpan(text: item.content, style: TextStyle(color: Colors.black))
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicCommentChosenProvider>(
      builder: (context, dynamicCommentChosenProvider, child) {
        List<CommentListBean> childrenList = parentComment.children;
        int showLength = childrenList.length > 2 ? 2 : childrenList.length;
        List<Widget> childrenWidget = List<Widget>.generate(
            showLength, (index) {
              return generateChildComment(childrenList[index], dynamicCommentChosenProvider);
        });
        if (childrenList.length > 2) {
          childrenWidget.add(GestureDetector(
            onTap: () {
              showMaterialModalBottomSheet(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  context: context,
                  builder: (context) =>
                      ProviderUtil.getCommentDrawWidget(parentComment));
            },
            child: Container(
              child: Text(
                '查看全部${childrenList.length}条评论',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: childrenWidget
        );
      },
    );
  }
}
