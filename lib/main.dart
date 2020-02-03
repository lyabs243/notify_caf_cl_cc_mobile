import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/Select_language_widget.dart';
import 'package:flutter_cafclcc/screens/first_launch/first_launch.dart';
import 'package:flutter_cafclcc/screens/match_details/match_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/localizations.dart';
import 'theme/style.dart';
import 'screens/login/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/user.dart';
import 'screens/home/home.dart';
import 'package:flutter/services.dart';
import 'package:onesignal/onesignal.dart';
//import 'package:admob_flutter/admob_flutter.dart' as adMob;
import 'models/constants.dart' as constant;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() {
    return new _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {

  User user;
  BuildContext _context;
  int matchId, type;
  bool notification = false;
  bool firstLaunch = true;
  String langCode = 'en';

  @override
  void initState() {
    super.initState();
    FirstLaunchPage.isFirstLaunch().then((value) {
      setState(() {
        firstLaunch = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    _context = context;
    Admob.initialize(constant.ADMOB_APP_ID);
    OneSignal.shared.init('11010fc6-b149-46a0-89f6-1ec83193e7ff');
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
    });
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      Map params = result.notification.payload.additionalData;
      matchId = int.parse(params['match_id']);
      type = int.parse(params['type']);
      notification = true;
      try {
        setState(() {
          notification = true;
        });
      }
      catch(e){}
    });
    SharedPreferences.getInstance().then((sharePreference) {
      setState(() {
        langCode = sharePreference.getString('lang');
        if(langCode == null) {
          langCode = 'en';
        }
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale(langCode),
      onGenerateTitle: (BuildContext context) =>
      MyLocalizations.of(context).localization['app_title'],
      supportedLocales: [Locale("en"), Locale("fr")],
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: FutureBuilder<User>(
        future: User.getInstance().then((user){
          this.user = user;
        }),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot){
          if(firstLaunch) {
            return SelectLanguageWidget(MyLocalizations.of(context).localization, user);
          }
          else if(notification) {
            Future.delayed(Duration.zero, () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (_context){
                    return MatchDetails(MyLocalizations.of(_context).localization, null, fromNotification: true,
                      matchId: matchId, pageType: type,);
                  }
              ));
              setState(() {
                notification = false;
              });
            });
          }
          else if (user != null && user.id_accout_type != null && user.id_accout_type != null){
            /// is because there is user already logged
            return HomePage(MyLocalizations.of(context).localization);
          }
          else {
            /// other way there is no user logged.
            return Login();
          }

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    MyLocalizations.of(context).localization['loading'],
                    textScaleFactor: 2.5,
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

}