import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../models/localizations.dart';
import '../login/login.dart';

class HomePage extends StatefulWidget{

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    Map localization = MyLocalizations.of(context).localization;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization['app_title']),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return Login();
              }));
            },
            child: Text(localization['login'],style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Body(),
    );
  }

}