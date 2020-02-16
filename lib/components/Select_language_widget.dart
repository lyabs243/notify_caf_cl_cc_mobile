import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/Country.dart';
import 'package:flutter_cafclcc/models/lang_code.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/fan_badge/get_fan_badge.dart';
import 'package:flutter_cafclcc/screens/first_launch/first_launch.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguageWidget extends StatelessWidget {

  User user;
  double iconSize;
  bool goToHomePage;

  SelectLanguageWidget(this.user, {this.goToHomePage: false});

  @override
  Widget build(BuildContext context) {
    iconSize = MediaQuery.of(context).size.width/3.5;
    return Scaffold(
        appBar: AppBar(
          title: Text(MyLocalizations.instanceLocalization['Language']),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Card(
                    child: Image.asset("assets/app_icon.png",fit: BoxFit.cover,),
                  ),
                  width: iconSize,
                  height: iconSize,
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0),),
                Text(
                  MyLocalizations.instanceLocalization['selet_language'],
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.5,
                ),
                Padding(padding: EdgeInsets.only(bottom: 80.0),),
                Column(
                  children: <Widget>[
                    buildLangItem(context, MyLocalizations.instanceLocalization['english'], MyLocalizations.instanceLocalization['language_english_code']),
                    Padding(padding: EdgeInsets.only(bottom: 20.0),),
                    buildLangItem(context, MyLocalizations.instanceLocalization['french'], MyLocalizations.instanceLocalization['language_french_code'])
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  Widget buildLangItem(BuildContext context, String language, String code) {
    return InkWell(
      onTap: () {
        SharedPreferences.getInstance().then((sharedPreferences) {
          sharedPreferences.setString('lang', code);
          GlobalWidgetsLocalizations.load(Locale(code)).then((v) {
            LangCode.code = code;
            MyLocalizationsDelegate().load(Locale(code)).then((value) {
            if(goToHomePage) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
            }
            else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) {
                return FirstLaunchPage(user);
              }));
            }
            });
          });

        });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              language,
              textScaleFactor: 2.1,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
        margin: EdgeInsets.all(8.0),
      ),
    );
  }

}