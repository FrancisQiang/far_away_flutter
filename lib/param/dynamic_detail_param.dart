import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:flutter/cupertino.dart';

class DynamicDetailParam {

  DynamicDetailParam({this.scrollToComment = false, this.avatarHeroTag = '', @required this.dynamicDetailBean});

  // 是否滚动到评论
  bool scrollToComment;

  // 头像转场动画tag
  String avatarHeroTag;

  // 点赞返回设置
  DynamicDetailBean dynamicDetailBean;

}