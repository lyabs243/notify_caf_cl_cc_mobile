import 'package:flutter/material.dart';
import '../../models/match_item.dart';

class MatchDetails extends StatefulWidget{

  Map localization;
  MatchItem match;

  MatchDetails(this.localization,this.match);

  @override
  _MatchDetailsState createState() {
    return new _MatchDetailsState(this.localization,this.match);
  }

}

class _MatchDetailsState extends State<MatchDetails>{

  Map localization;
  MatchItem matchItem;

  _MatchDetailsState(this.localization,this.matchItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: (){

            }
          )
        ],
      ),
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }

}