import 'package:flutter/material.dart';

class CompetitionStage extends StatefulWidget{

  Map localization;

  CompetitionStage(this.localization);

  @override
  _CompetitionStageState createState() {
    // TODO: implement createState
    return new _CompetitionStageState();
  }

}

class _CompetitionStageState extends State<CompetitionStage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.localization['stages']),
      ),
      body: Center(),
    );
  }

}
