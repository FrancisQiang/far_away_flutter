import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleMovingBubble extends StatefulWidget {

  /// 相对位置
  final double top;

  /// 相对位置
  final double left;

  /// 运动半径
  final double movingRadius;

  /// 动画效果
  final Curve curve;

  /// 动画时长
  final Duration duration;

  /// 直径
  final double diameter;

  /// 背景色
  final Color backgroundColor;

  final Widget child;

  /// 弧度
  final double radians;

  CircleMovingBubble({
        @required this.top,
        @required this.left,
        @required this.diameter,
        @required this.child,
        @required this.radians,
        this.backgroundColor = Colors.black38,
        this.movingRadius = 10,
        this.curve = Curves.linear,
        this.duration = const Duration(seconds: 8)});

  @override
  _CircleMovingBubbleState createState() => _CircleMovingBubbleState();
}

class _CircleMovingBubbleState extends State<CircleMovingBubble>
    with TickerProviderStateMixin {

  double _top;

  double _left;

  AnimationController _controller;

  Animation<double> _bubbleMovingAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: false);
    CurvedAnimation curve = CurvedAnimation(
        parent: _controller, curve: widget.curve);
    _bubbleMovingAnimation = Tween<double>(
        begin: -math.pi, end: math.pi)
        .animate(curve)
      ..addListener(() {
        setState(() {
          _top = widget.top +
              widget.movingRadius * math.sin(_bubbleMovingAnimation.value);
          _left = widget.left +
              widget.movingRadius * math.cos(_bubbleMovingAnimation.value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _top,
        left: _left,
        child: Container(
          child: Draggable(
            childWhenDragging: Container(),
            feedback: Container(
                alignment: Alignment.center,
                width: widget.diameter,
                height: widget.diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor,
                ),
                child: widget.child
            ),
            child: Container(
                alignment: Alignment.center,
                width: widget.diameter,
                height: widget.diameter,
                transform: Matrix4.rotationZ(widget.radians),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor,
                ),
                child: widget.child
            ),
          ),
        )
    );
  }
}
