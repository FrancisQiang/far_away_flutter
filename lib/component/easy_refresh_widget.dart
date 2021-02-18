import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class EasyRefreshWidget {

  static MaterialHeader refreshHeader =  MaterialHeader(
    backgroundColor: Colors.white,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
  );

  static MaterialFooter refreshFooter = MaterialFooter(
    backgroundColor: Colors.white,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
  );

}