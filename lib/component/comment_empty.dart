import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommentEmpty extends StatelessWidget {

  final double width;

  final double height;

  final EdgeInsetsGeometry margin;

  final EdgeInsetsGeometry padding;

  CommentEmpty({this.width = 200, this.height = 300, this.margin = const EdgeInsets.all(15), this.padding = const EdgeInsets.symmetric(vertical: 20)});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        padding: padding,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              height:height,
              width: width,
              child: SvgPicture.asset(
                  'assets/svg/blank_comment.svg'),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 10),
              child: Text(
                '掐指一算, 你能上神评~',
                style: TextStyleTheme.subH2,
              ),
            )
          ],
        ));
  }
}
