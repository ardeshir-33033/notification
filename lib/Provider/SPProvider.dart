import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPProvider with ChangeNotifier{
  static SharedPreferences sp;

  Future init() async {
    sp = await SharedPreferences.getInstance();
  }

  String getNotes(){
    return sp.getString("all_notes");
  }
}