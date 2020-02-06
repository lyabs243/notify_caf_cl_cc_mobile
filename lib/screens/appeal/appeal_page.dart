import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'components/item_appeal.dart';

class AppealPage extends StatefulWidget{

  AppealPage();

  @override
  _AppealPageState createState() {
    // TODO: implement createState
    return new _AppealPageState();
  }

}

class _AppealPageState extends State<AppealPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.instanceLocalization['subscriber_appeal'])
      ),
      body: ItemAppeal(),
    );
  }

}