import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencePath extends ChangeNotifier{
  static SharedPreferences prefs;

  Future setUserDataInSharePrefrences(String value) async {
    if(prefs == null)
      prefs = await SharedPreferences.getInstance();

    prefs.setString('key', value);
    return;
  }

  Future<String> getUserDataInSharePrefrences() async {
    if(prefs == null)
      prefs = await SharedPreferences.getInstance();

    String data = prefs.getString('key');
    return data;
  }
}