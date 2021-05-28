import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/avatar_component.dart';
import 'package:far_away_flutter/component/comment_empty.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/constant/biz_type.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/controller.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/editor.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/mode.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/scaffold.dart';
import 'package:far_away_flutter/page/comment/comment_input_bottom_page.dart';
import 'package:far_away_flutter/page/comment/comment_widget.dart';
import 'package:far_away_flutter/page/post/post_recruit_page.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notus/notus.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class RecruitDetailPage extends StatefulWidget {
  final RecruitDetailInfoBean recruitDetailInfoBean;

  RecruitDetailPage({@required this.recruitDetailInfoBean});

  @override
  _RecruitDetailPageState createState() => _RecruitDetailPageState();
}

class _RecruitDetailPageState extends State<RecruitDetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ZefyrController markdownController;

  final ScrollController _controller = ScrollController();

  final TextEditingController commentEditController = TextEditingController();

  int currentPage = 1;

  List<CommentListBean> commentList = [];

  bool emptyData = false;

  @override
  void initState() {
    super.initState();
    var json = convert.jsonDecode(widget.recruitDetailInfoBean.content);
    markdownController = ZefyrController(NotusDocument.fromJson(json));
    _refreshData();
  }

  _refreshData() async {
    ResponseBean responseBean = await ApiMethodUtil.getRecruitDetail(
        id: widget.recruitDetailInfoBean.id,);
    RecruitDetailInfoBean recruitDetailInfoBean =
        RecruitDetailInfoBean.fromJson(responseBean.data);
    currentPage = 1;
    commentList.clear();
    responseBean = await ApiMethodUtil.getCommentList(
        commentQueryParam: CommentQueryParam(
            businessType: 27,
            businessId: widget.recruitDetailInfoBean.id,
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
        widget.recruitDetailInfoBean.username = recruitDetailInfoBean.username;
        widget.recruitDetailInfoBean.userAvatar =
            recruitDetailInfoBean.userAvatar;
        widget.recruitDetailInfoBean.signature = recruitDetailInfoBean.signature;
        widget.recruitDetailInfoBean.commentsCount =
            recruitDetailInfoBean.commentsCount;
        widget.recruitDetailInfoBean.signUpCount =
            recruitDetailInfoBean.signUpCount;
      }
    });
  }

  _loadComment() async {
    ResponseBean responseBean = await ApiMethodUtil.getCommentList(
        commentQueryParam: CommentQueryParam(
            businessType: 27,
            businessId: widget.recruitDetailInfoBean.id,
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

  _refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: ScreenUtil().setHeight(80),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(FontAwesomeIcons.angleLeft),
          ),
          actions: [
            Container(
              width: ScreenUtil().setWidth(120),
              child: RaisedButton(
                padding: EdgeInsets.zero,
                elevation: 0,
                color: Colors.transparent,
                onPressed: () => {},
                child: Image.asset(
                  'assets/png/three_dots.png',
                  width: ScreenUtil().setWidth(45),
                  height: ScreenUtil().setWidth(40),
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(80),
                ),
                child: ZefyrScaffold(
                  child: ZefyrEditor(
                    autofocus: false,
                    bottomBouncing: false,
                    topBouncing: false,
                    useEasyRefresh: true,
                    scrollController: _controller,
                    header: EasyRefreshWidget.getRefreshHeader(Colors.white, Theme.of(context).primaryColor),
                    footer: EasyRefreshWidget.getRefreshFooter(Colors.white, Theme.of(context).primaryColor),
                    focusNode: FocusNode(),
                    onRefresh: () async {
                      await _refreshData();
                    },
                    onLoad: () async {
                      await _loadComment();
                    },
                    controller: markdownController,
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                    ),
                    mode: ZefyrMode.view,
                    imageDelegate: MarkdownImageDelegate(),
                    customAboveWidget: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      imageUrl: widget
                                          .recruitDetailInfoBean.userAvatar,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                  Container(
                                    width: ScreenUtil().setWidth(520),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(15)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget
                                                .recruitDetailInfoBean.username,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            widget.recruitDetailInfoBean
                                                .signature,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(15)),
                                    child: Text(
                                      DateUtil.getSimpleDate(widget
                                          .recruitDetailInfoBean.publishTime),
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
                    customBottomWidget: Container(
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.black, width: 0.05),
                                      ),
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
                                            bizType: BizType.RECRUIT_COMMENT,
                                            bizId: widget.recruitDetailInfoBean.id,
                                            commentListBean: commentList[commentIndex],
                                            commentEditController: commentEditController,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(22),
                                                vertical: 2
                                            ),
                                            refreshCallback: _refreshCallback,
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ],
                      ),
                    )
                  ),
                )),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 0.1),
                  ),
                ),
                height: ScreenUtil().setHeight(80),
                width: ScreenUtil().setWidth(750),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) {
                                return CommentInputBottomPage(
                                  pid: "0",
                                  toUserId: widget.recruitDetailInfoBean.userId,
                                  bizId: widget.recruitDetailInfoBean.id,
                                  commentEditController: commentEditController,
                                  bizType: BizType.RECRUIT_COMMENT,
                                  imageFileList: null,
                                  loadPictures: null,
                                  refreshCallback: _refreshCallback,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/png/comment.png',
                                  width: ScreenUtil().setWidth(45),
                                  height: ScreenUtil().setWidth(40),
                                ),
                              ),
                              Container(
                                child: Text(widget.recruitDetailInfoBean
                                            .commentsCount ==
                                        0
                                    ? ''
                                    : '  ${widget.recruitDetailInfoBean.commentsCount}'),
                              )
                            ],
                          ),
                        )),
                    FlatButton(
                        onPressed: () async {
                          await ApiMethodUtil.dynamicThumbChange(
                            thumb: !widget.recruitDetailInfoBean.thumbed,
                            dynamicId: widget.recruitDetailInfoBean.id,
                          );
                          setState(() {
                            if (!widget.recruitDetailInfoBean.thumbed) {
                              widget.recruitDetailInfoBean.thumbCount++;
                              widget.recruitDetailInfoBean.thumbed = true;
                            } else {
                              widget.recruitDetailInfoBean.thumbCount--;
                              widget.recruitDetailInfoBean.thumbed = false;
                            }
                          });
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  widget.recruitDetailInfoBean.thumbed
                                      ? 'assets/png/thumbed.png'
                                      : 'assets/png/thumbs.png',
                                  width: ScreenUtil().setWidth(45),
                                  height: ScreenUtil().setWidth(40),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.recruitDetailInfoBean.thumbCount == 0
                                      ? ''
                                      : '  ${widget.recruitDetailInfoBean.thumbCount}',
                                  style: TextStyle(
                                      color:
                                          widget.recruitDetailInfoBean.thumbed
                                              ? Color.fromRGBO(255, 122, 0, 1)
                                              : Colors.black),
                                ),
                              )
                            ],
                          ),
                        )),
                    FlatButton(
                        onPressed: () async {
                          if (ProviderUtil.globalInfoProvider.userInfoBean.id ==
                              widget.recruitDetailInfoBean.userId) {
                            ToastUtil.showNoticeToast("您是发布者，不能报名哦！");
                            return;
                          }
                          ResponseBean responseBean = await ApiMethodUtil.recruitSignUp(
                            id: widget.recruitDetailInfoBean.id,
                          );
                          if (responseBean.isSuccess()) {
                            // 发送结伴消息
                            TextMessage textMessage = TextMessage();
                            MessageContentJson json = MessageContentJson(
                              content: "",
                              type: MessageType.RECRUIT_SIGN_UP,
                              extraInfo: convert.jsonEncode(
                                RecruitMessageJson(
                                  cover: widget.recruitDetailInfoBean.cover,
                                  recruitId: widget.recruitDetailInfoBean.id,
                                  avatar:
                                      widget.recruitDetailInfoBean.userAvatar,
                                  title: widget.recruitDetailInfoBean.title,
                                ),
                              ),
                            );
                            textMessage.content = convert.jsonEncode(json);
                            Message msg = await RongIMClient.sendMessage(
                              RCConversationType.Private,
                              widget.recruitDetailInfoBean.userId,
                              textMessage,
                            );
                            PrivateMessageWrapper messageWrapper =
                                PrivateMessageWrapper();
                            messageWrapper.msgId = msg.messageId;
                            messageWrapper.content = convert.jsonEncode(json);
                            messageWrapper.type = MessageType.RECRUIT_SIGN_UP;
                            messageWrapper.userId =
                                ProviderUtil.globalInfoProvider.userInfoBean.id;
                            messageWrapper.read = true;
                            if (ProviderUtil.imProvider.messages[
                                    widget.recruitDetailInfoBean.userId] ==
                                null) {
                              ProviderUtil.imProvider.messages[
                                  widget.recruitDetailInfoBean.userId] = [];
                            }
                            ProviderUtil.imProvider
                                .messages[widget.recruitDetailInfoBean.userId]
                                .insert(0, messageWrapper);
                            NavigatorUtil.toPrivateChatPage(
                              context,
                              param: PrivateChatParam(
                                username: widget.recruitDetailInfoBean.username,
                                userId: widget.recruitDetailInfoBean.userId,
                                avatar: widget.recruitDetailInfoBean.userAvatar,
                                recruitId: widget.recruitDetailInfoBean.id,
                                recruitCover:
                                    widget.recruitDetailInfoBean.cover,
                                recruitTitle:
                                    widget.recruitDetailInfoBean.title,
                              ),
                            );
                            if (!widget.recruitDetailInfoBean.signUp) {
                              widget.recruitDetailInfoBean.signUp = true;
                              widget.recruitDetailInfoBean.signUpCount++;
                            }
                          } else {
                            ToastUtil.showErrorToast("网络异常，请稍后再试");
                          }
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  widget.recruitDetailInfoBean.signUp
                                      ? 'assets/png/handed.png'
                                      : 'assets/png/hands.png',
                                  width: ScreenUtil().setWidth(45),
                                  height: ScreenUtil().setWidth(40),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.recruitDetailInfoBean.signUpCount == 0
                                      ? ''
                                      : '${widget.recruitDetailInfoBean.signUpCount}',
                                  style: TextStyle(
                                    color: widget.recruitDetailInfoBean.signUp
                                        ? Color.fromRGBO(255, 122, 0, 1)
                                        : Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    FlatButton(
                      onPressed: () {},
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        child: Image.asset(
                          'assets/png/share_without_outline.png',
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
