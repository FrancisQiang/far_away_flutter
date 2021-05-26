import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/constant/profile.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GenderEditPage extends StatefulWidget {
  final int gender;

  GenderEditPage({@required this.gender});

  @override
  _GenderEditPageState createState() => _GenderEditPageState();
}

class _GenderEditPageState extends State<GenderEditPage> {
  choose(int type, GlobalInfoProvider globalInfoProvider) async {
    ResponseBean responseBean = await ApiMethodUtil.editUserInfo(
        gender: type);
    if (responseBean.isSuccess()) {
      globalInfoProvider.userInfoBean.gender = type;
      globalInfoProvider.refresh();
      ToastUtil.showSuccessToast("修改成功");
    } else {
      ToastUtil.showErrorToast("修改失败");
    }
    Navigator.pop(context);
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
            '修改性别',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenderChooseItem(
              type: GenderConst.secret,
              choose: widget.gender == GenderConst.secret,
              onPressed: () {
                choose(GenderConst.secret, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            GenderChooseItem(
              type: GenderConst.male,
              choose: widget.gender == GenderConst.male,
              onPressed: () {
                choose(GenderConst.male, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            GenderChooseItem(
              type: GenderConst.female,
              choose: widget.gender == GenderConst.female,
              onPressed: () {
                choose(GenderConst.female, globalInfoProvider);
              },
            )
          ],
        ),
      );
    });
  }
}

class GenderChooseItem extends StatelessWidget {
  final bool choose;

  final int type;

  final Function onPressed;

  GenderChooseItem(
      {@required this.choose, @required this.type, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: FlatButton(
        hoverColor: Color.fromRGBO(240, 243, 245, 1),
        splashColor: Color.fromRGBO(240, 243, 245, 1),
        highlightColor: Color.fromRGBO(240, 243, 245, 1),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(GenderConst.descriptionMap[type]),
            ),
            choose
                ? Container(
                    child: Icon(
                    Icons.check,
                    color: Colors.blue,
                  ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
