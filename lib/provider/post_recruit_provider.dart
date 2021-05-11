import 'package:far_away_flutter/custom_zefyr/widgets/controller.dart';
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';
import 'dart:convert' as convert;
import 'package:quill_delta/quill_delta.dart';

class PostRecruitProvider with ChangeNotifier {
  PostRecruitProvider() {
    titleController = TextEditingController()..addListener(() {
      notifyListeners();
    });
    Delta delta = Delta()..insert("\n");
    NotusDocument.fromDelta(delta);
    markdownController = ZefyrController(NotusDocument.fromDelta(delta))..addListener(() {
      notifyListeners();
    });
  }

  String cover;

  String locationCode;

  String locationDetail;

  TextEditingController titleController;

  ZefyrController markdownController;

  FocusNode markdownFocusNode = FocusNode();

  bool postEnable() {
    String content = convert.jsonEncode(markdownController.document.toJson());
    return cover != null && titleController.text != null && titleController.text.isNotEmpty && content != null && content.isNotEmpty && locationDetail != null;
  }

  void refresh() {
    notifyListeners();
  }

}
