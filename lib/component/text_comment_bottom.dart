import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/provider/comment_chosen_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class TextCommentBottom extends StatelessWidget {

  final int bizType;

  TextCommentBottom({@required this.bizType});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)],
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(15), horizontal: 2),
        child: Consumer<CommentChosenProvider>(
          builder: (context, commentChosenProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: ScreenUtil().setWidth(550),
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: null,
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0)),
                        hintText:
                        '回复 ${commentChosenProvider.targetUsername}: ',
                        hintStyle: TextStyleTheme.subH4),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String duplicateContent = _controller.text;
                    _controller.text = '';
                    commentChosenProvider.refresh();
                    FocusScope.of(context).requestFocus(FocusNode());
                    ToastUtil.showNoticeToast("评论发布中");
                    String jwt = ProviderUtil.globalInfoProvider.jwt;
                    Response<dynamic> response =
                    await ApiMethodUtil.postComment(
                        token: jwt,
                        bizId: commentChosenProvider.targetBizId,
                        toUserId: commentChosenProvider.targetUserId,
                        content: duplicateContent,
                        pid: commentChosenProvider.pid,
                        bizType: bizType.toString(),);
                    ResponseBean responseBean =
                    ResponseBean.fromJson(response.data);
                    if (responseBean.isSuccess()) {
                      ToastUtil.showSuccessToast("评论成功");
                    }
                  },
                  child: Container(
                    child: Text(
                      '发送',
                      style: TextStyleTheme.h3,
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
