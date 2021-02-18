import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class PhoneLoginBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(10)
      ),
      alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Text('登录/注册 表示同意'),
            ),
            Container(
              child: Text(
                '用户协议',
                style: TextStyle(
                    color: Colors.brown, decoration: TextDecoration.underline),
              ),
            ),
            Container(
              child: Text(
                ' | ',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
            ),
            Container(
              child: Text(
                '隐私条款',
                style: TextStyle(
                    color: Colors.brown, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ));
  }
}
