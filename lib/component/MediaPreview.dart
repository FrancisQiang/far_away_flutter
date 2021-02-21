import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/dynamic_detail_bean.dart';
import 'package:far_away_flutter/component/video_preview.dart';
import 'package:far_away_flutter/param/media_view_page_param.dart';
import 'package:far_away_flutter/util/calculate_util.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 动态 九宫格媒体组建 适配图片和视频类型
class MediaPreview extends StatelessWidget {

  final DynamicDetailBean dynamicDetailBean;

  final double spacing;

  final double runSpacing;

  MediaPreview({@required this.dynamicDetailBean, this.spacing = 4, this.runSpacing = 4});

  @override
  Widget build(BuildContext context) {
    int rowCount = CalculateUtil.getJiugonggePercentage(dynamicDetailBean.mediaList.length);
    return Container(
        child: LayoutBuilder(
          builder: (context, constrains) {
            double sideLength = (constrains.maxWidth - (rowCount - 1) * spacing) / rowCount;
            return Wrap(
                alignment: WrapAlignment.start,
                spacing: spacing,
                runSpacing: runSpacing,
                children: List.generate(dynamicDetailBean.mediaList.length, (mediaIndex) {
                  return Container(
                      width: sideLength,
                      height: sideLength,
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtil.toMediaViewPage(context,
                              param: MediaViewPageParam(
                                  mediaList: dynamicDetailBean.mediaList,
                                  currentIndex: mediaIndex,
                                  businessId: dynamicDetailBean.id,
                                  businessType: 1));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: dynamicDetailBean.mediaList[mediaIndex].type == 1
                                ? Hero(
                              tag: '1:${dynamicDetailBean.id}:tag:$mediaIndex',
                              child: CachedNetworkImage(
                                imageUrl:
                                dynamicDetailBean.mediaList[mediaIndex].url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  width: sideLength,
                                  height: sideLength,
                                  child: SpinKitPumpingHeart(
                                    color: Theme.of(context).primaryColor,
                                    size: ScreenUtil().setSp(40),
                                    duration: Duration(milliseconds: 2000),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.redAccent,
                                ),
                              ),
                            )
                                : VideoPreview(
                              url: dynamicDetailBean.mediaList[mediaIndex].url,
                              placeHolder: Container(
                                alignment: Alignment.center,
                                width: sideLength,
                                height: sideLength,
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