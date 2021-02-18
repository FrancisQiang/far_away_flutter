import 'package:flutter/material.dart';

class LoginInputTextField extends StatefulWidget {
  final TextEditingController controller;

  final Function(String) onChange;

  final bool autoFocus;

  final InputDecoration inputDecoration;

  LoginInputTextField(
      {@required this.controller,
      @required this.inputDecoration,
      this.onChange,
      this.autoFocus = false});

  @override
  _LoginInputTextFieldState createState() => _LoginInputTextFieldState();
}

class _LoginInputTextFieldState extends State<LoginInputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChange,
      controller: widget.controller,
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.phone,
      decoration: widget.inputDecoration,
      cursorColor: Colors.black,
    );
  }
}
