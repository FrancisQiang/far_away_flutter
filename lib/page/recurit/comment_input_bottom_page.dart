import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInputBottomPage extends StatelessWidget {

  CommentInputBottomPage({@required this.toUserId, @required this.pid, @required this.controller, @required this.bizId, this.avatar, this.content});

  final String avatar;

  final String content;

  final String bizId;

  final String toUserId;

  final String pid;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.35),
        body: Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              pid != '0' && avatar != null && content != null ? Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(22),
                  vertical: 5
                ),
                child: Row(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(60),
                      child: ClipOval(
                        child: Image.network(
                          avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(550),
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15)
                      ),
                      child: Text(
                        content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ) : SizedBox(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 0.08),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                    vertical: ScreenUtil().setHeight(15)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(560),
                      child: TextField(
                        cursorColor: Colors.orangeAccent,
                        controller: controller,
                        autofocus: true,
                        style: TextStyle(fontSize: 16),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: '请输入评论的内容',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(30)),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(10),
                              horizontal: ScreenUtil().setWidth(10)),
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
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              ToastUtil.showNoticeToast("评论发布中");
                              String jwt = ProviderUtil.globalInfoProvider.jwt;
                              ResponseBean responseBean = await ApiMethodUtil.postComment(
                                token: jwt,
                                bizId: bizId,
                                toUserId: toUserId,
                                content: controller.text,
                                pid: pid,
                                bizType: '27',
                              );
                              if (responseBean.isSuccess()) {
                                ToastUtil.showSuccessToast("评论成功");
                              }
                            },
                            child: Text(
                              '发布',
                              style: TextStyle(
                                color: Colors.orange,
                                letterSpacing: 2,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
