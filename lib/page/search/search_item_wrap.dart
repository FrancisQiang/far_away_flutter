import 'package:far_away_flutter/page/search/search_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchItemWrap extends StatefulWidget {
  SearchItemWrap({this.remove, @required this.children});

  final void Function(int index) remove;

  final List<SearchItem> children;

  @override
  _SearchItemWrapState createState() => _SearchItemWrapState();
}

class _SearchItemWrapState extends State<SearchItemWrap> {

  List<Widget> _children;

  List<Widget> _createChildren(List<SearchItem> items) {
    List<Widget> result = [];
    for (int i = 0; i < items.length; i++) {
      result.add(Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(20)),
        padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(10)),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: items[i].backgroundColor,),
        child: items[i].removeItem == null
            ? items[i].child
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
              child: items[i].child,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _children.removeAt(i);
                });
              },
              child: items[i].removeItem,
            )
          ],
        ),
      ));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _children = _createChildren(widget.children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: _children,
      ),
    );
  }
}