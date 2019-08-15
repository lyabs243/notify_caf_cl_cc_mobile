import 'package:flutter/material.dart';
import 'components/body.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Body(),
    );
  }

}