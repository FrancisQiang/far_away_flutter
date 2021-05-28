import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/component/avatar_component.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class CommentDetailWidget extends StatelessWidget {
  final String avatar;

  final String username;

  final int publishTime;

  final String content;

  final List<String> pictureList;

  CommentDetailWidget({@required this.avatar,
    @required this.username,
    @required this.publishTime,
    @required this.content,
    this.pictureList = const [] });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarComponent(
              avatar,
              sideLength: ScreenUtil().setWidth(80),
              holderSize: ScreenUtil().setSp(30),
              errorWidgetSize: ScreenUtil().setSp(30)
          ),
          Container(
            width: ScreenUtil().setWidth(585),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Row(
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
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          )
                        )
                      ],
                    )
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
                pictureList.length == 0
                    ? SizedBox()
                    : Builder(builder: (context) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: 5
                    ),
                    child: MediaPreview(
                      flex: false,
                      rowCount: 3,
                      mediaList: List.generate(pictureList.length, (index) => MediaList(type: 1, url: pictureList[index])),
                    ),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}