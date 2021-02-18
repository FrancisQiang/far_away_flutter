import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AidEducationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 8,
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
              child: Stack(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(50),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey[300]),
                          margin: EdgeInsets.only(
                              left: index == 0 ? 0 : ScreenUtil().setWidth(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: ScreenUtil().setHeight(5)),
                          child: Text(
                            '云南',
                            style: TextStyle(fontSize: ScreenUtil().setSp(28), letterSpacing: 0.5),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: ScreenUtil().setHeight(50),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //底色,阴影颜色
                          offset: Offset(-5.0, 0), //阴影位置,从什么位置开始
                          blurRadius: 3,
                        )
                      ]),
                      child: InkWell(
                        child: Icon(Icons.menu, color: Colors.black38,),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(25)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(230),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        'http://re.go9999.com/upload/web/themes/eev1/pic/pic_zj.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        height: ScreenUtil().setHeight(230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '四姑娘山琴心小学',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(25)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 四川·四姑娘山',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(24)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 4人',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 已报名4人',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: Colors.red,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 3699',
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(25)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(230),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        'http://re.go9999.com/upload/site/_1602747840_Ia0j0f6EU5.jpg?v=1',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        height: ScreenUtil().setHeight(230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '四姑娘山琴心小学',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(25)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 四川·四姑娘山',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(24)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 4人',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 已报名4人',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: Colors.red,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 3699',
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(25)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(230),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        'http://re.go9999.com/upload/site/_1592296049_OF1Ey8AkEH.jpg?v=2',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        height: ScreenUtil().setHeight(230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '四姑娘山琴心小学',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(25)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 四川·四姑娘山',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(24)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 4人',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 已报名4人',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: Colors.red,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 3699',
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(25)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(230),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        'http://re.go9999.com/upload/site/_1570176635_8VS972D3E9.jpg?v=1',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        height: ScreenUtil().setHeight(230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '四姑娘山琴心小学',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(25)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 四川·四姑娘山',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(24)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 4人',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 已报名4人',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: Colors.red,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 3699',
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize:
                                                    ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(15),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(25)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(230),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        'http://re.go9999.com/upload/index/_1593593505_Y9M43C9st0.jpg?v=1',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                        EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        height: ScreenUtil().setHeight(230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '四姑娘山琴心小学',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(25)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: ScreenUtil().setSp(24),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 四川·四姑娘山',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(24)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 4人',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.people,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 已报名4人',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: Colors.red,
                                              size: ScreenUtil().setSp(35)),
                                        ),
                                        Container(
                                          child: Text(
                                            ' 3699',
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize:
                                                ScreenUtil().setSp(24),
                                                letterSpacing: 0.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
