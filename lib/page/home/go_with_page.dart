import 'package:far_away_flutter/constant/my_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(5)),
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
                                          top: ScreenUtil().setHeight(10)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(15),
                                        vertical: ScreenUtil().setHeight(8),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: MyColor.colorList[index]),
                                      child: Text(
                                        index % 2 == 0 ? '西藏' : '香格里拉',
                                        style: TextStyle(letterSpacing: 0.5),
                                      ),
                                    );
                                  })))
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/974f70e2756e4823b314760d7a480917!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/2079b3af761045be8bf7c9f09fe4f011!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                'https://img2.woyaogexing.com/2020/11/21/af5d6e39a7da4b9099ec29f08904f5ca!400x400.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(345),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
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
                                  child: Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.black,
                                size: ScreenUtil().setSp(35),
                              )),
                              Container(
                                  child: Icon(
                                FontAwesomeIcons.commentDots,
                                size: ScreenUtil().setSp(35),
                              )),
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
