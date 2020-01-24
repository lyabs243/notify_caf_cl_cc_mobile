import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/user_suggest.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/constants.dart' as constant;

class SuggestUserDialog extends StatelessWidget {

  Map localization;
  SuggestType suggestType;
  UserSuggest userSuggest;

  SuggestUserDialog(this.localization, this.suggestType, this.userSuggest);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 80 / 100,
                child: new Text(
                  (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                  localization['text_suggest_rate_app']:
                  localization['text_suggest_share_app'],
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
              ),
              (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50.0,
                  )
                ],
              ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                      localization['rate']:
                      localization['share'],
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if(this.suggestType == SuggestType.SUGGEST_RATE_APP) {
                        launch(
                            'https://play.google.com/store/apps/details?id=${constant
                                .APP_PACKAGE}');
                        this.userSuggest.canSuggestRate = false;
                      }
                      else { //suggest share app
                        Share.share(localization['text_share_app']);
                        this.userSuggest.canSuggestShare = false;
                      }
                      updateSuggestValue();
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      localization['remind_later'],
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      updateSuggestValue();
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      localization['not_show_again'],
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if(this.suggestType == SuggestType.SUGGEST_RATE_APP) {
                        this.userSuggest.canSuggestRate = false;
                      }
                      else {
                        this.userSuggest.canSuggestShare = false;
                      }
                      updateSuggestValue();
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ]
        ),
      ),
    );
  }

  updateSuggestValue() {
    userSuggest.lastSuggestion = (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
    UserSuggest.SUGGESTION_RATE : UserSuggest.SUGGESTION_SHARE;

    UserSuggest.setSuggestUserDetails(userSuggest);
  }

}

enum SuggestType{
  SUGGEST_RATE_APP,
  SUGGEST_SHARE_APP
}