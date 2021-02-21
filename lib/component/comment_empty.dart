import 'package:far_away_flutter/util/text_style_theme.dart';
import 'package:flutter/material.dart';

class CommentEmpty extends StatelessWidget {

  final double iconHeight;

  final double iconWidth;

  CommentEmpty({this.iconHeight = 200, this.iconWidth = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: iconWidth,
              height: iconHeight,
              child: Image.asset(
                'assets/png/blank_comment.png'
              ),
            ),
            Container(
              child: Text(
                '掐指一算, 你能上神评~',
                style: TextStyleTheme.subH4,
              ),
            )
          ],
        ));
  }
}
