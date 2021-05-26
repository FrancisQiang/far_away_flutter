import 'package:dio/dio.dart';
import 'package:far_away_flutter/bean/response_bean.dart';
import 'package:far_away_flutter/constant/profile.dart';
import 'package:far_away_flutter/provider/global_info_provider.dart';
import 'package:far_away_flutter/util/api_method_util.dart';
import 'package:far_away_flutter/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EmotionEditPage extends StatefulWidget {
  final int emotionStatus;

  EmotionEditPage({@required this.emotionStatus});

  @override
  _EmotionEditPageState createState() => _EmotionEditPageState();
}

class _EmotionEditPageState extends State<EmotionEditPage> {
  choose(int type, GlobalInfoProvider globalInfoProvider) async {
    ResponseBean responseBean = await ApiMethodUtil.editUserInfo(emotionState: type);
    if (responseBean.isSuccess()) {
      globalInfoProvider.userInfoBean.emotionState = type;
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
            '修改情感状态',
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
            EmotionChooseItem(
              type: EmotionStatusConst.secret,
              choose: widget.emotionStatus == EmotionStatusConst.secret,
              onPressed: () {
                choose(EmotionStatusConst.secret, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            EmotionChooseItem(
              type: EmotionStatusConst.alwaysSolo,
              choose: widget.emotionStatus == EmotionStatusConst.alwaysSolo,
              onPressed: () {
                choose(EmotionStatusConst.alwaysSolo, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            EmotionChooseItem(
              type: EmotionStatusConst.waiting,
              choose: widget.emotionStatus == EmotionStatusConst.waiting,
              onPressed: () {
                choose(EmotionStatusConst.waiting, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            EmotionChooseItem(
              type: EmotionStatusConst.freedom,
              choose: widget.emotionStatus == EmotionStatusConst.freedom,
              onPressed: () {
                choose(EmotionStatusConst.freedom, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            EmotionChooseItem(
              type: EmotionStatusConst.loving,
              choose: widget.emotionStatus == EmotionStatusConst.loving,
              onPressed: () {
                choose(EmotionStatusConst.loving, globalInfoProvider);
              },
            ),
            Divider(
              height: 0.8,
              color: Colors.transparent,
            ),
            EmotionChooseItem(
              type: EmotionStatusConst.hardToSay,
              choose: widget.emotionStatus == EmotionStatusConst.hardToSay,
              onPressed: () {
                choose(EmotionStatusConst.hardToSay, globalInfoProvider);
              },
            ),
          ],
        ),
      );
    });
  }
}

class EmotionChooseItem extends StatelessWidget {
  final bool choose;

  final int type;

  final Function onPressed;

  EmotionChooseItem(
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
              child: Text(EmotionStatusConst.descriptionMap[type]),
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
