import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/component/measure_size.dart';
import 'package:far_away_flutter/config/OverScrollBehavior.dart';
import 'package:far_away_flutter/page/chat/left_message_row.dart';
import 'package:far_away_flutter/page/chat/recruit_message_card.dart';
import 'package:far_away_flutter/page/chat/right_message_row.dart';
import 'package:far_away_flutter/page/chat/text_message_card.dart';
import 'package:far_away_flutter/page/chat/together_message_card.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
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
    _messageController.addListener(() {
      setState(() {});
    });
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
    Widget messageBody;
    switch (message.type) {
      case MessageType.TOGETHER:
        TogetherMessageJson togetherMessageJson =
            TogetherMessageJson.fromJson(convert.jsonDecode(message.extraInfo));
        messageBody = TogetherMessageCard(
          avatar: togetherMessageJson.avatar,
          content: togetherMessageJson.togetherInfo,
          togetherId: togetherMessageJson.togetherId,
          username: togetherMessageJson.username,
        );
        break;
      case MessageType.RECRUIT_SIGN_UP:
        RecruitMessageJson recruitMessageJson =
            RecruitMessageJson.fromJson(convert.jsonDecode(message.extraInfo));
        messageBody = RecruitMessageCard(
          cover: recruitMessageJson.cover,
          title: recruitMessageJson.title,
          id: recruitMessageJson.recruitId,
          content: recruitMessageJson.content,
        );
        break;
      default:
        messageBody = TextMessageCard(
          content: message.content,
        );
        break;
    }
    // 如果是发送方
    if (message.userId == widget.userId) {
      return LeftMessageRow(messageBody: messageBody, avatar: widget.avatar);
    } else {
      return RightMessageRow(
          messageBody: messageBody,
          avatar: ProviderUtil.globalInfoProvider.userInfoBean.avatar);
    }
  }

  double bottomMargin = ScreenUtil().setHeight(90);

  sendMessage(ImProvider imProvider) async {
    TextMessage textMessage = TextMessage();
    String messageContent = _messageController.text;
    MessageContentJson contentJson = MessageContentJson(
        content: messageContent, extraInfo: "", type: MessageType.DEFAULT);
    textMessage.content = convert.jsonEncode(contentJson);
    Message msg = await RongIMClient.sendMessage(
        RCConversationType.Private, widget.userId, textMessage);
    PrivateMessageWrapper messageWrapper = PrivateMessageWrapper();
    messageWrapper.msgId = msg.messageId;
    messageWrapper.content = messageContent;
    messageWrapper.type = 0;
    messageWrapper.userId = ProviderUtil.globalInfoProvider.userInfoBean.id;
    messageWrapper.read = true;
    imProvider.messages[widget.userId].insert(0, messageWrapper);
    _messageController.clear();
    imProvider.refreshConversationList();
    setState(() {});
  }

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
                            },
                          ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 0.08),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(25),
                          vertical: ScreenUtil().setHeight(5)),
                      width: ScreenUtil().setWidth(750),
                      constraints: BoxConstraints(
                        minHeight: ScreenUtil().setHeight(90),
                        maxHeight: ScreenUtil().setHeight(300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(540),
                            child: TextField(
                              controller: _messageController,
                              cursorColor: Theme.of(context).primaryColorLight,
                              textAlignVertical: TextAlignVertical.bottom,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(28)),
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                filled: true,
                                fillColor: Theme.of(context).backgroundColor,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(12),
                                  horizontal: ScreenUtil().setWidth(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  gapPadding: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(30),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                height: ScreenUtil().setHeight(50),
                                color: Theme.of(context).primaryColor,
                                disabledColor:
                                    Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                onPressed:
                                    StringUtil.isEmpty(_messageController.text)
                                        ? null
                                        : () async {
                                            await sendMessage(imProvider);
                                          },
                                child: Container(
                                  child: Text(
                                    '发送',
                                    style: TextStyleTheme.h3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
