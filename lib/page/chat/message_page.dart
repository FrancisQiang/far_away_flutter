import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/bean/simple_user_info_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<ConversationWrapper> _conversationList = [
    // MessageBean(
    //     '早安，今天又是想你的一天',
    //     'FrancisQ',
    //     'http://m.imeitou.com/uploads/allimg/2020111114/vy4crh4xpdn.jpg',
    //     1609430400000),
    // MessageBean(
    //     '你在干嘛呀？我好想你啊',
    //     '早起的年轻人',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/umqqpy3o04a.jpg',
    //     1609430400000),
    // MessageBean(
    //     '云朵好甜我爱了',
    //     '电竞女神xx.',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/yy3ku3ili3l.jpg',
    //     1609430400000),
    // MessageBean(
    //     '夏天，秋天 他们不温柔吗！简短又温柔嘿嘿嘿',
    //     '月亮邮递员',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/npwylfla4kk.jpg',
    //     1609430400000),
    // MessageBean(
    //     '为啥不吃香菜 香菜多好吃。以后都给好好吃香菜，营养又健康',
    //     '一觉睡到小时候',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/0zz5q1crt5m.jpg',
    //     1609430400000),
    // MessageBean(
    //     'Flutter is beautiful!',
    //     '双马尾的小迷妹',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/p55clpp54ac.jpg',
    //     1609430400000),
    // MessageBean(
    //     '你才是猪呢，哼！',
    //     '可爱的猪猪少女',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/1qnr0m4no54.jpg',
    //     1609430400000),
    // MessageBean(
    //     '对不起，我其实一直爱着你',
    //     '奶熊布偶',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/wyfxcyv523x.jpg',
    //     1609430400000),
    // MessageBean(
    //     '对不起，我其实一直爱着你',
    //     '软甜啾',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/32br0oyohxg.jpg',
    //     1609430400000),
    // MessageBean(
    //     '对不起，我其实一直爱着你',
    //     '甜味拾荒者',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/1i1inddvslx-lp.jpg',
    //     1609430400000),
    // MessageBean(
    //     '对不起，我其实一直爱着你',
    //     '酒酿桃叽',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/1i1inddvslx-lp.jpg',
    //     1609430400000),
    // MessageBean(
    //     '对不起，我其实一直爱着你',
    //     'FrancisQ',
    //     'http://m.imeitou.com/uploads/allimg/2021032508/1i1inddvslx-lp.jpg',
    //     1609430400000),
  ];

  @override
  void initState() {
    super.initState();
    RongIMClient.onMessageReceived = (Message msg,int left) {

    };
    onGetConversationList();
  }

  onGetConversationList() async {
    List conversationList = await RongIMClient.getConversationList([RCConversationType.Private,RCConversationType.Group,RCConversationType.System]);
    List<String> idList = [];
    for(Conversation conversation in conversationList) {
      idList.add(conversation.senderUserId);
      TextMessage message = conversation.latestMessageContent as TextMessage;
      ConversationWrapper conversationWrapper = ConversationWrapper(
        content: message.content,
        unReadMessageCount: conversation.unreadMessageCount,
        sendTime: conversation.sentTime,
      );
      _conversationList.add(conversationWrapper);
    }
    Response<dynamic> response = await ApiMethodUtil.getSimpleUserInfoList(userIds: idList);
    ResponseBean responseBean = ResponseBean.fromJson(response.data);
    SimpleUserInfoList userList = SimpleUserInfoList.fromJson(responseBean.data);
    for (int i = 0; i < _conversationList.length; i++) {
      SimpleUserInfo simpleUserInfo = SimpleUserInfo.fromJson(userList.list[i]);
      ConversationWrapper conversationWrapper = _conversationList[i];
      conversationWrapper.username = simpleUserInfo.username;
      conversationWrapper.avatar = simpleUserInfo.avatar;
      conversationWrapper.userId = simpleUserInfo.userId;
    }
    setState(() {});
  }

  onGetHistoryMessages() async {
    List msgs = await RongIMClient.getHistoryMessage(RCConversationType.Private, "1375650960511774722", -1, 100);
    print("get history message ${msgs.length}");
    for(Message m in msgs) {
      print('content ${m.content.encode()}');
      print("sentTime = "+m.sentTime.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return MessageTile(messageBean: _conversationList[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(145),
                right: ScreenUtil().setWidth(15)),
            child: Divider(color: Colors.grey[400]),
          );
        },
        itemCount: _conversationList.length,
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final ConversationWrapper messageBean;

  MessageTile({@required this.messageBean});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: (){},
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(15),
            vertical: ScreenUtil().setHeight(15)),
        child: Row(children: [
          Container(
            child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: messageBean.avatar,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                  fit: BoxFit.cover,
                )
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(120),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(480),
                          child: Text(
                            messageBean.username,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Text('${DateUtil.getSimpleDate(messageBean.sendTime)}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Colors.black54)),
                        )
                      ],
                    )),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(480),
                        child: Text(messageBean.content,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Colors.black54)),
                      ),
                      Container(
                          margin:
                          EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(70),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              '${messageBean.unReadMessageCount > 99 ? "99+" : messageBean.unReadMessageCount}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class ConversationWrapper {
  ConversationWrapper({this.content, this.username, this.userId, this.avatar, this.sendTime, this.unReadMessageCount});

  String content;

  String userId;

  String username;

  String avatar;

  int sendTime;

  int unReadMessageCount;
}


