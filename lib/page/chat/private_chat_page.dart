import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class PrivateChatPage extends StatefulWidget {
  final String username;

  final String userId;

  final String avatar;

  PrivateChatPage({@required this.username, this.userId, this.avatar});

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
      TextMessage message = m.content as TextMessage;
      messageWrapper.msgId = m.messageId;
      messageWrapper.content = message.content;
      messageWrapper.type = 0;
      messageWrapper.userId = m.senderUserId;
      messageWrapper.read = (m.receivedStatus == RCReceivedStatus.Read);
      ProviderUtil.imProvider.messages[widget.userId].add(messageWrapper);
    }
    ProviderUtil.imProvider.refresh();
    setState(() {});
  }

  Widget messageItemBuilder(PrivateMessageWrapper message) {
    if (!message.read) {
      RongIMClient.setMessageReceivedStatus(message.msgId, RCReceivedStatus.Read, (code) async {
        message.read = true;
        ProviderUtil.imProvider.needRefreshConversations = true;
      });
    }
    // 如果是发送方
    if (message.userId == widget.userId) {
      if (message.type == 1) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setHeight(20)),
          child: Row(
            children: [
              Container(
                child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.avatar,
                      width: ScreenUtil().setWidth(85),
                      height: ScreenUtil().setWidth(85),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                    horizontal: ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Text("Hello,能和你一起结伴同行吗？"),
              )
            ],
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(15),
            vertical: ScreenUtil().setHeight(20)),
        child: Row(
          children: [
            Container(
              child: ClipOval(
                  child: CachedNetworkImage(
                imageUrl: widget.avatar,
                width: ScreenUtil().setWidth(85),
                height: ScreenUtil().setWidth(85),
                fit: BoxFit.cover,
              )),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(10),
                  horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(message.content),
            )
          ],
        ),
      );
    } else {
      if (message.type == 1) {
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setHeight(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                    horizontal: ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Text("Hello,能和你一起结伴同行吗？"),
              ),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: ProviderUtil.globalInfoProvider.userInfoBean.avatar,
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
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(15),
          vertical: ScreenUtil().setHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(10),
                horizontal: ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text(message.content),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
            child: ClipOval(
                child: CachedNetworkImage(
              imageUrl: ProviderUtil.globalInfoProvider.userInfoBean.avatar,
              width: ScreenUtil().setWidth(85),
              height: ScreenUtil().setWidth(85),
              fit: BoxFit.cover,
            )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImProvider>(
      builder: (context, imProvider, child) {
        return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 3,
              centerTitle: true,
              title: Text(widget.username),
              leading: FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
              actions: [
                FlatButton(onPressed: () {}, child: Icon(Icons.settings))
              ],
            ),
            body: KeyboardDismissOnTap(
                child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                  child: imProvider.messages[widget.userId] == null
                      ? Container()
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: imProvider.messages[widget.userId].length,
                          reverse: true,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return messageItemBuilder(
                                imProvider.messages[widget.userId][index]);
                          }),
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                        width: ScreenUtil().setWidth(750),
                        height: ScreenUtil().setHeight(100),
                        child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black45, blurRadius: 4)
                              ],
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(15),
                                horizontal: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: ScreenUtil().setWidth(550),
                                  child: TextField(
                                    controller: _messageController,
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLines: 10,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0)),
                                      filled: true,
                                      fillColor: Color(0xFFF0F0F0),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    TextMessage textMessage = TextMessage();
                                    String messageContent =
                                        _messageController.text;
                                    textMessage.content = messageContent;
                                    Message msg = await RongIMClient.sendMessage(
                                        RCConversationType.Private,
                                        widget.userId,
                                        textMessage);
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
                                  },
                                  child: Container(
                                    child: Text(
                                      '发送',
                                      style: TextStyleTheme.h3,
                                    ),
                                  ),
                                )
                              ],
                            ))))
              ],
            )));
      },
    );
  }
}
