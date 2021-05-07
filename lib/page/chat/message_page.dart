import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/im_bean.dart';
import 'package:far_away_flutter/param/private_chat_param.dart';
import 'package:far_away_flutter/provider/im_provider.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ImProvider>(
        builder: (context, imProvider, child){
          if (imProvider.needRefreshConversations) {
            imProvider.refreshConversationList();
          }
          return Container(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return MessageTile(messageBean: imProvider.conversations[index]);
              },
              separatorBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(145),
                      right: ScreenUtil().setWidth(15)),
                  child: Divider(color: Colors.grey[400]),
                );
              },
              itemCount: imProvider.conversations.length,
            ),
          );
        }
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
      onPressed: (){
        NavigatorUtil.toPrivateChatPage(context, param: PrivateChatParam(username: messageBean.username, userId: messageBean.userId, avatar: messageBean.avatar));
      },
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
                      messageBean.unReadMessageCount == 0 ? Container() :
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


