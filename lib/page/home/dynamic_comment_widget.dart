import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
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
            dynamicCommentChosenProvider.targetUserId = commentListBean.fromUserId;
            dynamicCommentChosenProvider.targetUsername = commentListBean.fromUsername;
            dynamicCommentChosenProvider.refresh();
          },
          child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(100),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: commentListBean.fromUserAvatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                child: SpinKitPumpingHeart(
                                  color: Theme.of(context).primaryColor,
                                  size: ScreenUtil().setSp(40),
                                  duration: Duration(milliseconds: 2000),
                                ),
                              ),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.error,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
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
                                          commentListBean.fromUsername,
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
                                                CalculateUtil.simplifyCount(
                                                    commentListBean.thumbCount),
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
                                      DateTime.fromMillisecondsSinceEpoch(
                                          commentListBean.publishTime)),
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: ScreenUtil().setSp(20)),
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                                child: Text(
                                  commentListBean.content,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(25),
                                      letterSpacing: 0.4),
                                ),
                              ),
                              _getPictureList(commentListBean.pictureUrlList)
                                  .length ==
                                  0
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
                                      children: List.generate(
                                          _getPictureList(
                                              commentListBean.pictureUrlList)
                                              .length, (pictureIndex) {
                                        return Container(
                                          width: ScreenUtil().setWidth(180),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            child: CachedNetworkImage(
                                              imageUrl: _getPictureList(
                                                  commentListBean
                                                      .pictureUrlList)[
                                              pictureIndex],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                    width: ScreenUtil().setWidth(180),
                                                    height:
                                                    ScreenUtil().setWidth(180),
                                                    alignment: Alignment.center,
                                                    child: SpinKitPumpingHeart(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: ScreenUtil().setSp(40),
                                                      duration: Duration(
                                                          milliseconds: 2000),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                  ),
                  commentListBean.children.isNotEmpty ? Container(
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
                    child: Column(
                        children: List.generate(
                            commentListBean.children.length > 2
                                ? 2
                                : commentListBean.children.length, (childIndex) {
                          if (commentListBean.childrenListSize > 2 && childIndex == 1) {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      dynamicCommentChosenProvider.targetUsername = commentListBean.children[childIndex].fromUsername;
                                      if (commentListBean.children[childIndex].parentId != "0") {
                                        dynamicCommentChosenProvider.pid = commentListBean.children[childIndex].parentId;
                                      } else {
                                        dynamicCommentChosenProvider.pid = commentListBean.children[childIndex].id;
                                      }
                                      dynamicCommentChosenProvider.targetUserId = commentListBean.children[childIndex].fromUserId;
                                      dynamicCommentChosenProvider.refresh();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: commentListBean
                                                  .children[childIndex].toUserId ==
                                                  commentListBean.fromUserId
                                                  ? '${commentListBean.children[childIndex].fromUsername}: '
                                                  : '${commentListBean.children[childIndex].fromUsername} ',
                                              style: TextStyle(color: Colors.blueAccent),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print("点击了");
                                                }),
                                          TextSpan(
                                            text: commentListBean
                                                .children[childIndex].toUserId ==
                                                commentListBean.fromUserId
                                                ? ''
                                                : ' 回复 ${commentListBean.children[childIndex].toUsername}: ',
                                            style: TextStyle(color: Colors.black54),
                                          ),
                                          TextSpan(
                                              text: commentListBean
                                                  .children[childIndex].content,
                                              style: TextStyle(color: Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                          backgroundColor: Colors.grey[100],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15))),
                                          context: context,
                                          builder: (context) => ProviderUtil.getCommentDrawWidget(commentListBean)
                                      );
                                    },
                                    child: Container(
                                      child: Text(
                                        '查看全部${commentListBean.childrenListSize}条评论',
                                        style: TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              dynamicCommentChosenProvider.targetUsername = commentListBean.children[childIndex].fromUsername;
                              if (commentListBean.children[childIndex].parentId != "0") {
                                dynamicCommentChosenProvider.pid = commentListBean.children[childIndex].parentId;
                              } else {
                                dynamicCommentChosenProvider.pid = commentListBean.children[childIndex].id;
                              }
                              dynamicCommentChosenProvider.targetUserId = commentListBean.children[childIndex].fromUserId;
                              dynamicCommentChosenProvider.refresh();
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: commentListBean.children[childIndex].toUserId ==
                                          commentListBean.fromUserId
                                          ? '${commentListBean.children[childIndex].fromUsername}: '
                                          : '${commentListBean.children[childIndex].fromUsername} ',
                                      style: TextStyle(color: Colors.blueAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print("点击了");
                                        }),
                                  TextSpan(
                                    text: commentListBean.children[childIndex].toUserId ==
                                        commentListBean.fromUserId
                                        ? ''
                                        : ' 回复 ${commentListBean.children[childIndex].toUsername}: ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                      text: commentListBean.children[childIndex].content,
                                      style: TextStyle(color: Colors.black))
                                ]),
                              ),
                            ),
                          );
                        })),
                  ) : SizedBox()
                ],
              )),
        );
      },
    );
  }
}
