import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MajorEditPage extends StatefulWidget {
  final String major;

  MajorEditPage({@required this.major});

  @override
  _MajorEditPageState createState() => _MajorEditPageState();
}

class _MajorEditPageState extends State<MajorEditPage> {
  TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.major);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalInfoProvider>(
        builder: (context, globalInfoProvider, child) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(240, 243, 245, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '修改专业',
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
                  ResponseBean responseBean = await ApiMethodUtil.editUserInfo(
                      token: globalInfoProvider.jwt,
                      major: _editingController.text);
                  if (responseBean.isSuccess()) {
                    ToastUtil.showSuccessToast("修改成功");
                    globalInfoProvider.userInfoBean.major =
                        _editingController.text;
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
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 8),
              color: Colors.white,
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    border: InputBorder.none),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, top: 5),
              child: Text(
                '请填写您的专业',
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenUtil().setSp(24)),
              ),
            )
          ],
        ),
      );
    });
  }
}
