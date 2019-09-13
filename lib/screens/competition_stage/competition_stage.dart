import 'package:flutter/material.dart';
import '../../models/group_stage.dart';
import '../../components/empty_data.dart';
import '../../models/competition_item.dart';
import '../../models/competition_stage.dart' as stage;

class CompetitionStage extends StatefulWidget{

  Map localization;
  CompetitionItem competitionItem;

  CompetitionStage(this.localization,this.competitionItem);

  @override
  _CompetitionStageState createState() {
    // TODO: implement createState
    return new _CompetitionStageState();
  }

}

class _CompetitionStageState extends State<CompetitionStage>{

  List<stage.CompetitionStage> competitionStages = [];
  List<Tab> tabs = [];

  bool isLoading = true;

  List<int> selectedGroups = [];
  List<int> selectedButtons = [];  //to know zhich button between (result,schedule and table) is selected
  
  @override
  Widget build(BuildContext context) {
    if(competitionStages.length == 0){
      initCompetitionStages();
    }
    List<Widget> tabViews = [];
    initTabs(tabViews);
    return (isLoading || competitionStages.length <= 0)?
        Scaffold(
          appBar: AppBar(title: Text(this.widget.localization['stages']),),
          body: (isLoading)? Center(child: CircularProgressIndicator(),) : EmptyData(this.widget.localization),
        ):
    DefaultTabController(
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
    stage.CompetitionStage.getCompetitionStages(context, this.widget.competitionItem.id).then((result){
      setState(() {
        competitionStages.addAll(result);
        competitionStages.forEach((cmpStage){
          tabs.add(Tab(text: '${cmpStage.title}',));
          (cmpStage.groups != null && cmpStage.groups.length > 0)? selectedGroups.add(cmpStage.groups[0].id) : selectedGroups.add(0);
          selectedButtons.add(1);
        });
        isLoading = false;
      });
    });
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
