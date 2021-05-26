import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InitRefreshWidget extends StatelessWidget {

  final double height;

  final double width;

  final Color color;

  InitRefreshWidget(
      {this.height = 200.0,
      this.width = 300.0,
      this.color = Colors.orangeAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: SizedBox(
        height: height,
        width: width,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: SpinKitFadingCube(
                  color: color,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
