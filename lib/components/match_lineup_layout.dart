import 'package:flutter/material.dart';
import '../models/match_item.dart';
import '../models/match_lineup.dart';

class MatchLineupLayout extends StatefulWidget{

  MatchItem matchItem;

  MatchLineupLayout(this.matchItem);

  @override
  MatchLineupLayoutState createState() {
    // TODO: implement createState
    return MatchLineupLayoutState(matchItem);
  }


}

class MatchLineupLayoutState extends State<MatchLineupLayout>{

  MatchItem matchItem;
  List<MatchLineup> lineups = [];
  bool isLoading = true;

  int idTeam = 0;

  MatchLineupLayoutState(this.matchItem);

  @override
  void initState() {
    super.initState();
    idTeam = matchItem.teamAId;
    initLineup(idTeam);
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50.0,
              child: RaisedButton(
                child: Text(
                  matchItem.teamA,
                  style: TextStyle(
                    color: (idTeam == matchItem.teamAId)? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: (){
                  setState(() {
                    isLoading = true;
                    idTeam = matchItem.teamAId;
                    initLineup(idTeam);
                  });
                },
                color: (idTeam == matchItem.teamAId)? Theme.of(context).primaryColor : Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50.0,
              child: RaisedButton(
                child: Text(
                  matchItem.teamB,
                  style: TextStyle(
                    color: (idTeam == matchItem.teamBId)? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: (){
                  setState(() {
                    isLoading = true;
                    idTeam = matchItem.teamBId;
                    initLineup(idTeam);
                  });
                },
                color: (idTeam == matchItem.teamBId)? Theme.of(context).primaryColor : Colors.white,
              ),
            )
          ],
        ),
        (isLoading)?
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: CircularProgressIndicator(),
              )
          ),
        ):
        Expanded(
            child: ListView.builder(
                itemCount: lineups.length,
                itemBuilder: (context, i){
                  return Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        width: MediaQuery.of(context).size.width / 10,
                        child: Text(
                          '${lineups[i].num_player}',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 14.0,bottom: 5.0),
                        child: Text(
                          '${lineups[i].name}',
                          textScaleFactor: 1.5,
                        ),
                      )
                    ],
                  );
                }
            )
        )
      ],
    );
  }

  initLineup(int idTeam) async{
    await Future.delayed(Duration.zero);
    lineups.clear();
    MatchLineup.getMatchLineup(context, matchItem.id,idTeam).then((list){
      setState(() {
        lineups.addAll(list);
        isLoading = false;
      });
    });
  }
}