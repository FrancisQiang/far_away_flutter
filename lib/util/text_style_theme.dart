import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyleTheme {
  static final TextStyle h1 = TextStyle(
      fontSize: ScreenUtil().setSp(45),
      color: Colors.black,
      letterSpacing: 2,
      fontWeight: FontWeight.bold);

  static final TextStyle h2 = TextStyle(
      fontSize: ScreenUtil().setSp(35),
      color: Colors.black,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold);

  static final TextStyle h3 = TextStyle(
      fontSize: ScreenUtil().setSp(32),
      color: Colors.black,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w500);

  static final TextStyle h4 = TextStyle(
    fontSize: ScreenUtil().setSp(25),
    color: Colors.black,
  );

  static final TextStyle h5 = TextStyle(
      fontSize: ScreenUtil().setSp(20),
      color: Colors.black
  );

  static final TextStyle h6 = TextStyle(
      fontSize: ScreenUtil().setSp(15),
      color: Colors.black,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w100);

  static final TextStyle subH1 = TextStyle(
      fontSize: ScreenUtil().setSp(45),
      color: Colors.black54,
      letterSpacing: 2,
      fontWeight: FontWeight.bold);

  static final TextStyle subH2 = TextStyle(
      fontSize: ScreenUtil().setSp(35),
      color: Colors.black54,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold);

  static final TextStyle subH3 = TextStyle(
      fontSize: ScreenUtil().setSp(34),
      color: Colors.black54,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w500);

  static final TextStyle subH4 = TextStyle(
    fontSize: ScreenUtil().setSp(28),
    letterSpacing: 0.2,
    color: Colors.black54,
  );

  static final TextStyle subH5 = TextStyle(
      fontSize: ScreenUtil().setSp(24),
      color: Colors.black54,
      letterSpacing: 0.2
  );

  static final TextStyle subH6 = TextStyle(
      fontSize: ScreenUtil().setSp(18),
      color: Colors.black54,
      letterSpacing: 0.2
  );

  static final TextStyle body = TextStyle(
    fontSize: ScreenUtil().setSp(30),
    color: Colors.black,
    letterSpacing: 0.5,
  );
}
