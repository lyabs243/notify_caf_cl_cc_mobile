import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/suggest_user_dialog.dart';
import 'package:flutter_cafclcc/models/user_suggest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageTransition {

  Map localization;
  BuildContext context;

  PageTransition (this.context, this.localization);

  //check if app can suggest user to share or rate application
  Future checkForRateAndShareSuggestion() async {

    int pageNumber = await getTransitionNumber();
    if(pageNumber == null) {
      pageNumber = 0;
    }
    if(pageNumber > 0 && pageNumber % 7 == 0) {
      UserSuggest userSuggest = await UserSuggest.getSuggestUserDetails();
      bool canSuggest = false;
      SuggestType sType;
      if (userSuggest.lastSuggestion == UserSuggest.SUGGESTION_SHARE) {
        canSuggest = true;
        if (userSuggest.canSuggestRate) {
          sType = SuggestType.SUGGEST_RATE_APP;
        }
        else if (userSuggest.canSuggestShare) {
          sType = SuggestType.SUGGEST_SHARE_APP;
        }
        else {
          canSuggest = false;
        }
      }
      else if (userSuggest.lastSuggestion == UserSuggest.SUGGESTION_RATE) {
        canSuggest = true;
        if (userSuggest.canSuggestShare) {
          sType = SuggestType.SUGGEST_SHARE_APP;
        }
        else if (userSuggest.canSuggestRate) {
          sType = SuggestType.SUGGEST_RATE_APP;
        }
        else {
          canSuggest = false;
        }
      }

      if (canSuggest) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return SuggestUserDialog(
                  localization, sType, userSuggest);
            });
      }
    }

    pageNumber += 1;
    if(pageNumber > 7) {
      pageNumber = 0;
    }
    setTransitionNumber(pageNumber);
  }

  Future<int> getTransitionNumber() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int transitionNumber = sharedPreferences.getInt('transition_number');

    return transitionNumber;

  }

  Future setTransitionNumber(int transitionNumber) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('transition_number', transitionNumber);

  }

}