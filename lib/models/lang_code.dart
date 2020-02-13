import 'package:shared_preferences/shared_preferences.dart';

class LangCode {

  static String code;

  static Future<String> getLangCode() async {
    if(code == null) {
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      String langCode = await sharedPreferences.getString('lang');
      if (langCode == null) {
        langCode = 'en';
      }
      code = langCode;
    }
    return code;
  }

}