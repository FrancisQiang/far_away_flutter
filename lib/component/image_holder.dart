import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageHolder extends StatelessWidget {

  final double size;

  ImageHolder({this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SpinKitPumpingHeart(
        color: Theme.of(context).primaryColor,
        size: size,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}
