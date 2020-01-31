import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/screens/match_details/match_details.dart';
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

  @override
  Widget build(BuildContext context) {

    _context = context;

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Admob.initialize(constant.ADMOB_APP_ID);
    return MaterialApp(
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale('en'),
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
          if(notification) {
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

          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

}