import 'package:far_away_flutter/component/my_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HotelRecruitmentPage extends StatelessWidget {
  final List<String> imgUrlList = [
    'https://inews.gtimg.com/newsapp_bt/0/12755870814/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870814/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870814/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870814/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870826/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870817/641',
    'https://inews.gtimg.com/newsapp_bt/0/12755870825/641',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StaggeredGridView.countBuilder(
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: ScreenUtil().setWidth(20),
        mainAxisSpacing: ScreenUtil().setHeight(15),
        itemCount: imgUrlList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        Image.network(imgUrlList[index]),
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
                                    ' 印度尼西亚',
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
                                    FontAwesomeIcons.heart,
                                    color: Colors.white70,
                                    size: ScreenUtil().setSp(24),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    ' 521',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: ScreenUtil().setSp(24),
                                        fontWeight: FontWeight.bold),
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
                              backgroundImage: NetworkImage(
                                  'https://img2.woyaogexing.com/2020/11/21/a51ab28de137444e8821866e35e33bca!400x400.jpeg'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(8)),
                              child: Text(
                                '测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.4,
                                    color: Colors.black87),
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
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      ),
    );
  }
}
