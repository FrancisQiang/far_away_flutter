import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'choose_button_line_widget.dart';
import 'login_choose_title_widget.dart';

class LoginChoosePage extends StatefulWidget {
  @override
  _LoginChoosePageState createState() => _LoginChoosePageState();
}

class _LoginChoosePageState extends State<LoginChoosePage> with TickerProviderStateMixin {

  Animation<double> backgroundOpacityAnimation;
  AnimationController backgroundOpacityAnimationController;
  double opacityFirst;
  double opacitySecond;
  List<String> imgList;
  int index;
  Timer timer;

  @override
  void initState() {
    index = 0;
    timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      setState(() {
        index = (index + 1) % 4;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景透明化前后交替 实现切换效果
          AnimatedSwitcher(
            duration: Duration(seconds: 4),
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            transitionBuilder: (child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              key: ValueKey<String>('assets/background/background$index.jpg'),
              child: Image.asset('assets/background/background$index.jpg', fit: BoxFit.cover,),
            ),
          ),
          // 高斯模糊 会影响性能 暂时去掉
         // Positioned.fill(
         //   child: BackdropFilter(
         //     filter: ImageFilter.blur(sigmaX:3, sigmaY:3),
         //     child:Container(
         //       decoration:BoxDecoration(
         //         color:(Color.fromRGBO(225, 225,225, 1)).withOpacity(0.06),
         //       ),
         //     ),
         //   ),
         // ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                LoginChooseTitle(),
                ChooseButtonLineWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}