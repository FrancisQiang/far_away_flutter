import 'package:flutter/material.dart';

class AnimatedLoginButton extends StatefulWidget {
  final AnimatedLoginButtonStatusController controller;

  final Widget loginChild;

  final Widget loadingChild;

  final double height;

  final double originLength;

  final double criticalLength;

  final Duration duration;

  // 登录函数
  final VoidCallback login;

  final Curve curve;

  AnimatedLoginButton({@required this.controller,
    @required this.loginChild,
    @required this.loadingChild,
    @required this.height,
    @required this.originLength,
    @required this.criticalLength,
    @required this.login,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.ease});

  @override
  _AnimatedLoginButtonState createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<AnimatedLoginButton>
    with TickerProviderStateMixin {

  AnimationController _animationController;

  Animation _buttonLengthAnimation;

@override
void initState() {
  super.initState();
  widget?.controller?._setState(this);
  _animationController =
      AnimationController(vsync: this, duration: widget.duration);
  _buttonLengthAnimation = Tween<double>(
      begin: widget.originLength, end: widget.criticalLength)
      .animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve))
    ..addListener(() {
      setState(() {});
    });
}

  @override
  void dispose() {
    super.dispose();
  }

  refresh() => setState(() {
    if(widget.controller._status == LoginStatus.error) {
      _animationController.reverse();
      widget.controller.setStatus(LoginStatus.available);
    }
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _buttonLengthAnimation.value,
      height: widget.height,
      child: RaisedButton(
          color: Colors.orange,
          splashColor: Colors.orangeAccent,
          focusColor: Colors.orange,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          onPressed: widget.controller.status == LoginStatus.available
              ? () {
            _animationController.forward();
            widget.controller.setStatus(LoginStatus.disable);
            widget.login();
            setState(() {});
          }
              : null,
          child: _buttonLengthAnimation.value > widget.criticalLength
              ? widget.loginChild
              : SizedBox(
            height: widget.height / 2,
            width: widget.height / 2,
            child: widget.loadingChild,
          )
      )
      ,
    );
  }
}

enum
LoginStatus {disable, available, error}

class AnimatedLoginButtonStatusController {
  _AnimatedLoginButtonState _state;

  LoginStatus _status = LoginStatus.disable;

  void setStatus(LoginStatus status) {
    _status = status;
    if (_state?.mounted ?? false) {
      _state?.refresh();
    }
  }

  void _setState(_AnimatedLoginButtonState state) {
    if (this?._state == null) {
      this?._state = state;
    } else {
      this._state = null;
      this._state = state;
    }
  }

  LoginStatus get status => _status;
}
