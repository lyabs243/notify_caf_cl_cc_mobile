import 'package:flutter/material.dart';
import '../models/match_item.dart';

class MatchActionsLayout extends StatefulWidget{

  Map localization;
  MatchItem matchItem;

  MatchActionsLayout(this.localization,this.matchItem);

  @override
  _MatchActionsLayoutState createState() {
    return new _MatchActionsLayoutState(localization, matchItem);
  }

}

class _MatchActionsLayoutState extends State<MatchActionsLayout>{

  Map localization;
  MatchItem matchItem;

  _MatchActionsLayoutState(this.localization,this.matchItem);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Actions',
        textScaleFactor: 3.0,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

}