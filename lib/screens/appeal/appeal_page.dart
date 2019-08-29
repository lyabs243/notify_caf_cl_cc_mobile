import 'package:flutter/material.dart';
import 'components/item_appeal.dart';

class AppealPage extends StatefulWidget{

  Map localization;

  AppealPage(this.localization);

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
        title: Text(this.widget.localization['subscriber_appeal'])
      ),
      body: ItemAppeal(),
    );
  }

}