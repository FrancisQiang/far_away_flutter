import 'package:far_away_flutter/bean/comment_list_bean.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/MediaPreview.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class ParentCommentDetailWidget extends StatelessWidget {
  final CommentListBean commentListBean;

  ParentCommentDetailWidget({this.commentListBean});

  List<String> _getPictureList(String pictureList) {
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    width: ScreenUtil().setWidth(90),
                    child: ClipOval(
                      child: Image.network(
                        commentListBean.fromUserAvatar,
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(520),
                              child: Text(
                                commentListBean.fromUsername,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                                child: Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ))
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          DateUtil.getTimeString(
                              DateTime.fromMillisecondsSinceEpoch(
                                  commentListBean.publishTime)),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                            color: Colors.black45,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10),
              right: ScreenUtil().setWidth(20),
            ),
            child: Text(
              commentListBean.content,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
          !StringUtil.isEmpty(commentListBean.pictureUrlList) ?
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(15),
            ),
            child: MediaPreview(
              flex: false,
              rowCount: 3,
              mediaList: List.generate(
                  _getPictureList(commentListBean.pictureUrlList).length,
                  (index) => MediaList(
                      type: 1,
                      url: _getPictureList(
                          commentListBean.pictureUrlList)[index])),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
}
