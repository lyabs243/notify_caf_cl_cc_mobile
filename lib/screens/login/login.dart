import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components/login_button.dart';
import '../../models/localizations.dart';
import 'components/text_termsofuse.dart';

class Login extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    double buttonWidth = MediaQuery.of(context).size.width/1.2;
    double iconSize = MediaQuery.of(context).size.width/2.5;

    Map localization = MyLocalizations.of(context).localization;

    // TODO: implement build
    return new Container(
      color: Colors.white,
      child: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              child: new Card(
                child: Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
              ),
              width: iconSize,
              height: iconSize,
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton(localization['login_with_google'], LoginType.Google),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton(localization['login_with_facebook'], LoginType.Facebook),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                new SizedBox(
                  width: buttonWidth,
                  child: LoginButton(localization['continue_without_login'], LoginType.Nope),
                ),
              ],
            ),
            new SizedBox(
              width: buttonWidth,
              child: new TextTermofuse(localization['term_use_text'], localization['term_use']),
            ),
          ],
        ),
      ),
    );
  }

}