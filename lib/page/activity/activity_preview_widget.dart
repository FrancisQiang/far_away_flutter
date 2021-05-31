import 'package:cached_network_image/cached_network_image.dart';
import 'package:far_away_flutter/bean/activity_preview_bean.dart';
import 'package:far_away_flutter/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ActivityPreviewCard extends StatelessWidget {
  final ActivityPreviewBean activityPreviewBean;

  ActivityPreviewCard({this.activityPreviewBean});

  List<String> _getPictureList() {
    String pictureList = activityPreviewBean.pictureList;
    if (!StringUtil.isEmpty(pictureList)) {
      return pictureList.split(",");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> pictureList = _getPictureList();
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(170),
            width: ScreenUtil().setWidth(300),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            pictureList[index],
                          ))),
                );
              },
              itemCount: pictureList.length,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      size: 4, activeSize: 5, space: 1.5)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(22)
            ),
            width: ScreenUtil().setWidth(364),
            height: ScreenUtil().setHeight(170),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          activityPreviewBean.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.whatshot,
                                color: Colors.red,
                                size: ScreenUtil().setSp(25),
                              ),
                            ),
                            Container(
                              child: Text('${activityPreviewBean.hot}', style: TextStyle(
                                fontSize: ScreenUtil().setSp(25),
                                color: Colors.red
                              ),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    activityPreviewBean.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(26)
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
