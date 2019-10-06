import 'package:flutter/material.dart';
import '../models/match_item.dart';

class MatchLayout extends StatefulWidget{

  Map localization;
  MatchItem matchItem;

  MatchLayout(this.localization,this.matchItem);

  @override
  MatchLayoutState createState() {
    // TODO: implement createState
    return new MatchLayoutState(this.localization,this.matchItem);
  }

}

class MatchLayoutState extends State<MatchLayout>{

  Map localization;
  MatchItem matchItem;

  MatchLayoutState(this.localization,this.matchItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  matchItem.match_date,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                Text(
                    matchItem.competition.title_small,
                    style: TextStyle(
                        color: Colors.white
                    )
                )
              ],
            ),
            color: Theme.of(context).primaryColor,
          ),
          Padding(padding: EdgeInsets.only(bottom: 4.0),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: (matchItem.teamA_logo != null && matchItem.teamA_logo.length > 0)?
                Image.network(matchItem.teamA_logo,fit: BoxFit.cover,):
                Image.asset(
                    'assets/icons/privacy.png'
                ),
                width: 40,
                height: 28,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          matchItem.teamA,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1.2,
                        ),
                        width: MediaQuery.of(context).size.width/4.5,
                      ),
                      Container(
                        child: Text(
                          matchItem.teamA_goal.toString()+' - '+matchItem.teamB_goal.toString(),
                          textAlign: TextAlign.center,
                        ),
                        width: MediaQuery.of(context).size.width/6,
                      ),
                      Container(
                        child: Text(
                          matchItem.teamB,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1.2,
                        ),
                        width: MediaQuery.of(context).size.width/4.5,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 4.0),),
                  (matchItem.team_a_penalty > 0 || matchItem.team_b_penalty > 0)?
                  Container(
                    child: Text
                    (
                        'PEN 12 - 11',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center
                    ),
                    width: MediaQuery.of(context).size.width/4.5,
                  ): Container()
                ],
              ),
              Container(
                child: (matchItem.teamB_logo != null && matchItem.teamB_logo.length > 0)?
                Image.network(matchItem.teamB_logo,fit: BoxFit.cover,):
                Image.asset(
                    'assets/icons/privacy.png'
                ),
                width: 40,
                height: 28,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 6.0),)
        ],
      ),
    );
  }

}