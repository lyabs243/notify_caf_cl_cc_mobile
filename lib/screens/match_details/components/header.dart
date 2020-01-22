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
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                (matchItem.status != MatchItem.MATCH_STATUS_TYPE_PENDING)?
                matchItem.match_status:
                constant.formatDateTime(localization, matchItem.match_date, true),
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ),
                      Padding(padding: EdgeInsets.all(4.0),),
                      Container(
                        child: Text(
                          matchItem.teamA,
                          textAlign: TextAlign.center,
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
        )
      ],
    );
  }

}