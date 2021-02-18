import 'package:flutter/cupertino.dart';

class CommentQueryParam {
  CommentQueryParam(
      {@required this.businessType,
      @required this.businessId,
      @required this.currentPage});

  int businessType;

  String businessId;

  int currentPage;
}
