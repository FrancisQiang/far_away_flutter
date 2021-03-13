import 'package:flutter/material.dart';

class ListEmptyWidget extends StatelessWidget {

  final double height;

  final double width;

  ListEmptyWidget({this.height = 300, this.width = 350});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height,
              width: width,
              child: Image.asset(
                'assets/png/blank_page.png'
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '空空如也 ...',
                style: TextStyle(color: Colors.black54, letterSpacing: 0.5),
              ),
            )
          ],
        ));
  }
}
