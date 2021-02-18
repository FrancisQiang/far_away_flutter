import 'dart:async';

import 'package:far_away_flutter/component/animated_login_button.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class SendCodeWidget extends StatefulWidget {
  final int count;
  final VoidCallback send;
  final SendCodeWidgetStatusController controller;
  final Color color;
  final Color disabledColor;
  final Color textColor;
  final Color disabledTextColor;

  final String beforeSendText;
  final String afterSendText;
  final String waitingText;
  final double fontSize;

  SendCodeWidget(
      {@required this.send,
      @required this.controller,
      this.count = 60,
      this.disabledColor = Colors.black38,
      this.color = Colors.grey,
      this.textColor = Colors.black,
      this.disabledTextColor = Colors.white70,
      this.fontSize = 10.0,
      this.beforeSendText = "获取验证码",
      this.afterSendText = "重新发送",
      this.waitingText = "重新发送(%ds)"});

  @override
  _SendCodeWidgetState createState() => _SendCodeWidgetState();
}

class _SendCodeWidgetState extends State<SendCodeWidget> {
  String _buttonText;
  int _count;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget?.controller?._setState(this);
    _buttonText = widget.beforeSendText;
    _count = widget.count;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_count == 0) {
        setState(() {
          _timer.cancel();
          _count = widget.count;
          _buttonText = widget.afterSendText;
          widget.controller.setStatus(SendStatus.available);
        });
        return;
      }
      setState(() {
        _count--;
        _buttonText = sprintf(widget.waitingText, [_count]);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  refresh() {
    setState(() {
      if (_timer != null &&
              _timer.isActive &&
              widget.controller.status == SendStatus.available) {
        _timer?.cancel();
        _count = widget.count;
        _buttonText = widget.afterSendText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        color: widget.color,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        disabledColor: widget.disabledColor,
        onPressed: widget.controller.status == SendStatus.available
            ? () {
                _startTimer();
                widget.send();
                widget.controller.setStatus(SendStatus.disable);
              }
            : null,
        child: Text(
          _buttonText,
          style: TextStyle(fontSize: widget.fontSize),
        ),
      ),
    );
  }
}

enum SendStatus {disable, available}

class SendCodeWidgetStatusController {
  _SendCodeWidgetState _state;

  SendStatus _status = SendStatus.disable;

  void setStatus(SendStatus status) {
    _status = status;
    if (_state?.mounted ?? false) {
      _state?.refresh();
    }
  }

  void _setState(_SendCodeWidgetState state) {
    if (this?._state == null) {
      this?._state = state;
    } else {
      this._state = null;
      this._state = state;
    }
  }

  SendStatus get status => _status;
}
