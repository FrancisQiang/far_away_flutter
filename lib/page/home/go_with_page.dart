import 'package:far_away_flutter/constant/my_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GoWithPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(80),
                          child: ClipOval(
                            child: Image.network(
                              'https://img2.woyaogexing.com/2020/11/21/af130512fbf84c9baac6f22920ecc60e!400x400.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      'FrancisQ',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(25),
                                          letterSpacing: 0.6,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              )),
                              Container(
                                child: Text(
                                  '搞笑领域宝藏男孩',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.black45,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.access_time_outlined,
                                  color: Colors.red,
                                  size: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10)),
                                child: Text(
                                  '2020-07-20 ~ 2020-7-25',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(5)
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(650),
                                child: Wrap(
                                  children: List.generate(10, (index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10),
                                        top: ScreenUtil().setHeight(10)
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(15),
                                        vertical: ScreenUtil().setHeight(8),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: MyColor.colorList[index]
                                      ),
                                      child: Text(
                                          index % 2 == 0 ? '西藏' : '香格里拉',
                                        style: TextStyle(
                                          letterSpacing: 0.5
                                        ),
                                      ),
                                    );
                                  })
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setWidth(20)),
                    child: Text(
                      '七月底有没有从成都出发去拉萨的，我在新都桥等你。😁求带。一人一行李箱。完全不用操心我，常旅行的。穷游哦。比较穷。摩托车汽车都可以。嘿嘿',
                      style: TextStyle(
                          letterSpacing: 0.5, fontSize: ScreenUtil().setSp(25)),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                      width: ScreenUtil().setWidth(750),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        runSpacing: ScreenUtil().setHeight(10),
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/974f70e2756e4823b314760d7a480917!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/2079b3af761045be8bf7c9f09fe4f011!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/af5d6e39a7da4b9099ec29f08904f5ca!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/fa2f3389542b4fddac8afa52bcf1e67b!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '11月17日 09:20',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(22),
                                letterSpacing: 0.2),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(5)),
                            child: Icon(
                              Icons.location_on,
                              color: MyColor.mainColor,
                              size: ScreenUtil().setSp(25),
                            )),
                        Container(
                          child: Text(
                            '江苏大学',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(22),
                                letterSpacing: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                    ),
                    padding: EdgeInsets.symmetric(
                        // horizontal: ScreenUtil().setWidth(20)
                        ),
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(500),
                          child: Row(
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(95),
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                        width: ScreenUtil().setWidth(35),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      left: ScreenUtil().setWidth(30),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                          width: ScreenUtil().setWidth(35),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: ScreenUtil().setWidth(60),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                          width: ScreenUtil().setWidth(35),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  ' 等765人觉得很赞',
                                  style: TextStyle(
                                      letterSpacing: 0.3,
                                      fontSize: ScreenUtil().setSp(21),
                                      color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/svg/thumb_inactive.svg',
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                ),
                              ),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/svg/comment.svg',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              )),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/svg/share.svg',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              padding: EdgeInsets.all(ScreenUtil().setWidth(22)),
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(80),
                          child: ClipOval(
                            child: Image.network(
                              'https://img2.woyaogexing.com/2020/11/21/af130512fbf84c9baac6f22920ecc60e!400x400.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          'FrancisQ',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(25),
                                              letterSpacing: 0.6,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                child: Text(
                                  '搞笑领域宝藏男孩',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.black45,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.access_time_outlined,
                                  color: Colors.red,
                                  size: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10)),
                                child: Text(
                                  '2020-07-20 ~ 2020-7-25',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5)
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: ScreenUtil().setSp(38),
                                ),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(650),
                                  child: Wrap(
                                      children: List.generate(10, (index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10),
                                              top: ScreenUtil().setHeight(10)
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ScreenUtil().setWidth(15),
                                            vertical: ScreenUtil().setHeight(8),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: MyColor.colorList[index]
                                          ),
                                          child: Text(
                                            index % 2 == 0 ? '西藏' : '香格里拉',
                                            style: TextStyle(
                                                letterSpacing: 0.5
                                            ),
                                          ),
                                        );
                                      })
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        right: ScreenUtil().setWidth(20)),
                    child: Text(
                      '重庆 80后，喜欢旅行自驾，约人国庆喀什自驾（2020.9.30-2020.10.3） 线路如下： 9.30 Day 1 喀什-塔县 G314 '
                          '中途奥依塔克冰川 白沙湖 公格尔九别峰 卡拉库里湖 慕士塔格峰 住塔县（塔县需办理边防证） 10.1 Day 2 上午塔县-红旗拉普国门 '
                          '（可能未开放，预备石头城 阿拉尔金草滩）下午塔县周边村落：提孜那普乡、塔合曼乡 住塔县 10.2 Day3 塔县-莎车 住莎车'
                          '（备选盘龙古道 到阿克陶 住宿） 10.3 day4 上午莎车周边溜达 金胡杨公园 下午回喀什 住喀什（如果昨天在阿克陶 今天就阿克陶回喀什，逛喀什古城）'
                          ' 10.4暂定火车去阿克苏待到10.7返回重庆 有意者请微信联系：zz1214zz',
                      style: TextStyle(
                          letterSpacing: 0.5, fontSize: ScreenUtil().setSp(25),),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                      width: ScreenUtil().setWidth(750),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        runSpacing: ScreenUtil().setHeight(10),
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/e606e34c8f304ef6abcb08b52c1bfeea!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/561490777a774e1bbee4c55acb7c61ce!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/f88106f38b9e449da61d91935184667d!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/f349d609eda249538d738a2ac0059383!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/7c7dda91e3e049afb44d4750eefb0f85!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/3c3490e8a09548f6a671b33390a87047!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/13041a93db4240f0a620b1cc919de02e!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/8b7c5c5552db4251a3f735f0f403e453!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(230),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/18/b46fe5ac42b94245b3504868372cd40c!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            '11月17日 09:20',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(22),
                                letterSpacing: 0.2),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(5)),
                            child: Icon(
                              Icons.location_on,
                              color: MyColor.mainColor,
                              size: ScreenUtil().setSp(25),
                            )),
                        Container(
                          child: Text(
                            '江苏大学',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(22),
                                letterSpacing: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      // horizontal: ScreenUtil().setWidth(20)
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(500),
                          child: Row(
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(95),
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                        width: ScreenUtil().setWidth(35),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      left: ScreenUtil().setWidth(30),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                          width: ScreenUtil().setWidth(35),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: ScreenUtil().setWidth(60),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://img2.woyaogexing.com/2020/11/21/8e614c09dc9c45f19e7ded96d9e7cdcd!400x400.jpeg',
                                          width: ScreenUtil().setWidth(35),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  ' 等765人觉得很赞',
                                  style: TextStyle(
                                      letterSpacing: 0.3,
                                      fontSize: ScreenUtil().setSp(21),
                                      color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/svg/thumb_inactive.svg',
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                ),
                              ),
                              Container(
                                  child: SvgPicture.asset(
                                    'assets/svg/comment.svg',
                                    width: ScreenUtil().setWidth(40),
                                    height: ScreenUtil().setWidth(40),
                                  )),
                              Container(
                                  child: SvgPicture.asset(
                                    'assets/svg/share.svg',
                                    width: ScreenUtil().setWidth(40),
                                    height: ScreenUtil().setWidth(40),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
