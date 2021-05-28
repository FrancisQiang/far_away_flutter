import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/properties/asset_properties.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../comment/comment_bottom.dart';

class CommentDrawWidget extends StatefulWidget {
  final CommentListBean comment;

  CommentDrawWidget({@required this.comment});

  @override
  _CommentDrawWidgetState createState() => _CommentDrawWidgetState();
}

class _CommentDrawWidgetState extends State<CommentDrawWidget> {

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
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
            child: SingleChildScrollView(
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
                            List.generate(widget.comment.children.length, (index) {
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
                                  widget.comment.children[index].fromUserAvatar,
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
                                          widget.comment.children[index]
                                              .fromUsername,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: ScreenUtil().setSp(26),
                                              letterSpacing: 0.4),
                                        ),
                                      ),
                                    ],
                                  )),
                                  Container(
                                    child: Text(
                                      DateUtil.getTimeString(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              widget.comment.children[index]
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
                                            text: widget.comment.children[index]
                                                        .toUserId ==
                                                    widget.comment.fromUserId
                                                ? ''
                                                : '回复 ',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: widget.comment.children[index]
                                                        .toUserId ==
                                                    widget.comment.fromUserId
                                                ? ''
                                                : '${widget.comment.children[index].toUsername}: ',
                                            style: TextStyle(
                                                color: Colors.blueAccent)),
                                        TextSpan(
                                            text: widget.comment.children[index]
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
                                              widget.comment.children[index]
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
