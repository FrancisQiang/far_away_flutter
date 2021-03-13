import 'package:far_away_flutter/bean/togther_info_bean.dart';
import 'package:flutter/material.dart';

class TogetherDetailParam {

  TogetherDetailParam({this.scrollToComment = false, this.avatarHeroTag = '', @required this.togetherInfoBean});

  // 是否滚动到评论
  bool scrollToComment;

  // 头像转场动画tag
  String avatarHeroTag;

  // 点赞返回设置
  TogetherInfoBean togetherInfoBean;

}