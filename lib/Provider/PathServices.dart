import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencePath{
  Future<void> setUserDataInSharePrefrences(String value) async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', value);
    return;
  }

  Future<String> getUserDataInSharePrefrences() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('key');
    return data;
  }

}