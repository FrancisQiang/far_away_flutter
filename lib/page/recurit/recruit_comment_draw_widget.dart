import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/page/home/comment_bottom.dart';
import 'package:far_away_flutter/param/children_comment_query_param.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'comment_input_bottom_page.dart';

class RecruitCommentDrawWidget extends StatefulWidget {
  final String bizId;

  final TextEditingController commentEditController;

  final CommentListBean comment;

  RecruitCommentDrawWidget(
      {@required this.comment,
      @required this.bizId,
      @required this.commentEditController});

  @override
  _RecruitCommentDrawWidgetState createState() =>
      _RecruitCommentDrawWidgetState();
}

class _RecruitCommentDrawWidgetState extends State<RecruitCommentDrawWidget> {
  Function _firstRefresh;

  int currentPage = 1;

  List<CommentListBean> childrenCommentList = [];

  _loadChildrenCommentListData() async {
    Response<dynamic> data = await ApiMethodUtil.getChildrenCommentList(
        childrenCommentQueryParam: ChildrenCommentQueryParam(
            parentId: widget.comment.id, currentPage: currentPage));
    ResponseBean response = ResponseBean.fromJson(data.data);
    PageBean pageBean = PageBean.fromJson(response.data);
    if (pageBean.list.isEmpty) {
      Fluttertoast.showToast(
          msg: "没有数据啦",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: ScreenUtil().setSp(25));
      return;
    }
    currentPage++;
    setState(() {
      for (int i = 0; i < pageBean.list.length; i++) {
        CommentListBean bean = CommentListBean.fromJson(pageBean.list[i]);
        childrenCommentList.add(bean);
      }
      _firstRefresh = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _firstRefresh = () async {
      childrenCommentList = [];
      currentPage = 1;
      await _loadChildrenCommentListData();
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
          height: ScreenUtil().setHeight(1150),
          width: ScreenUtil().setWidth(750),
          child: EasyRefresh(
            topBouncing: false,
            firstRefresh: true,
            firstRefreshWidget: Container(),
            footer: EasyRefreshWidget.refreshFooter,
            onRefresh: _firstRefresh,
            onLoad: () async {
              await _loadChildrenCommentListData();
            },
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) {
                          return CommentInputBottomPage(
                            avatar: widget.comment.fromUserAvatar,
                            content: widget.comment.content,
                            toUserId: widget.comment.fromUserId,
                            bizId: widget.bizId,
                            pid: widget.comment.id,
                            controller: widget.commentEditController,
                          );
                        },
                      ),
                    );
                  },
                  highlightColor: Colors.orangeAccent.withOpacity(0.2),
                  splashColor: Colors.orangeAccent.withOpacity(0.4),
                  child: Container(
                    color: Colors.white70,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20), vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                  width: ScreenUtil().setWidth(90),
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.comment.fromUserAvatar,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: ScreenUtil().setWidth(520),
                                            child: Text(
                                              widget.comment.fromUsername,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Image.asset(
                                              'assets/png/three_dots.png',
                                              width: ScreenUtil().setWidth(45),
                                              height: ScreenUtil().setWidth(40),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        DateUtil.getTimeString(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                widget.comment.publishTime)),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(25),
                                          color: Colors.black45,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(20),
                            right: ScreenUtil().setWidth(20),
                          ),
                          child: Text(
                            widget.comment.content,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.2))),
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(10),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    '共xxx条回复',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: List.generate(
                      childrenCommentList.length,
                      (index) {
                        return InkWell(
                          highlightColor: Colors.orangeAccent.withOpacity(0.2),
                          splashColor: Colors.orangeAccent.withOpacity(0.4),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) {
                                  return CommentInputBottomPage(
                                    avatar: childrenCommentList[index].fromUserAvatar,
                                    content: childrenCommentList[index].content,
                                    toUserId: childrenCommentList[index].fromUserId,
                                    bizId: widget.bizId,
                                    pid: widget.comment.id,
                                    controller: widget.commentEditController,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: ScreenUtil().setWidth(90),
                                  child: ClipOval(
                                    child: Image.network(
                                      childrenCommentList[index].fromUserAvatar,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                          // width: double.infinity,
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              childrenCommentList[index]
                                                  .fromUsername,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                      Container(
                                        child: Text(
                                          DateUtil.getTimeString(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  childrenCommentList[index]
                                                      .publishTime)),
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: ScreenUtil().setSp(25),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(8)),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: childrenCommentList[index]
                                                            .toUserId ==
                                                        widget
                                                            .comment.fromUserId
                                                    ? ''
                                                    : '回复 ',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: childrenCommentList[index]
                                                            .toUserId ==
                                                        widget
                                                            .comment.fromUserId
                                                    ? ''
                                                    : '${childrenCommentList[index].toUsername}: ',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            TextSpan(
                                              text: childrenCommentList[index]
                                                  .content,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Image.asset(
                                    'assets/png/three_dots.png',
                                    width: ScreenUtil().setWidth(45),
                                    height: ScreenUtil().setWidth(40),
                                  ),
                                ),
                              ],
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
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
            height: ScreenUtil().setHeight(60),
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
      ],
    );
  }
}
