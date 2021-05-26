import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/comment_empty.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'dynamic_comment_widget.dart';
import 'dynamic_detail_widget.dart';

class DynamicDetailComponent extends StatefulWidget {
  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final DynamicDetailBean dynamicDetailBean;

  DynamicDetailComponent(
      {this.scrollToComment, this.avatarHeroTag, this.dynamicDetailBean});

  @override
  _DynamicDetailComponentState createState() => _DynamicDetailComponentState();
}

class _DynamicDetailComponentState extends State<DynamicDetailComponent> {
  final GlobalKey _globalKey = GlobalKey();

  final ScrollController _controller = ScrollController();

  List<CommentListBean> commentList = [];

  bool hasLoadData = false;

  bool emptyData = false;

  int currentPage = 1;

  Function _dataRefresh;

  bool scrollToComment;

  @override
  void initState() {
    super.initState();
    scrollToComment = widget.scrollToComment;
    _dataRefresh = () async {
      commentList = [];
      currentPage = 1;
      await _loadCommentListData();
      if (scrollToComment) {
        WidgetsBinding.instance.addPostFrameCallback(_scrollToCommentList);
        scrollToComment = false;
      }
    };
  }

  // 跳转到评论列表
  void _scrollToCommentList(_) {
    RenderBox box = _globalKey.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    double animateHeight = 0.0;
    if (offset.dy == MediaQueryData.fromWindow(window).padding.top + 56.0) {
      return;
    }
    animateHeight = _controller.offset +
        offset.dy -
        MediaQueryData.fromWindow(window).padding.top -
        56.0;
    _controller.animateTo(animateHeight,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  _loadCommentListData() async {
    if (hasLoadData) {
      ResponseBean responseBean =
          await ApiMethodUtil.getDynamicDetail(
              id: widget.dynamicDetailBean.id,
              token: ProviderUtil.globalInfoProvider.jwt);
      DynamicDetailBean dynamicDetailBean =
          DynamicDetailBean.fromJson(responseBean.data);
      setState(() {
        widget.dynamicDetailBean.username = dynamicDetailBean.username;
        widget.dynamicDetailBean.userAvatar = dynamicDetailBean.userAvatar;
        widget.dynamicDetailBean.signature = dynamicDetailBean.signature;
        widget.dynamicDetailBean.thumbed = dynamicDetailBean.thumbed;
        widget.dynamicDetailBean.thumbCount = dynamicDetailBean.thumbCount;
        widget.dynamicDetailBean.commentsCount =
            dynamicDetailBean.commentsCount;
        widget.dynamicDetailBean.collected = dynamicDetailBean.collected;
      });
    }
    hasLoadData = true;
    ResponseBean responseBean = await ApiMethodUtil.getCommentList(
        commentQueryParam: CommentQueryParam(
            businessType: 2,
            businessId: widget.dynamicDetailBean.id,
            currentPage: currentPage));
    PageBean pageBean = PageBean.fromJson(responseBean.data);
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
    return EasyRefresh(
        scrollController: _controller,
        firstRefresh: true,
        firstRefreshWidget: Container(),
        header: EasyRefreshWidget.refreshHeader,
        footer: EasyRefreshWidget.refreshFooter,
        onRefresh: _dataRefresh,
        onLoad: () async {
          await _loadCommentListData();
        },
        child: Column(
          children: [
            DynamicDetailWidget(
              dynamicDetailBean: widget.dynamicDetailBean,
              avatarHeroTag: widget.avatarHeroTag,
            ),
            Container(
              color: Colors.grey[100],
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22)),
              child: Column(
                children: [
                  Container(
                    key: _globalKey,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.05)),
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
                              iconHeight: ScreenUtil().setHeight(350),
                              iconWidth: ScreenUtil().setWidth(750),
                            ),
                          )
                        : Column(
                            children: List.generate(commentList.length,
                                (commentIndex) {
                              return DynamicCommentWidget(
                                commentListBean: commentList[commentIndex],
                              );
                            }),
                          ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
