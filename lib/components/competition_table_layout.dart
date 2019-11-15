import 'package:flutter/material.dart';
import 'empty_data.dart';
import '../models/group_table_item.dart';

class CompetitionTableLayout extends StatefulWidget{

  Map localization;
  int idStageGroup, idEditionStage;


  CompetitionTableLayout(this.localization, this.idStageGroup,
      this.idEditionStage);

  @override
  _CompetitionTableLayoutState createState() {
    return _CompetitionTableLayoutState(this.localization, this.idStageGroup,
        this.idEditionStage);
  }

}

class _CompetitionTableLayoutState extends State<CompetitionTableLayout>{

  Map localization;
  int idStageGroup, idEditionStage;

  List<GroupTableItem> tableItems = [];

  _CompetitionTableLayoutState(this.localization, this.idStageGroup,
      this.idEditionStage);

  @override
  Widget build(BuildContext context) {
    if(tableItems.length <= 0){
      GroupTableItem.getGroupTable(context, idStageGroup, idEditionStage).then((items){
        setState(() {
          tableItems.addAll(items);
        });
      });
    }
    return (tableItems.length <= 0)?
    EmptyData(localization) :
    Container(
      child: Column(
        children: getTableRows(context),
      ),
    );
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
                'P',
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
                'W',
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
                'D',
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
                'L',
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
                'GS',
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
                'GC',
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
                'GD',
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
                'Pts',
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

    return tableRows;
  }

}