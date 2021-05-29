import 'package:far_away_flutter/bean/recruit_info_bean.dart';
import 'package:far_away_flutter/param/recruit_param.dart';
import 'package:far_away_flutter/util/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class RecruitInfoPreviewCard extends StatelessWidget {
  final RecruitDetailInfoBean recruitDetailInfoBean;

  RecruitInfoPreviewCard({@required this.recruitDetailInfoBean});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: PhysicalModel(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {
            NavigatorUtil.toRecruitDetailPage(
              context,
              param: RecruitDetailPageParam(
                recruitDetailInfoBean: recruitDetailInfoBean,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Image.network(recruitDetailInfoBean.cover),
                  Positioned(
                    left: ScreenUtil().setWidth(8),
                    bottom: ScreenUtil().setHeight(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(5)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black38,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: ScreenUtil().setSp(20),
                            ),
                          ),
                          Container(
                            child: Text(
                              recruitDetailInfoBean.location,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: ScreenUtil().setWidth(8),
                    bottom: ScreenUtil().setHeight(8),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white70,
                              size: ScreenUtil().setSp(28),
                            ),
                          ),
                          Container(
                            child: Text(
                              ' ${recruitDetailInfoBean.thumbCount}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: ScreenUtil().setSp(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(38),
                      height: ScreenUtil().setWidth(38),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(recruitDetailInfoBean.userAvatar),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                        child: Text(
                          recruitDetailInfoBean.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
