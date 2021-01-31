import 'package:flutter/material.dart';
import 'package:notification_page/Provider/ProfileServices.dart';
import 'package:notification_page/Widgets/RegisterTextField.dart';

class LoginNotif extends StatefulWidget {
  @override
  _LoginNotifState createState() => _LoginNotifState();
}

class _LoginNotifState extends State<LoginNotif> {
  TextEditingController UserNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegisterTextField(
                  controller: UserNameController, hint: "نام کاربری"),
              SizedBox(
                height: 20,
              ),
              RaisedButton(onPressed: () async {
                await ProfileService().login(UserNameController.text);
                print('yse2');
              }),
            ],
          ),
        ),
      ),
    );
  }
}
