import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/suggest_user_dialog.dart';

class PageTransition {

  Map localization;
  BuildContext context;

  PageTransition (this.context, this.localization);

  //check if app can suggest user to share or rate application
  Future checkForRateAndShareSuggestion() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SuggestUserDialog(localization, SuggestType.SUGGEST_RATE_APP);
        });
  }
}