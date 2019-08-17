import 'package:flutter/material.dart';
import 'screens/home/home.dart';
import 'theme/style.dart';
import 'screens/login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify Caf CL and CC',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: Login(),
    );
  }

}
