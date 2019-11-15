import 'package:flutter/material.dart';
import '../../models/competition_item.dart';
import '../../models/scorer_edition.dart';
import '../../components/empty_data.dart';

class CompetitionScorers extends StatefulWidget{

  Map localization;
  CompetitionItem competitionItem;

  CompetitionScorers(this.localization, this.competitionItem);

  @override
  _CompetitionScorersState createState() {
    return _CompetitionScorersState(this.localization, this.competitionItem);
  }

}

class _CompetitionScorersState extends State<CompetitionScorers>{

  Map localization;
  CompetitionItem competitionItem;

  List<ScorerEdition> scorerItems = [];

  bool isLoading = true;

  _CompetitionScorersState(this.localization, this.competitionItem);

  @override
  Widget build(BuildContext context) {
    if(scorerItems.length <= 0){
      ScorerEdition.getScorers(context, competitionItem.id, 1).then((items){
        setState(() {
          scorerItems.addAll(items);
          if(items.length <= 0)
            isLoading = false;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${competitionItem.title_small} ${localization['scorers']}',
          overflow: TextOverflow.fade,
        ),
      ),
      body: (isLoading)?
       Center(
        child: CircularProgressIndicator(),
       ) :
      ((scorerItems.length <= 0)?
      EmptyData(localization) :
      Container(
        child: Column(
          children: getScorersRows(context),
        ),
      )),
    );
  }

  List<Widget> getScorersRows(BuildContext context){
    List<Widget> scorerRows = [];
    //add header
    scorerRows.add(Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(4.0),
      height: 45,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: Center(
              child: Text(
                '#',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 40/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: new Container(
              width: 100,
              height: 100,
              child: ImageIcon(
                AssetImage(
                'assets/icons/match/goal.png'
                ),
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: new Container(
              width: 100,
              height: 100,
              child: Image.asset('assets/icons/match/match_action_goal_penalty.png'),
            ),
          ),
        ],
      ),
    ));

    //add rows
    for(int i = 1;i<= scorerItems.length;i++){
      scorerRows.add(Container(
        color: (i % 2 == 0)?Colors.grey[400] : Colors.white,
        height: 45,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  '$i',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Container(
                width: 100,
                height: 100,
                child: Image.network(scorerItems[i-1].url_flag),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].team_name_small,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 40/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].name,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].goals.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].goalsPenalty.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    setState(() {
      isLoading = false;
    });
    return scorerRows;
  }

}