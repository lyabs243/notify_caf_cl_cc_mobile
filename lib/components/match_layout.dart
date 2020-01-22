import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/match_competition_painter.dart';
import '../models/constants.dart' as constant;
import '../models/match_item.dart';
import '../screens/match_details/match_details.dart';

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
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomPaint(
                painter: MatchCompetitionPainter(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 90 / 100,
                  child: Text(
                    matchItem.competition.title_small,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
                )
              ),
            ],
          ),
          Container(
            height: 1.0,
            color: Theme.of(context).primaryColor,
          ),
          Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0)),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*35/100,
                child: Column(
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
                    Padding(padding: EdgeInsets.only(bottom: 4.0, top: 4.0)),
                    Container(
                      child: Text(
                        matchItem.teamA,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1.1,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 4.0, top: 4.0)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 23 / 100,
                child: Column(
                  children: <Widget>[
                    Text(
                      constant.formatDateTime(localization, matchItem.match_date, false),
                      textScaleFactor: 0.8,
                    ),
                    Container(
                      child: Text(
                        (matchItem.status == MatchItem.MATCH_STATUS_TYPE_PENDING)?
                        ' - ':
                        (matchItem.teamA_goal.toString()+' - '+matchItem.teamB_goal.toString()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 4.0),),
                    (matchItem.team_a_penalty > 0 || matchItem.team_b_penalty > 0)?
                    Container(
                      child: Text
                        (
                          'PEN ${matchItem.team_a_penalty} - ${matchItem.team_b_penalty}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center
                      ),
                      width: MediaQuery.of(context).size.width/4.5,
                    ): Container()
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*35/100,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: (matchItem.teamB_logo != null && matchItem.teamB_logo.length > 0)?
                      Image.network(matchItem.teamB_logo,fit: BoxFit.cover,):
                      Image.asset(
                          'assets/icons/privacy.png'
                      ),
                      width: 40,
                      height: 28,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 4.0, top: 4.0)),
                    Container(
                      child: Text(
                        matchItem.teamB,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1.1,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 4.0, top: 4.0)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return MatchDetails(localization,matchItem);
            }
        ));
      },
    );
  }

}