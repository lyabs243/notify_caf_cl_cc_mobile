import 'dart:async';

import 'package:flutter/material.dart';
import '../../../models/constants.dart' as constant;
import '../../../models/match_item.dart';

class Header extends StatefulWidget{

  Map localization;
  MatchItem matchItem;

  Header(this.localization,this.matchItem);

  @override
  _HeaderState createState() {
    return new _HeaderState(localization, matchItem);
  }

}

class _HeaderState extends State<Header>{

  Map localization;
  MatchItem matchItem;

  _HeaderState(this.localization,this.matchItem);

  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(seconds: 30), (timer) {
      if(matchItem != null) {
        if (matchItem.status != MatchItem.MATCH_STATUS_TYPE_FULLTIME &&
            matchItem.status != MatchItem.MATCH_STATUS_TYPE_REPORT) {
          //get matchs details only when it has to begin or when it is in progress
          int diffInMinutes = DateTime
              .now()
              .difference(matchItem.match_date)
              .inMinutes;
          if (diffInMinutes >= -10) {
            MatchItem.get(context, matchItem.id).then((value) {
              if(value != null) {
                setState(() {
                  matchItem = value;
                });
              }
            });
          }
        }
      }
    });
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.2,
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  (matchItem.status != MatchItem.MATCH_STATUS_TYPE_PENDING)?
                  matchItem.match_status:
                  constant.formatDateTime(localization, matchItem.match_date, true),
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Card(
                            elevation: 10.0,
                            child: Container(
                              child: (matchItem.teamA_logo != null && matchItem.teamA_logo.length > 0)?
                              Image.network(matchItem.teamA_logo,fit: BoxFit.cover,):
                              Image.asset(
                                  'assets/icons/privacy.png'
                              ),
                              width: 100,
                              height: 80,
                            ),
                            color: Colors.transparent,
                          ),
                          Padding(padding: EdgeInsets.all(4.0),),
                          Container(
                            child: Text(
                              matchItem.teamA,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            width: MediaQuery.of(context).size.width/3,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/5,
                        child: Text(
                          (matchItem.status == MatchItem.MATCH_STATUS_TYPE_PENDING)?
                          ' - ':
                          (matchItem.teamA_goal.toString()+' - '+matchItem.teamB_goal.toString()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          textScaleFactor: 2,
                        ),
                        width: MediaQuery.of(context).size.width/6,
                      ),
                      Column(
                        children: <Widget>[
                          Card(
                            elevation: 10.0,
                            color: Colors.transparent,
                            child: Container(
                              child: (matchItem.teamB_logo != null && matchItem.teamB_logo.length > 0)?
                              Image.network(matchItem.teamB_logo,fit: BoxFit.cover,):
                              Image.asset(
                                  'assets/icons/privacy.png'
                              ),
                              width: 100,
                              height: 80,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4.0),),
                          Container(
                            child: Text(
                              matchItem.teamB,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            width: MediaQuery.of(context).size.width/3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (matchItem.team_a_penalty > 0 || matchItem.team_b_penalty > 0)?
                Container(
                  child: Text(
                      'PEN ${matchItem.team_a_penalty} - ${matchItem.team_b_penalty}',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white
                      ),
                      textAlign: TextAlign.center
                  ),
                  width: MediaQuery.of(context).size.width/4.5,
                ): Container()
              ],
            ),
          ),
        );
  }

}