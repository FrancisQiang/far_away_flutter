import 'package:flutter/material.dart';


class MyIcons {
  static const IconData PLUS = const _MyIconData(0xe62a);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(
    codePoint,
    fontFamily: 'MyIcons',
  );
}