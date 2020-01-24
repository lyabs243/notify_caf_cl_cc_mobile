import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/suggest_user_dialog.dart';
import 'package:flutter_cafclcc/models/user_suggest.dart';

class PageTransition {

  Map localization;
  BuildContext context;

  PageTransition (this.context, this.localization);

  //check if app can suggest user to share or rate application
  Future checkForRateAndShareSuggestion() async {
    UserSuggest userSuggest = await UserSuggest.getSuggestUserDetails();
    bool canSuggest = false;
    SuggestType sType;
    if(userSuggest.lastSuggestion == UserSuggest.SUGGESTION_SHARE) {
      canSuggest = true;
      if(userSuggest.canSuggestRate) {
        sType = SuggestType.SUGGEST_RATE_APP;
      }
      else if(userSuggest.canSuggestShare) {
        sType = SuggestType.SUGGEST_SHARE_APP;
      }
      else {
        canSuggest = false;
      }
    }
    else if(userSuggest.lastSuggestion == UserSuggest.SUGGESTION_RATE) {
      canSuggest = true;
      if(userSuggest.canSuggestShare) {
        sType = SuggestType.SUGGEST_SHARE_APP;
      }
      else if(userSuggest.canSuggestRate) {
        sType = SuggestType.SUGGEST_RATE_APP;
      }
      else {
        canSuggest = false;
      }
    }

    if(canSuggest) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuggestUserDialog(
                localization, sType, userSuggest);
          });
    }
  }
}