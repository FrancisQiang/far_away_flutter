import 'package:flutter/material.dart';

class AnimatedFollowButton extends StatelessWidget {
  final double height;

  final double width;

  final bool follow;

  final Function() onPressed;

  final Widget followedChild;

  final Widget followChild;

  final Color followedBackColor;

  final Color followBackColor;

  AnimatedFollowButton(
      {@required this.height,
      @required this.width,
      @required this.follow,
      @required this.onPressed,
      this.followedChild,
      this.followChild,
      this.followBackColor,
      this.followedBackColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(
          milliseconds: 300,
        ),
        reverseDuration: Duration(
          milliseconds: 300,
        ),
        transitionBuilder: (child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: follow
            ? FollowedButton(
                width: width,
                height: height,
                onPressed: () async {
                  await onPressed();
                },
                child: followedChild,
                backColor: followedBackColor,
              )
            : FollowButton(
                width: width,
                height: height,
                onPressed: () async {
                  await onPressed();
                },
                child: followChild,
                backColor: followBackColor,
              ));
  }
}

class FollowedButton extends StatelessWidget {
  final double width;

  final double height;

  final VoidCallback onPressed;

  final Widget child;

  final Color backColor;

  FollowedButton(
      {this.width, this.height, this.onPressed, this.child, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.1,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        color: backColor == null ? Colors.transparent : backColor,
        child: child == null
            ? Text(
                '已 关 注',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            : child,
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  final double width;

  final double height;

  final VoidCallback onPressed;

  final Widget child;

  final Color backColor;

  FollowButton(
      {this.width, this.height, this.onPressed, this.child, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        color: backColor == null ? Colors.orangeAccent : backColor,
        child: child == null
            ? Text(
                '关 注',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            : child,
      ),
    );
  }
}
