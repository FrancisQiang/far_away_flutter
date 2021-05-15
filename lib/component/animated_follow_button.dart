import 'package:flutter/material.dart';

class AnimatedFollowButton extends StatefulWidget {

  final double height;

  final double width;

  final bool follow;

  final Future<bool> Function() onPressed;

  AnimatedFollowButton({
    @required this.height,
    @required this.width,
    @required this.follow,
    @required this.onPressed
  });

  @override
  _AnimatedFollowButtonState createState() => _AnimatedFollowButtonState();
}

class _AnimatedFollowButtonState extends State<AnimatedFollowButton>
    with TickerProviderStateMixin {

  bool follow;

  @override
  void initState() {
    super.initState();
    follow = widget.follow;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(
          milliseconds: 150,
        ),
        reverseDuration: Duration(milliseconds: 150),
        transitionBuilder: (child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: follow ? FollowedButton(
          width: widget.width,
          height: widget.height,
          onPressed: () async {
            bool follow = await widget.onPressed();
            setState(() {
              this.follow = follow;
            });
          },
        ): FollowButton(
          width: widget.width,
          height: widget.height,
          onPressed: () async {
            bool follow = await widget.onPressed();
            setState(() {
              this.follow = follow;
            });
          },
        )
    );
  }
}

class FollowedButton extends StatelessWidget {

  final double width;

  final double height;

  final VoidCallback onPressed;

  FollowedButton({this.width, this.height, this.onPressed});

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
        color: Colors.transparent,
        child: Text(
          '已 关 注',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatelessWidget {

  final double width;

  final double height;

  final VoidCallback onPressed;

  FollowButton({this.width, this.height, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        color: Colors.orangeAccent,
        child: Text(
          '关 注',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
