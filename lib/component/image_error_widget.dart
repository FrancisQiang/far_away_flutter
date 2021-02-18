import 'package:flutter/material.dart';

class ImageErrorWidget extends StatelessWidget {
  final double size;

  ImageErrorWidget({this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        Icons.error,
        size: 30,
        color: Colors.redAccent,
      ),
    );
  }
}
