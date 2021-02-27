import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/param/children_comment_query_param.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'comment_bottom.dart';

class CommentDrawWidget extends StatefulWidget {
  final CommentListBean comment;

  CommentDrawWidget({@required this.comment});

  @override
  _CommentDrawWidgetState createState() => _CommentDrawWidgetState();
}

class _CommentDrawWidgetState extends State<CommentDrawWidget> {
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

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
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
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
            height: ScreenUtil().setHeight(1150),
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  width: ScreenUtil().setWidth(80),
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.comment.fromUserAvatar,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Row(
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.comment.fromUsername,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25),
                                                letterSpacing: 0.6,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    )),
                                    Container(
                                      child: Text(
                                        DateUtil.getTimeString(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                widget.comment.publishTime)),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(20),
                                          color: Colors.black45,
                                          letterSpacing: 0.5,
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
                            top: ScreenUtil().setHeight(15),
                            right: ScreenUtil().setWidth(20),
                          ),
                          child: Text(
                            widget.comment.content,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: ScreenUtil().setSp(26)),
                          ),
                        ),
                        _getPictureList(widget.comment.pictureUrlList).length ==
                                0
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(15),
                                ),
                                width: ScreenUtil().setWidth(750),
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: ScreenUtil().setWidth(8),
                                    runSpacing: ScreenUtil().setHeight(10),
                                    children: List.generate(
                                        _getPictureList(
                                                widget.comment.pictureUrlList)
                                            .length, (pictureIndex) {
                                      return Container(
                                        width: ScreenUtil().setWidth(225),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Image.network(
                                            _getPictureList(widget.comment
                                                .pictureUrlList)[pictureIndex],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }))),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.thumbsUp,
                                        size: ScreenUtil().setSp(30),
                                        color: true
                                            ? Colors.deepOrangeAccent
                                            : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        ' 10',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(25),
                                            letterSpacing: 0.2,
                                            color: true
                                                ? Colors.deepOrangeAccent
                                                : Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.commentDots,
                                        size: ScreenUtil().setSp(32),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '  ${CalculateUtil.simplifyCount(widget.comment.childrenListSize)}',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(25),
                                            letterSpacing: 0.2),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Icon(
                                  FontAwesomeIcons.share,
                                  size: ScreenUtil().setSp(30),
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(10),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '回复',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(26),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                    child: Column(
                        children:
                            List.generate(childrenCommentList.length, (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20)),
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(80),
                              child: ClipOval(
                                child: Image.network(
                                  childrenCommentList[index].fromUserAvatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(560),
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontSize: ScreenUtil().setSp(26),
                                              letterSpacing: 0.4),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          children: [
                                            Container(
                                              child: Text(
                                                CalculateUtil.simplifyCount(
                                                    childrenCommentList[index]
                                                        .thumbCount),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize:
                                                        ScreenUtil().setSp(22)),
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
                                              childrenCommentList[index]
                                                  .publishTime)),
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: ScreenUtil().setSp(20)),
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
                                                    widget.comment.fromUserId
                                                ? ''
                                                : '回复 ',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: childrenCommentList[index]
                                                        .toUserId ==
                                                    widget.comment.fromUserId
                                                ? ''
                                                : '${childrenCommentList[index].toUsername}: ',
                                            style: TextStyle(
                                                color: Colors.blueAccent)),
                                        TextSpan(
                                            text: childrenCommentList[index]
                                                .content,
                                            style:
                                                TextStyle(color: Colors.black))
                                      ]),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 5
                                    ),
                                    child: Builder(builder: (context) {
                                      List<String> pictureList =
                                          _getPictureList(
                                              childrenCommentList[index]
                                                  .pictureUrlList);
                                      return MediaPreview(
                                          mediaList: List.generate(
                                              pictureList.length,
                                              (index) => MediaList(
                                                  type: 1,
                                                  url: pictureList[index])));
                                    }),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(100),
                  )
                ],
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
                          topRight: Radius.circular(15)))),
              height: ScreenUtil().setHeight(80),
              width: ScreenUtil().setWidth(750),
              child: Center(
                child: Text(
                  '乏味',
                  style: TextStyle(
                      fontFamily: AssetProperties.FZ_SIMPLE,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(36),
                      letterSpacing: 3),
                ),
              )),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: CommentBottom(),
        )
      ],
    );
  }
}
