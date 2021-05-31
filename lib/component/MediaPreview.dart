import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/video_preview.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'image_error_widget.dart';
import 'image_holder.dart';

/// 动态 九宫格媒体组建 适配图片和视频类型
class MediaPreview extends StatelessWidget {

  final List<MediaList> mediaList;

  final double spacing;

  final double runSpacing;

  // flex 为 true则根据数量进行整理宽度
  // 否则根据rowCount数量
  final bool flex;

  final int rowCount;

  MediaPreview({@required this.mediaList, this.spacing = 4, this.runSpacing = 4, this.flex = true, this.rowCount});

  @override
  Widget build(BuildContext context) {
    int rowCount;
    if (flex) {
      rowCount = CalculateUtil.getJiugonggePercentage(mediaList.length);
    }  else {
      rowCount = this.rowCount;
    }
    return Container(
        child: LayoutBuilder(
          builder: (context, constrains) {
            double sideLength = (constrains.maxWidth - (rowCount - 1) * spacing - 4) / rowCount;
            return Wrap(
                alignment: WrapAlignment.start,
                spacing: spacing,
                runSpacing: runSpacing,
                children: List.generate(mediaList.length, (mediaIndex) {
                  return Container(
                      width: sideLength,
                      height: mediaList.length == 1 ? sideLength * (9 /16) : sideLength,
                      child: GestureDetector(
                        onTap: () {
                          // TODO 添加hero动画
                          NavigatorUtil.toMediaViewPage(context,
                              param: MediaViewPageParam(
                                  mediaList: mediaList,
                                  currentIndex: mediaIndex)
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: mediaList[mediaIndex].type == 1
                                ? CachedNetworkImage(
                              imageUrl: mediaList[mediaIndex].url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ImageHolder(
                                size: ScreenUtil().setSp(40),
                              ),
                              errorWidget: (context, url, error) => ImageErrorWidget(
                                size: ScreenUtil().setSp(40),
                              ),
                            )
                                : VideoPreview(
                              url: mediaList[mediaIndex].url,
                              placeHolder: Container(
                                alignment: Alignment.center,
                                width: sideLength,
                                height: mediaList.length == 1 ? sideLength * (9 /16) : sideLength,
                                child: SpinKitPumpingHeart(
                                  color: Theme.of(context).primaryColor,
                                  size: ScreenUtil().setSp(40),
                                  duration: Duration(milliseconds: 2000),
                                ),
                              ),
                            )),
                      ));
                }));
          },
        )
    );
  }
}