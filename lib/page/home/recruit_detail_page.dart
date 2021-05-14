import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/bean/page_bean.dart';
import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/component/avatar_component.dart';
import 'package:far_away_flutter/component/comment_empty.dart';
import 'package:far_away_flutter/component/easy_refresh_widget.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/controller.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/editor.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/mode.dart';
import 'package:far_away_flutter/custom_zefyr/widgets/scaffold.dart';
import 'package:far_away_flutter/page/post/post_recruit_page.dart';
import 'package:far_away_flutter/page/recurit/comment_input_bottom_page.dart';
import 'package:far_away_flutter/param/comment_query_param.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    header: EasyRefreshWidget.refreshHeader,
                    footer: EasyRefreshWidget.refreshFooter,
                    focusNode: FocusNode(),
                    onRefresh: () async {
                      _getRecruitDetail();
                      recruitCommentController.init();
                    },
                    onLoad: () async {
                      recruitCommentController.refresh();
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
                                                    ScreenUtil().setSp(20)),
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
                    customBottomWidget: RecruitComment(
                      id: widget.recruitDetailInfoBean.id,
                      recruitCommentController: recruitCommentController,
                      bizId: widget.recruitDetailInfoBean.id,
                      commentEditController: commentEditController,
                    ),
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
                                  toUserId: widget.recruitDetailInfoBean.userId,
                                  bizId: widget.recruitDetailInfoBean.id,
                                  pid: '0',
                                  controller: commentEditController,
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
                            token: ProviderUtil.globalInfoProvider.jwt,
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
                          Response<dynamic> response =
                              await ApiMethodUtil.recruitSignUp(
                            token: ProviderUtil.globalInfoProvider.jwt,
                            id: widget.recruitDetailInfoBean.id,
                          );
                          if (ResponseBean.fromJson(response.data)
                              .isSuccess()) {
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
                            widget.recruitDetailInfoBean.signUp = true;
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
                                child: Text(widget.recruitDetailInfoBean
                                            .signUpCount ==
                                        0
                                    ? ''
                                    : '${widget.recruitDetailInfoBean.signUpCount}'),
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

class RecruitComment extends StatefulWidget {
  final String id;

  final RecruitCommentController recruitCommentController;

  final TextEditingController commentEditController;

  final String bizId;

  RecruitComment(
      {@required this.id,
      @required this.recruitCommentController,
      @required this.commentEditController,
      this.bizId});

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
    commentList = [];
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
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 0.05)),
            ),
            width: double.infinity,
            child: Text(
              '评论',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: commentList.isEmpty && emptyData
                ? Container(
                    child: CommentEmpty(
                      iconHeight: ScreenUtil().setHeight(300),
                      iconWidth: ScreenUtil().setWidth(750),
                    ),
                  )
                : Column(
                    children: List.generate(commentList.length, (commentIndex) {
                      return RecruitCommentWidget(
                        commentListBean: commentList[commentIndex],
                        commentEditController: widget.commentEditController,
                        bizId: widget.bizId,
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

class RecruitCommentWidget extends StatelessWidget {
  final CommentListBean commentListBean;

  final TextEditingController commentEditController;

  final String bizId;

  RecruitCommentWidget(
      {@required this.commentListBean,
      @required this.commentEditController,
      this.bizId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.orangeAccent.withOpacity(0.2),
      splashColor: Colors.orangeAccent.withOpacity(0.4),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return CommentInputBottomPage(
                avatar: commentListBean.fromUserAvatar,
                content: commentListBean.content,
                toUserId: commentListBean.fromUserId,
                bizId: bizId,
                pid: commentListBean.id,
                controller: commentEditController,
              );
            },
          ),
        );
      },
      child: Container(
          child: Column(
        children: [
          CommentDetailWidget(
            avatar: commentListBean.fromUserAvatar,
            username: commentListBean.fromUsername,
            publishTime: commentListBean.publishTime,
            content: commentListBean.content,
          ),
          commentListBean.children.isNotEmpty
              ? Container(
                  // width: ScreenUtil().setWidth(550),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(130),
                    right: ScreenUtil().setWidth(100),
                    bottom: ScreenUtil().setHeight(10),
                  ),
                  child: ChildrenCommentPreviewWidget(
                    parentComment: commentListBean,
                    bizId: bizId,
                    commentEditController: commentEditController,
                  ),
                )
              : SizedBox(),
        ],
      )),
    );
  }
}

class ChildrenCommentPreviewWidget extends StatelessWidget {
  final String bizId;

  final CommentListBean parentComment;

  final TextEditingController commentEditController;

  ChildrenCommentPreviewWidget(
      {this.parentComment, this.bizId, this.commentEditController});

  Widget generateChildComment(CommentListBean item, context) {
    return InkWell(
      highlightColor: Colors.orangeAccent.withOpacity(0.2),
      splashColor: Colors.orangeAccent.withOpacity(0.4),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return CommentInputBottomPage(
                avatar: item.fromUserAvatar,
                content: item.content,
                toUserId: item.fromUserId,
                bizId: bizId,
                pid: parentComment.id,
                controller: commentEditController,
              );
            },
          ),
        );
      },
      child: Container(
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
                    letterSpacing: 0.4))
          ]),
        ),
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
      childrenWidget.add(InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              context: context,
              builder: (context) => ProviderUtil.getRecruitCommentDrawWidget(
                  parentComment, bizId, commentEditController));
        },
        child: Container(
          margin: EdgeInsets.only(top: 2),
          child: Text(
            '查看全部${childrenList.length}条评论',
            style: TextStyle(
                color: Colors.blueAccent, fontSize: ScreenUtil().setSp(25)),
          ),
        ),
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: childrenWidget);
  }
}

class CommentDetailWidget extends StatelessWidget {
  final String avatar;

  final String username;

  final int publishTime;

  final String content;

  CommentDetailWidget(
      {@required this.avatar,
      @required this.username,
      @required this.publishTime,
      @required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: ScreenUtil().setWidth(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarComponent(avatar,
              sideLength: ScreenUtil().setWidth(80),
              holderSize: ScreenUtil().setSp(30),
              errorWidgetSize: ScreenUtil().setSp(30)),
          Container(
            width: ScreenUtil().setWidth(560),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
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
                      child: Image.asset(
                        'assets/png/three_dots.png',
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(40),
                      ),
                    )
                  ],
                ),
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
              ],
            ),
          )
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
