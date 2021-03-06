import 'dart:ui';

import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:far_away_flutter/component/comment_empty.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/constant/avatar_action.dart';
import 'package:far_away_flutter/constant/biz_type.dart';
import 'package:far_away_flutter/page/comment/comment_widget.dart';
import 'package:far_away_flutter/page/together/together_info_preview_widget.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';


class TogetherDetailComponent extends StatefulWidget {
  // 是否滚动到评论页
  final bool scrollToComment;

  // 头像转场动画
  final String avatarHeroTag;

  // 动态详情
  final TogetherInfoBean togetherInfoBean;

  final TextEditingController commentEditController;

  final Function refreshCallback;

  TogetherDetailComponent(
      {this.scrollToComment, this.avatarHeroTag, this.togetherInfoBean, this.commentEditController, this.refreshCallback});

  @override
  _TogetherDetailComponentState createState() =>
      _TogetherDetailComponentState();
}

class _TogetherDetailComponentState extends State<TogetherDetailComponent> {
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
    scrollToComment = widget.scrollToComment;
    _dataRefresh = () async {
      commentList = [];
      currentPage = 1;
      await _loadCommentListData();
      // 等待数据刷新之后进行滚动，否则无法滚动
      // 主要原因是会进行两次刷新，第二次刷新会覆盖掉前面的滚动动作
      if (scrollToComment) {
        WidgetsBinding.instance.addPostFrameCallback(_scrollToCommentList);
        scrollToComment = false;
      }
    };
    super.initState();
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
    if(animateHeight > _controller.position.maxScrollExtent) {
      animateHeight = _controller.position.maxScrollExtent;
    }
    _controller.animateTo(animateHeight,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  _loadCommentListData() async {
    if (hasLoadData) {
      ResponseBean responseBean =
          await ApiMethodUtil.getTogetherDetail(
              id: widget.togetherInfoBean.id,);
      TogetherInfoBean togetherInfoBean =
          TogetherInfoBean.fromJson(responseBean.data);
      setState(() {
        widget.togetherInfoBean.username = togetherInfoBean.username;
        widget.togetherInfoBean.userAvatar = togetherInfoBean.userAvatar;
        widget.togetherInfoBean.signature = togetherInfoBean.signature;
        widget.togetherInfoBean.commentsCount = togetherInfoBean.commentsCount;
        widget.togetherInfoBean.signUpCount = togetherInfoBean.signUpCount;
      });
    }
    hasLoadData = true;
    ResponseBean responseBean = await ApiMethodUtil.getCommentList(
        commentQueryParam: CommentQueryParam(
            businessType: 10,
            businessId: widget.togetherInfoBean.id,
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
        header: EasyRefreshWidget.getRefreshHeader(Colors.white, Theme.of(context).primaryColor),
        footer: EasyRefreshWidget.getRefreshFooter(Colors.white, Theme.of(context).primaryColor),
        onRefresh: _dataRefresh,
        onLoad: () async {
          await _loadCommentListData();
        },
        child: Column(
          children: [
            TogetherInfoPreviewWidget(
              togetherInfoBean: widget.togetherInfoBean,
              showFollowButton: true,
              avatarHeroTag: 'together[${widget.togetherInfoBean.id}]',
              avatarAction: AvatarAction.toUserInfoPage,
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              height: 5,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    key: _globalKey,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: ScreenUtil().setWidth(22)),
                    width: double.infinity,
                    child: Text(
                      '评论',
                      style: TextStyleTheme.h4,
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
                            return CommentWidget(
                              bizType: BizType.TOGETHER_COMMENT,
                              bizId: widget.togetherInfoBean.id,
                              commentListBean: commentList[commentIndex],
                              commentEditController: widget.commentEditController,
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(22),
                                  vertical: 2
                              ),
                              refreshCallback: widget.refreshCallback,
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
