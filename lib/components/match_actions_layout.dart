import 'dart:async';

import 'package:flutter/material.dart';
import '../models/match_item.dart';
import '../models/match_action.dart';

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

  List<MatchAction> actions = [];

  _MatchActionsLayoutState(this.localization,this.matchItem);

  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(seconds: 30), (timer) {
      if(matchItem.status != MatchItem.MATCH_STATUS_TYPE_FULLTIME &&
          matchItem.status != MatchItem.MATCH_STATUS_TYPE_REPORT) {
        actions.clear();
        initActions();
      }
    });
    initActions();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: actions.length,
        itemBuilder: (buildContext,i){
          return Container(
            margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                (actions[i].position == MatchAction.ACTION_POSITION_LEFT && actions[i].id_team > 0)?
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${actions[i].minute}\'',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        actions[i].detail_a,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        actions[i].detail_b,
                        style: TextStyle(
                            color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                ) : Container(width: MediaQuery.of(context).size.width * 0.4,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    children: <Widget>[
                      (actions[i].type == MatchAction.MATCH_ACTION_TYPE_GOAL || actions[i].type == MatchAction.MATCH_ACTION_TYPE_GOAL_PENALTY)?
                      Text(
                        '${actions[i].teamA_goal} - ${actions[i].teamB_goal}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ) : Container(),
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: Image.asset(
                          MatchAction.getActionIconPath(actions[i].type)
                        ),
                      ),
                      Text(
                        MatchAction.getActionLable(actions[i].type, localization),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor
                        ),
                      )
                    ],
                  ),
                ),
                (actions[i].position == MatchAction.ACTION_POSITION_RIGHT && actions[i].id_team > 0)?
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${actions[i].minute}\'',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        actions[i].detail_a,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        actions[i].detail_b,
                        style: TextStyle(
                            color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                ) : Container(width: MediaQuery.of(context).size.width * 0.4,),
              ],
            ),
          );
        },
      ),
    );
  }

  initActions() async{
    await Future.delayed(Duration.zero);
    MatchAction.getMatchActions(context, matchItem.id).then((list){
      setState(() {
        actions.addAll(list);
      });
    });
  }

}