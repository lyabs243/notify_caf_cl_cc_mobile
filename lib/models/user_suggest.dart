import 'dart:convert';

import 'package:flutter_cafclcc/components/suggest_user_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSuggest {

  bool canSuggestRate;
  bool canSuggestShare;
  int lastSuggestion;

  static int SUGGESTION_RATE = 1;
  static int SUGGESTION_SHARE = 2;

  UserSuggest(this.canSuggestRate, this.canSuggestShare, this.lastSuggestion);


  static Future<UserSuggest> getSuggestUserDetails() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userSuggestText = sharedPreferences.getString('user_suggest');
    UserSuggest userSuggest;
    if(userSuggestText != null) {
      Map userSuggestMap = json.decode(userSuggestText);

      bool canSuggestRate = userSuggestMap['can_suggest_rate'];
      bool canSuggestShare = userSuggestMap['can_suggest_share'];
      int lastSuggestion = userSuggestMap['last_suggestion'];

      userSuggest = UserSuggest(canSuggestRate, canSuggestShare, lastSuggestion);
    }
    else {
      userSuggest = UserSuggest(true, true, SUGGESTION_SHARE);
    }

    return userSuggest;

  }

  static Future setSuggestUserDetails(UserSuggest userSuggest) async {

    String map = """{
      "can_suggest_rate": ${userSuggest.canSuggestRate},
      "can_suggest_share": ${userSuggest.canSuggestShare},
      "last_suggestion": ${userSuggest.lastSuggestion}
    }""";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user_suggest', map);

  }
}