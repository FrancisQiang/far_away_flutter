import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:flutter/cupertino.dart';

class MediaViewPageParam {

  MediaViewPageParam({
    @required this.mediaList,
    this.currentIndex = 0,
  });

  /// 图片列表
  List<MediaList> mediaList;

  int currentIndex;

}