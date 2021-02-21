import 'package:flutter/material.dart';
import 'package:notification_page/Model/QueryModel.dart';
import 'package:notification_page/Model/Response.dart';
import 'package:notification_page/Provider/EndPointService.dart';

import 'PathServices.dart';

class ProfileService with ChangeNotifier {
  Future<String> login(String email) async {
    String response = await EndPointService().SetupApi(
        "getuserId", "", [QueryModel(name: "email", value: email)]).httpGet2(
      HeaderEnum.BearerHeaderEnum,
      ResponseEnum.ResponseModelEnum,
    );
    if (response != '') {
      return response;
    }
  }
}