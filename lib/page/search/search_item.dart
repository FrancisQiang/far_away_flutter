import 'package:flutter/material.dart';

class SearchItem {
  SearchItem(
      {this.backgroundColor = Colors.grey,
      @required this.child,
      this.removeItem});

  final Color backgroundColor;
  final Widget child;
  final Widget removeItem;
}
