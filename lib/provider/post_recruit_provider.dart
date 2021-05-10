import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
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

  bool postEnable() {
    String content = convert.jsonEncode(markdownController.document.toJson());
    return cover != null && titleController.text != null && titleController.text.isNotEmpty && content != null && content.isNotEmpty && locationDetail != null;
  }

  /// Loads the document to be edited in Zefyr.
  // NotusDocument _loadDocument() {
  //   var json = convert.jsonDecode(
  //       '[{\"insert\": \"Ghjvc\\n\" }, { 	\"insert\": \"​\", 	\"attributes\": { 		\"embed\": { 			\"type\": \"image\", 			\"source\": \"http://faraway.francisqiang.top/FjoKvvpRkHck_7p6RTEY40Xp7_DB\" 		} 	} }, { 	\"insert\": \"\\n\" }]');
  //   // final Delta delta = Delta()..insert("\n");
  //   return NotusDocument.fromJson(json);
  //   // return NotusDocument.fromDelta(delta);
  // }

  void refresh() {
    notifyListeners();
  }

}
