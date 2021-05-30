import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeUserListCard extends StatelessWidget {

  final Function onTap;

  ChangeUserListCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '换一批',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  color: Colors.black54
              ),
            ),
          )
      ),
    );
  }
}
