import 'package:far_away_flutter/constant/my_color.dart';
import 'package:far_away_flutter/router/application.dart';
import 'package:far_away_flutter/router/routes.dart';
import 'package:far_away_flutter/util/provider_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(MyApp());
  // 设置顶部状态栏背景透明
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor:Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orangeAccent,
          primaryColorDark: Colors.orangeAccent[700],
          primaryColorLight: Colors.orange[200],
          primarySwatch: MyColor.orangeThemeColor,
          backgroundColor: MyColor.backgroundColor
        ),
        home: ProviderUtil.getMainPage()
    );
  }
}