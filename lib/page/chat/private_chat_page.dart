import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/component/measure_size.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class PrivateChatPage extends StatefulWidget {
  final String username;

  final String userId;

  final String avatar;

  final String togetherId;

  final String recruitId;

  final String recruitTitle;

  final String recruitCover;

  PrivateChatPage({
    @required this.username,
    this.userId,
    this.avatar,
    this.togetherId,
    this.recruitId,
    this.recruitCover,
    this.recruitTitle,
  });

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    onGetHistoryMessages();
  }

  onGetHistoryMessages() async {
    ProviderUtil.imProvider.messages[widget.userId] = [];
    List msgList = await RongIMClient.getHistoryMessage(
        RCConversationType.Private, widget.userId, -1, 100);
    if (msgList == null) {
      return;
    }
    for (Message m in msgList) {
      PrivateMessageWrapper messageWrapper = PrivateMessageWrapper();
      if (m.content is TextMessage) {
        TextMessage message = m.content as TextMessage;
        MessageContentJson json =
            MessageContentJson.fromJson(convert.jsonDecode(message.content));
        messageWrapper.extraInfo = json.extraInfo;
        messageWrapper.content = json.content;
        messageWrapper.type = json.type;
      }
      // TODO 处理其他类型数据
      // .....
      messageWrapper.msgId = m.messageId;
      messageWrapper.userId = m.senderUserId;
      messageWrapper.read = (m.receivedStatus == RCReceivedStatus.Read);
      ProviderUtil.imProvider.messages[widget.userId].add(messageWrapper);
    }
    ProviderUtil.imProvider.refresh();
    setState(() {});
  }

  Widget messageItemBuilder(PrivateMessageWrapper message) {
    if (!message.read) {
      RongIMClient.setMessageReceivedStatus(
          message.msgId, RCReceivedStatus.Read, (code) async {
        message.read = true;
        ProviderUtil.imProvider.needRefreshConversations = true;
      });
    }
    // 如果是发送方
    if (message.userId == widget.userId) {
      switch (message.type) {
        case MessageType.TOGETHER:
          TogetherMessageJson togetherMessageJson =
              TogetherMessageJson.fromJson(
                  convert.jsonDecode(message.extraInfo));
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
                vertical: ScreenUtil().setHeight(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: widget.avatar,
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(85),
                    fit: BoxFit.cover,
                  )),
                ),
                Container(
                  width: ScreenUtil().setWidth(550),
                  child: TogetherSignUpCard(
                    avatar: togetherMessageJson.avatar,
                    content: togetherMessageJson.togetherInfo,
                    togetherId: togetherMessageJson.togetherId,
                    username: togetherMessageJson.username,
                  ),
                ),
              ],
            ),
          );
        case MessageType.RECRUIT_SIGN_UP:
          RecruitMessageJson recruitMessageJson = RecruitMessageJson.fromJson(
              convert.jsonDecode(message.extraInfo));
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: widget.avatar,
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(85),
                    fit: BoxFit.cover,
                  )),
                ),
                Container(
                  width: ScreenUtil().setWidth(550),
                  child: RecruitSignUpCard(
                    cover: recruitMessageJson.cover,
                    title: recruitMessageJson.title,
                    id: recruitMessageJson.recruitId,
                  ),
                ),
              ],
            ),
          );
        default:
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
                vertical: ScreenUtil().setHeight(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: widget.avatar,
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(85),
                    fit: BoxFit.cover,
                  )),
                ),
                Container(
                  child: DefaultMessageCard(
                    content: message.content,
                  ),
                ),
              ],
            ),
          );
      }
    } else {
      // 如果是自己发送的
      switch (message.type) {
        case MessageType.TOGETHER:
          TogetherMessageJson togetherMessageJson =
              TogetherMessageJson.fromJson(
                  convert.jsonDecode(message.extraInfo));
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
                vertical: ScreenUtil().setHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().setWidth(550),
                  child: TogetherSignUpCard(
                    avatar: togetherMessageJson.avatar,
                    content: togetherMessageJson.togetherInfo,
                    togetherId: togetherMessageJson.togetherId,
                    username: togetherMessageJson.username,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl:
                        ProviderUtil.globalInfoProvider.userInfoBean.avatar,
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(85),
                    fit: BoxFit.cover,
                  )),
                ),
              ],
            ),
          );
        case MessageType.RECRUIT_SIGN_UP:
          RecruitMessageJson recruitMessageJson = RecruitMessageJson.fromJson(
              convert.jsonDecode(message.extraInfo));
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
                vertical: ScreenUtil().setHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().setWidth(550),
                  child: RecruitSignUpCard(
                    cover: recruitMessageJson.cover,
                    title: recruitMessageJson.title,
                    id: recruitMessageJson.recruitId,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          ProviderUtil.globalInfoProvider.userInfoBean.avatar,
                      width: ScreenUtil().setWidth(85),
                      height: ScreenUtil().setWidth(85),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        default:
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
                vertical: ScreenUtil().setHeight(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: DefaultMessageCard(
                    content: message.content,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(12),
                    top: 4,
                    bottom: 4,
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl:
                        ProviderUtil.globalInfoProvider.userInfoBean.avatar,
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(85),
                    fit: BoxFit.cover,
                  )),
                ),
              ],
            ),
          );
      }
    }
  }

  double bottomMargin = ScreenUtil().setHeight(90);

  @override
  Widget build(BuildContext context) {
    return Consumer<ImProvider>(
      builder: (context, imProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            title: Text(widget.username),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
          ),
          body: KeyboardDismissOnTap(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: bottomMargin),
                  child: imProvider.messages[widget.userId] == null
                      ? Container()
                      : ScrollConfiguration(
                          behavior: OverScrollBehavior(),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  imProvider.messages[widget.userId].length,
                              reverse: true,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return messageItemBuilder(
                                    imProvider.messages[widget.userId][index]);
                              }),
                        ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: MeasureSize(
                    onChange: (Size size) {
                      setState(() {
                        bottomMargin = size.height;
                      });
                    },
                    child:  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 0.08),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(25),
                          vertical: ScreenUtil().setHeight(10)
                      ),
                      width: ScreenUtil().setWidth(750),
                      constraints: BoxConstraints(
                        minHeight: ScreenUtil().setHeight(90),
                        maxHeight: ScreenUtil().setHeight(300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(550),
                            child: TextField(
                              controller: _messageController,
                              cursorColor: Colors.orangeAccent,
                              textAlignVertical: TextAlignVertical.center,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(12),
                                  horizontal: ScreenUtil().setWidth(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0.01,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0.01,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () async {
                                TextMessage textMessage = TextMessage();
                                String messageContent = _messageController.text;
                                MessageContentJson contentJson =
                                MessageContentJson(
                                    content: messageContent,
                                    extraInfo: "",
                                    type: MessageType.DEFAULT);
                                textMessage.content =
                                    convert.jsonEncode(contentJson);
                                Message msg = await RongIMClient.sendMessage(
                                    RCConversationType.Private,
                                    widget.userId,
                                    textMessage);
                                PrivateMessageWrapper messageWrapper =
                                PrivateMessageWrapper();
                                messageWrapper.msgId = msg.messageId;
                                messageWrapper.content = messageContent;
                                messageWrapper.type = 0;
                                messageWrapper.userId = ProviderUtil
                                    .globalInfoProvider.userInfoBean.id;
                                messageWrapper.read = true;
                                imProvider.messages[widget.userId]
                                    .insert(0, messageWrapper);
                                _messageController.clear();
                                imProvider.refreshConversationList();
                                setState(() {});
                              },
                              child: Container(
                                child: Text(
                                  '发送',
                                  style: TextStyleTheme.h3,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TogetherSignUpCard extends StatelessWidget {
  final String avatar;

  final String username;

  final String togetherId;

  final String content;

  TogetherSignUpCard(
      {this.avatar, this.username, this.togetherId, this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20), vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),
                        imageUrl: avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                    constraints:
                        BoxConstraints(maxWidth: ScreenUtil().setWidth(380)),
                    child: Text(
                      '$username，我想与你结伴同行',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
              child: Container(
                child: Text(
                  '来自: $content',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecruitSignUpCard extends StatelessWidget {
  final String cover;

  final String title;

  final String id;

  RecruitSignUpCard({this.cover, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                height: ScreenUtil().setHeight(300),
                width: ScreenUtil().setWidth(550),
                imageUrl: cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(10)),
            child: Text(
              '[义工招聘] $title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(12),
                right: ScreenUtil().setWidth(12),
                bottom: ScreenUtil().setHeight(10)),
            child: Text(
              '我是来自江苏的刘肥雪，想要报名这次义工。',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DefaultMessageCard extends StatelessWidget {
  final String content;

  DefaultMessageCard({this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setWidth(80),
          maxWidth: ScreenUtil().setWidth(550),
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(18),
            horizontal: ScreenUtil().setWidth(20)),
        child: Text('$content'),
      ),
    );
  }
}
