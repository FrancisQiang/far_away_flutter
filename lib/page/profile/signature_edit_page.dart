import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignatureEditPage extends StatefulWidget {
  final String signature;

  SignatureEditPage({@required this.signature});

  @override
  _SignatureEditPageState createState() => _SignatureEditPageState();
}

class _SignatureEditPageState extends State<SignatureEditPage> {
  TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.signature);
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
            '修改签名',
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
                      // fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(28),
                      letterSpacing: 0.5),
                ),
                onPressed: () async {
                  ResponseBean responseBean = await ApiMethodUtil.editUserInfo(
                      token: globalInfoProvider.jwt,
                      signature: _editingController.text);
                  if (responseBean.isSuccess()) {
                    ToastUtil.showSuccessToast("修改成功");
                    globalInfoProvider.userInfoBean.signature =
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
              color: Colors.white,
              constraints: BoxConstraints(minHeight: 110),
              child: TextField(
                controller: _editingController,
                minLines: 1,
                maxLines: 10,
                maxLength: 50,
                decoration: InputDecoration(
                  isDense: false,
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, top: 5),
              child: Text(
                '2~50个字符，介绍一下你自己吧',
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
