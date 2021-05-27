import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

import 'init_refresh_widget.dart';

class EasyRefreshWidget {

  static MaterialHeader getRefreshHeader(Color backgroundColor, Color valueColor) {
    return MaterialHeader(
      backgroundColor: backgroundColor,
      enableHapticFeedback: true,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
    );
  }

  static MaterialFooter getRefreshFooter(Color backgroundColor, Color valueColor) {
    return MaterialFooter(
      enableInfiniteLoad: false,
      enableHapticFeedback: true,
      backgroundColor: backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
    );
  }

  static final InitRefreshWidget initRefreshWidget = InitRefreshWidget();
}
