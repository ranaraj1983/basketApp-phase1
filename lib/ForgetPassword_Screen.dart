import 'package:flutter/material.dart';

class ForgetPassword_Screen extends StatefulWidget {
  //final String toolbarname;

  //Help_Screen({Key key, this.toolbarname}) : super(key: key);

  @override
  _ForgetPassword_Screen createState() => _ForgetPassword_Screen();
}

class _ForgetPassword_Screen extends State<ForgetPassword_Screen> {
  final kHintTextStyle = TextStyle(
    color: Colors.yellowAccent,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {}
}
