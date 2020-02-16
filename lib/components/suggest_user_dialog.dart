import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user_suggest.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/constants.dart' as constant;

class SuggestUserDialog extends StatelessWidget {

  SuggestType suggestType;
  UserSuggest userSuggest;

  SuggestUserDialog(this.suggestType, this.userSuggest);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 80 / 100,
                child: new Text(
                  (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                  MyLocalizations.instanceLocalization['text_suggest_rate_app']:
                  MyLocalizations.instanceLocalization['text_suggest_share_app'],
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width /1.5,
                    child: RaisedButton(
                      child: Text(
                        (this.suggestType == SuggestType.SUGGEST_RATE_APP)?
                        MyLocalizations.instanceLocalization['rate']:
                        MyLocalizations.instanceLocalization['share'],
                        maxLines: 2,
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
                          Share.share(MyLocalizations.instanceLocalization['text_share_app']);
                          this.userSuggest.canSuggestShare = false;
                        }
                        updateSuggestValue();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: RaisedButton(
                      child: Text(
                        MyLocalizations.instanceLocalization['remind_later'],
                        maxLines: 2,
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
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width /1.5,
                    child: RaisedButton(
                      child: Text(
                        MyLocalizations.instanceLocalization['not_show_again'],
                        maxLines: 2,
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
                    ),
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