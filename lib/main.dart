import 'package:flutter/material.dart';
import 'models/localizations.dart';
import 'theme/style.dart';
import 'screens/login/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
      home: Login(),
    );
  }

}
