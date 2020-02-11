import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'empty_data.dart';
import '../models/group_table_item.dart';

class CompetitionTableLayout extends StatefulWidget{

  int idStageGroup, idEditionStage;

  CompetitionTableLayout(this.idStageGroup, this.idEditionStage);

  @override
  _CompetitionTableLayoutState createState() {
    return _CompetitionTableLayoutState(this.idStageGroup,
        this.idEditionStage);
  }

}

class _CompetitionTableLayoutState extends State<CompetitionTableLayout>{

  int idStageGroup, idEditionStage;

  List<GroupTableItem> tableItems = [];
  bool isLoading = true;

  _CompetitionTableLayoutState(this.idStageGroup,
      this.idEditionStage);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async{
    await Future.delayed(Duration.zero);
    GroupTableItem.getGroupTable(context, idStageGroup, idEditionStage).then((items){
      setState(() {
        tableItems.addAll(items);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)?
        Center(
          child: CircularProgressIndicator(),
        ):
    ((tableItems.length <= 0)?
    EmptyData() :
    SingleChildScrollView(
      child: Container(
        child: Column(
          children: getTableRows(context),
        ),
      ),
    ));
  }

  List<Widget> getTableRows(BuildContext context){
    List<Widget> tableRows = [];
    //add header
    tableRows.add(Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(4.0),
      height: 45,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
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
            width: MediaQuery.of(context).size.width * 9/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 12/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['match_played_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['match_win_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['match_draw_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['match_lose_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['goal_scored_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['goal_conceded_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['goal_difference_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                MyLocalizations.instanceLocalization['points_small'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ));

    //add rows
    for(int i = 1;i<= tableItems.length;i++){
      tableRows.add(Container(
        color: (i % 2 == 0)?Colors.grey[400] : Colors.white,
        //padding: EdgeInsets.all(4.0),
        height: 45,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
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
              width: MediaQuery.of(context).size.width * 9/100,
              child: new Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 9.0,bottom: 9.0, right: 5.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: Image.network(
                        tableItems[i-1].url_logo,
                      ),
                    ),
                    backgroundImage: AssetImage('assets/icons/profile.png'),
                    backgroundColor: Colors.transparent,
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 12/100,
              child: Center(
                child: Text(
                  tableItems[i-1].title_small,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  tableItems[i-1].matchs_played.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  tableItems[i-1].win.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  tableItems[i-1].draw.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  tableItems[i-1].lose.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  tableItems[i-1].scored.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  tableItems[i-1].conceded.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  tableItems[i-1].goal_difference.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  tableItems[i-1].points.toString(),
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

    //add caption
    tableRows.add(
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 4.5, top: 4.5, right: 4.5, bottom: MediaQuery.of(context).size.height / 12),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${MyLocalizations.instanceLocalization['match_played_small']}: ${MyLocalizations.instanceLocalization['match_played']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${MyLocalizations.instanceLocalization['match_win_small']}: ${MyLocalizations.instanceLocalization['match_win']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${MyLocalizations.instanceLocalization['match_draw_small']}: ${MyLocalizations.instanceLocalization['match_draw']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${MyLocalizations.instanceLocalization['match_lose_small']}: ${MyLocalizations.instanceLocalization['match_lose']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${MyLocalizations.instanceLocalization['goal_scored_small']}: ${MyLocalizations.instanceLocalization['goal_scored']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${MyLocalizations.instanceLocalization['goal_conceded_small']}: ${MyLocalizations.instanceLocalization['goal_conceded']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${MyLocalizations.instanceLocalization['goal_difference_small']}: ${MyLocalizations.instanceLocalization['goal_difference']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${MyLocalizations.instanceLocalization['points_small']}: ${MyLocalizations.instanceLocalization['points']}',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );

    return tableRows;
  }

}