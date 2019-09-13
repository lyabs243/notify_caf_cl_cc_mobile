import 'package:flutter/material.dart';
import '../../models/group_stage.dart';
import '../../models/competition_stage.dart' as stage;

class CompetitionStage extends StatefulWidget{

  Map localization;

  CompetitionStage(this.localization);

  @override
  _CompetitionStageState createState() {
    // TODO: implement createState
    return new _CompetitionStageState();
  }

}

class _CompetitionStageState extends State<CompetitionStage>{

  List<stage.CompetitionStage> competitionStages = [];
  List<Tab> tabs = [];

  List<int> selectedGroups = [];
  List<int> selectedButtons = [];  //to know zhich button between (result,schedule and table) is selected
  
  @override
  Widget build(BuildContext context) {
    if(competitionStages.length == 0){
      initCompetitionStages();
      competitionStages.forEach((stage){
        tabs.add(Tab(text: '${stage.title}',));
      });
    }
    List<Widget> tabViews = [];
    initTabs(tabViews);
    return DefaultTabController(
      length: competitionStages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.localization['stages']),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0,color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal:16.0)
            ),
          ),
        ),
        body: TabBarView(children: tabViews),
      ),
    );
  }

  initCompetitionStages(){
    stage.CompetitionStage st1 = new stage.CompetitionStage(1, 1, '1/2 Final',
        stage.CompetitionStage.COMPETIONSTAGE_TYPE_NORMAL, null);
    stage.CompetitionStage st2 = new stage.CompetitionStage(2, 1, '1/4 Final',
        stage.CompetitionStage.COMPETIONSTAGE_TYPE_NORMAL, null);
    stage.CompetitionStage st3 = new stage.CompetitionStage(3, 1, '1/8 Final',
        stage.CompetitionStage.COMPETIONSTAGE_TYPE_NORMAL, null);

    stage.CompetitionStage st4 = new stage.CompetitionStage(4, 1, 'Group Stage',
        stage.CompetitionStage.COMPETIONSTAGE_TYPE_GROUP, []);
    st4.groups.add(GroupStage(1, 1, 'Group A'));
    st4.groups.add(GroupStage(2, 1, 'Group B'));
    st4.groups.add(GroupStage(3, 1, 'Group C'));
    st4.groups.add(GroupStage(4, 1, 'Group D'));
    st4.groups.add(GroupStage(5, 1, 'Group E'));
    st4.groups.add(GroupStage(6, 1, 'Group F'));

    competitionStages.add(st1);
    (st1.groups != null && st1.groups.length > 0)? selectedGroups.add(st1.groups[0].id) : selectedGroups.add(0);
    selectedButtons.add(1);

    competitionStages.add(st2);
    (st2.groups != null && st2.groups.length > 0)? selectedGroups.add(st2.groups[0].id) : selectedGroups.add(0);
    selectedButtons.add(1);

    competitionStages.add(st3);
    (st3.groups != null && st3.groups.length > 0)? selectedGroups.add(st3.groups[0].id) : selectedGroups.add(0);
    selectedButtons.add(1);

    competitionStages.add(st4);
    (st4.groups != null && st4.groups.length > 0)? selectedGroups.add(st4.groups[0].id) : selectedGroups.add(0);
    selectedButtons.add(1);
  }
  
  initTabs(List<Widget> tabViews){
    for(int i=0;i< competitionStages.length;i++){
      tabViews.add(
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  (competitionStages[i].groups != null && competitionStages[i].groups.length > 0)?
                  new Container(
                    height: 60.0,
                    color: Colors.black,
                    padding: EdgeInsets.all(5.0),
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: competitionStages[i].groups.length,
                      itemBuilder: (context,index){
                        return Container(
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                selectedGroups[i] = competitionStages[i].groups[index].id;
                              });
                            },
                            color: (selectedGroups[i] == competitionStages[i].groups[index].id)? Colors.white : Theme.of(context).primaryColor,
                            elevation: 10.0,
                            textColor: (selectedGroups[i] == competitionStages[i].groups[index].id)? Theme.of(context).primaryColor : Colors.white,
                            child: Text(competitionStages[i].groups[index].title),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                          padding: EdgeInsets.all(2.0),
                        );
                      },
                    ),
                  ) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.05,
                        child: RaisedButton(
                          child: Text(
                            this.widget.localization['last_results'],
                            style: TextStyle(
                              color: (selectedButtons[i] == 1)? Theme.of(context).primaryColor : Colors.white,
                            ),
                          ),
                          color: (selectedButtons[i] == 1)? Colors.white : Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              selectedButtons[i] = 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.05,
                        child: RaisedButton(
                          child: Text(
                            this.widget.localization['schedule'],
                            style: TextStyle(
                              color: (selectedButtons[i] == 2)? Theme.of(context).primaryColor : Colors.white,
                            ),
                          ),
                          color: (selectedButtons[i] == 2)? Colors.white : Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              selectedButtons[i] = 2;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.05*2,
                    child: RaisedButton(
                      child: Text(
                        this.widget.localization['table'],
                        style: TextStyle(
                          color: (selectedButtons[i] == 3)? Theme.of(context).primaryColor : Colors.white,
                        ),
                      ),
                      color: (selectedButtons[i] == 3)? Colors.white : Theme.of(context).primaryColor,
                      onPressed: (){
                        setState(() {
                          selectedButtons[i] = 3;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

}
