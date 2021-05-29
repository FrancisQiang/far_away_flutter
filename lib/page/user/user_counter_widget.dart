import 'package:far_away_flutter/bean/user_info_bean.dart';
import 'package:far_away_flutter/page/user/user_info_widget.dart';
import 'package:flutter/material.dart';


class UserCounterWidget extends StatelessWidget {

  final UserInfoBean userInfoBean;

  UserCounterWidget({this.userInfoBean});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        UserActiveInfoWidget(
          title: "获赞",
          value: userInfoBean == null
              ? ''
              : userInfoBean.thumbCount
              .toString(),
        ),
        UserActiveInfoWidget(
          title: "关注",
          value: userInfoBean == null
              ? ''
              : userInfoBean.followCount
              .toString(),
        ),
        UserActiveInfoWidget(
          title: "粉丝",
          value: userInfoBean == null
              ? ''
              : userInfoBean.fansCount
              .toString(),
        ),
      ],
    );
  }
}
