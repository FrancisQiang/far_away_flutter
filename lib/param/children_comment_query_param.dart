import 'package:flutter/material.dart';

class ChildrenCommentQueryParam {

  ChildrenCommentQueryParam(
      {@required this.parentId,
        @required this.currentPage});

  String parentId;

  int currentPage;
}