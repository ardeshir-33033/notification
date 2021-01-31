import 'package:flutter/material.dart';
import 'FlutterToJava/MethodChannel.dart';
import 'Screens/Login.dart';
import 'Screens/NotifcationPopUpPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetMethod(),
    );
  }
}

