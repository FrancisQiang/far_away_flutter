import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/date_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BirthdayEditPage extends StatefulWidget {
  final int birthday;

  BirthdayEditPage({@required this.birthday});

  @override
  _BirthdayEditPageState createState() => _BirthdayEditPageState();
}

class _BirthdayEditPageState extends State<BirthdayEditPage> {
  int birthday;

  @override
  void initState() {
    birthday = widget.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(240, 243, 245, 1),
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Text(
            '修改生日',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Container(
              width: 50,
              child: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 10),
                icon: Text(
                  '保存',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28), letterSpacing: 0.5),
                ),
                onPressed: () async {
                  String constellation = DateUtil.getConstellation(birthday);
                  ResponseBean responseBean = await ApiMethodUtil.editUserInfo(
                    token: globalInfoProvider.jwt,
                    birthday: birthday,
                    constellation: constellation,
                  );
                  if (responseBean.isSuccess()) {
                    ToastUtil.showSuccessToast("修改成功");
                    globalInfoProvider.userInfoBean.birthday = birthday;
                    globalInfoProvider.userInfoBean.constellation =
                        constellation;
                    globalInfoProvider.refresh();
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData(),
              child: CalendarDatePicker(
                initialDate:
                    DateTime.fromMillisecondsSinceEpoch(widget.birthday),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
                onDateChanged: (DateTime datetime) {
                  birthday = datetime.millisecondsSinceEpoch;
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
