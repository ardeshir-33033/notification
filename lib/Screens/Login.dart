import 'package:flutter/material.dart';
import 'package:notification_page/Provider/PathServices.dart';
import 'package:notification_page/Provider/ProfileServices.dart';
import 'package:notification_page/Provider/SignalRProvider.dart';
import 'package:notification_page/Widgets/RegisterTextField.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'NotifcationPopUpPage.dart';

class LoginNotif extends StatefulWidget {
  @override
  _LoginNotifState createState() => _LoginNotifState();
}

class _LoginNotifState extends State<LoginNotif> {
  TextEditingController UserNameController = TextEditingController();
  String key;

  Future initialize() async {
    key = await SharedPreferencePath().getUserDataInSharePrefrences();
    if (key != null) {
      SignalRProvider.userName = key;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotificationsPage()));
    }
  }

  void startServiceInPlatform(String text) async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("ardeshir");
      String data = await methodChannel.invokeMethod("startService" ,{"text":text});
      debugPrint(data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

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
              RaisedButton(
                onPressed: () async {

                  key = await ProfileService().login(UserNameController.text);
                  if (key != '') {
                    SignalRProvider.userName = key;
                    startServiceInPlatform(key);
                    await SharedPreferencePath()
                        .setUserDataInSharePrefrences(key);
                    SignalRProvider.userName = key;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage()));
                  }
                },
                child: Text('تایید'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
