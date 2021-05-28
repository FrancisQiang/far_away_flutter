import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CommentChosenProvider with ChangeNotifier {

  String targetUserId;

  String targetBizId;

  String pid;

  List<File> assetFileList = [];

  String content;

  String targetUsername;

  void refresh() => notifyListeners();

}