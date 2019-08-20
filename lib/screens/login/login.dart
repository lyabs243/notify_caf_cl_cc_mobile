import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components/login_button.dart';
import '../../models/localizations.dart';
import 'components/text_termsofuse.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget{

  @override
  _Login createState() {
    // TODO: implement createState
    return new _Login();
  }

}

class _Login extends State<Login>{

  bool isLoging = false;

  @override
  Widget build(BuildContext context) {

    double buttonWidth = MediaQuery.of(context).size.width/1.2;
    double iconSize = MediaQuery.of(context).size.width/2.5;

    Map localization = MyLocalizations.of(context).localization;

    // TODO: implement build
    return ModalProgressHUD(
      child: new Container(
        color: Theme.of(context).cardColor,
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
                    child: LoginButton(localization['login_with_google'], LoginType.Google,this.setLoginState),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                  new SizedBox(
                    width: buttonWidth,
                    child: LoginButton(localization['login_with_facebook'], LoginType.Facebook,this.setLoginState),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 18.0)),
                  new SizedBox(
                    width: buttonWidth,
                    child: LoginButton(localization['continue_without_login'], LoginType.Nope,this.setLoginState),
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
      ),
      inAsyncCall: isLoging,
      dismissible: false,
      opacity: 0.5,
    );
  }

  void setLoginState(bool isLoging){
    setState(() {
      this.isLoging = isLoging;
    });
  }

}