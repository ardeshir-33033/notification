import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    Key key,
    @required this.controller,
    @required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
          ),
          labelStyle: new TextStyle(color: Colors.blue),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
