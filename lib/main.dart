import 'package:flutter/material.dart';
import 'models/localizations.dart';
import 'theme/style.dart';
import 'screens/login/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/user.dart';
import 'screens/home/home.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  User user;

  @override
  Widget build(BuildContext context) {
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
          if (user != null && user.id_accout_type != null && user.id_accout_type != null){
            /// is because there is user already logged
            return HomePage(MyLocalizations.of(context).localization);
          }
          /// other way there is no user logged.
          return Login();
        }
      ),
    );
  }

}