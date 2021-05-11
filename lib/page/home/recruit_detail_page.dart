import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/comment_empty.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/controller.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/editor.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/mode.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/scaffold.dart';
import 'package:far_away_flutter/page/post/post_recruit_page.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notus/notus.dart';
import 'dart:convert' as convert;
import 'package:quill_delta/quill_delta.dart';

import 'dynamic_comment_widget.dart';

class RecruitDetailPage extends StatefulWidget {
  final RecruitDetailInfoBean recruitDetailInfoBean;

  RecruitDetailPage({@required this.recruitDetailInfoBean});

  @override
  _RecruitDetailPageState createState() => _RecruitDetailPageState();
}

class _RecruitDetailPageState extends State<RecruitDetailPage> {
  ZefyrController markdownController;

  int currentPage = 1;

  List<CommentListBean> commentList = [];

  final ScrollController _controller = ScrollController();

  RecruitCommentController recruitCommentController =
      RecruitCommentController();

  @override
  void initState() {
    super.initState();
    var json = convert.jsonDecode(widget.recruitDetailInfoBean.content);
    markdownController = ZefyrController(NotusDocument.fromJson(json));
    _getRecruitDetail();
  }

  _getRecruitDetail() async {
    Response<dynamic> recruitDetailData = await ApiMethodUtil.getRecruitDetail(
        id: widget.recruitDetailInfoBean.id,
        token: ProviderUtil.globalInfoProvider.jwt);
    ResponseBean recruitResponseBean =
        ResponseBean.fromJson(recruitDetailData.data);
    RecruitDetailInfoBean recruitDetailInfoBean =
        RecruitDetailInfoBean.fromJson(recruitResponseBean.data);
    setState(() {
      widget.recruitDetailInfoBean.username = recruitDetailInfoBean.username;
      widget.recruitDetailInfoBean.userAvatar =
          recruitDetailInfoBean.userAvatar;
      widget.recruitDetailInfoBean.signature = recruitDetailInfoBean.signature;
      widget.recruitDetailInfoBean.commentsCount =
          recruitDetailInfoBean.commentsCount;
      widget.recruitDetailInfoBean.signUpCount =
          recruitDetailInfoBean.signUpCount;
    });
    recruitCommentController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenUtil().setHeight(80),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: RaisedButton(
            elevation: 0,
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
            child: Icon(FontAwesomeIcons.angleLeft),
          ),
          actions: [
            Container(
              width: ScreenUtil().setWidth(120),
              child: RaisedButton(
                padding: EdgeInsets.zero,
                elevation: 0,
                color: Colors.transparent,
                onPressed: () => Navigator.pop(context),
                child: Icon(FontAwesomeIcons.ellipsisH),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
                child: ZefyrScaffold(
                  child: ZefyrEditor(
                    bottomBouncing: false,
                    topBouncing: false,
                    useEasyRefresh: true,
                    scrollController: _controller,
                    firstRefresh: true,
                    firstRefreshWidget: Container(),
                    header: EasyRefreshWidget.refreshHeader,
                    footer: EasyRefreshWidget.refreshFooter,
                    onRefresh: () async {
                      _getRecruitDetail();
                    },
                    onLoad: () async {
                      recruitCommentController.refresh();
                    },
                    controller: markdownController,
                    focusNode: FocusNode(),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                    ),
                    mode: ZefyrMode.view,
                    imageDelegate: MarkdownImageDelegate(),
                    customAboveWidget: Container(
                        child: Column(
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(90),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(15)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                  child: Container(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.recruitDetailInfoBean.userAvatar,
                                  fit: BoxFit.cover,
                                ),
                              )),
                              Container(
                                width: ScreenUtil().setWidth(520),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.recruitDetailInfoBean.username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        widget.recruitDetailInfoBean.signature,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(15)),
                                child: Text(
                                  DateUtil.getSimpleDate(
                                      widget.recruitDetailInfoBean.publishTime),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(25),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.recruitDetailInfoBean.title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(40),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  child: CachedNetworkImage(
                                    height: ScreenUtil().setHeight(250),
                                    width: double.infinity,
                                    imageUrl:
                                        widget.recruitDetailInfoBean.cover,
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                      ],
                    )),
                    customBottomWidget: RecruitComment(
                      id: widget.recruitDetailInfoBean.id,
                      recruitCommentController: recruitCommentController,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 0.1))),
                  height: ScreenUtil().setHeight(80),
                  width: ScreenUtil().setWidth(750),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Icon(Icons.comment),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Icon(Icons.comment),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Icon(Icons.comment),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Icon(Icons.comment),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}

class RecruitComment extends StatefulWidget {
  final String id;

  final RecruitCommentController recruitCommentController;

  RecruitComment({@required this.id, this.recruitCommentController});

  @override
  _RecruitCommentState createState() => _RecruitCommentState();
}

class _RecruitCommentState extends State<RecruitComment> {
  int currentPage = 1;

  bool emptyData = false;

  List<CommentListBean> commentList = [];

  @override
  void initState() {
    widget.recruitCommentController.setState(this);
    super.initState();
  }

  refreshData() async {
    currentPage = 1;
    loadData();
  }

  loadData() async {
    Response<dynamic> data = await ApiMethodUtil.getCommentList(
        commentQueryParam: CommentQueryParam(
            businessType: 27, businessId: widget.id, currentPage: currentPage));
    ResponseBean response = ResponseBean.fromJson(data.data);
    PageBean pageBean = PageBean.fromJson(response.data);
    if (pageBean.list.isEmpty) {
      // 本身没有评论
      if (currentPage == 1) {
        setState(() {
          emptyData = true;
        });
        return;
      }
      ToastUtil.showNoticeToast("没有数据啦");
      return;
    }
    currentPage++;
    setState(() {
      for (int i = 0; i < pageBean.list.length; i++) {
        CommentListBean bean = CommentListBean.fromJson(pageBean.list[i]);
        commentList.add(bean);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 0.05)),
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            child: Text(
              '评论',
              style: TextStyleTheme.subH3,
            ),
          ),
          Container(
            child: commentList.isEmpty && emptyData
                ? Container(
                    child: CommentEmpty(
                      iconHeight: ScreenUtil().setHeight(500),
                      iconWidth: ScreenUtil().setWidth(750),
                    ),
                  )
                : Column(
                    children: List.generate(commentList.length, (commentIndex) {
                      return TogetherCommentWidget(
                        commentListBean: commentList[commentIndex],
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

class RecruitCommentController {
  _RecruitCommentState _state;

  void setState(_RecruitCommentState state) {
    if (this?._state == null) {
      this?._state = state;
    } else {
      this._state = null;
      this._state = state;
    }
  }

  refresh() {
    _state.loadData();
  }

  init() {
    _state.refreshData();
  }
}
