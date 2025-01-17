import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
import '../../../models/competition_stage.dart';
import '../../../models/match_item.dart';
import '../../../components/empty_data.dart';
import '../../../components/match_layout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../components/competition_table_layout.dart';

class StageTabview extends StatefulWidget{

  CompetitionStage competitionStage;
  int selectedButton;
  int selectedGroup;

  StageTabview(this.competitionStage,this.selectedGroup,this.selectedButton);

  @override
  _StageTabviewState createState() {
    // TODO: implement createState
    return new _StageTabviewState(this.competitionStage,this.selectedGroup,this.selectedButton);
  }

}

class _StageTabviewState extends State<StageTabview>{

  CompetitionStage competitionStage;
  int selectedButton = 1;
  int selectedGroup;
  int page = 1;
  List<MatchItem> listMatch = [];
  bool loadingDone = false, isLoading = true;

  RefreshController refreshController;

  _StageTabviewState(this.competitionStage,this.selectedGroup,this.selectedButton);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    getResultMatchs();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              (competitionStage.groups != null && competitionStage.groups.length > 0)?
              new Container(
                height: 60.0,
                color: Colors.black,
                padding: EdgeInsets.all(5.0),
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: competitionStage.groups.length,
                  itemBuilder: (context,index){
                    return Container(
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            selectedGroup = competitionStage.groups[index].id;
                            selectedButton = 1;
                            isLoading = true;
                            initMatchs();
                          });
                        },
                        color: (selectedGroup == competitionStage.groups[index].id)? Theme.of(context).primaryColor : Colors.white,
                        elevation: 10.0,
                        textColor: (selectedGroup == competitionStage.groups[index].id)? Colors.white : Theme.of(context).primaryColor,
                        child: Text(competitionStage.groups[index].title),
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
                        MyLocalizations.instanceLocalization['last_results'],
                        style: TextStyle(
                          color: (selectedButton == 1)? Colors.white : Theme.of(context).primaryColor,
                        ),
                      ),
                      color: (selectedButton == 1)? Theme.of(context).primaryColor : Colors.white,
                      onPressed: (){
                        setState(() {
                            selectedButton = 1;
                            isLoading = true;
                            initMatchs();
                          });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.05,
                    child: RaisedButton(
                      child: Text(
                        MyLocalizations.instanceLocalization['fixture'],
                        style: TextStyle(
                          color: (selectedButton == 2)? Colors.white : Theme.of(context).primaryColor,
                        ),
                      ),
                      color: (selectedButton == 2)? Theme.of(context).primaryColor : Colors.white,
                      onPressed: (){
                        setState(() {
                            selectedButton = 2;
                            isLoading = true;
                            initMatchs();
                          });
                      },
                    ),
                  )
                ],
              ),
              (competitionStage.type == CompetitionStage.COMPETIONSTAGE_TYPE_GROUP)?
              SizedBox(
                width: MediaQuery.of(context).size.width/2.05*2,
                child: RaisedButton(
                  child: Text(
                    MyLocalizations.instanceLocalization['table'],
                    style: TextStyle(
                      color: (selectedButton == 3)? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                  color: (selectedButton == 3)? Theme.of(context).primaryColor : Colors.white,
                  onPressed: (){
                    setState(() {
                        selectedButton = 3;
                      });
                  },
                ),
              ) : Container(),
              (isLoading)?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
              (selectedButton == 3)?
                Expanded(
                  child: CompetitionTableLayout(selectedGroup, competitionStage.id),
                )  :
              (listMatch.length <= 0)?
              EmptyData():
              Expanded(
                child: SmartRefresher(
                    controller: refreshController,
                    enablePullUp: true,
                    enablePullDown: false,
                    onLoading: _onLoading,
                    footer: CustomFooter(
                      builder: (BuildContext context,LoadStatus mode){
                        Widget body ;
                        if(mode==LoadStatus.loading){
                          body =  CircularProgressIndicator();
                        }
                        else{
                          body = Container();
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child:body),
                        );
                      },
                    ),
                    child: ListView.builder(
                    itemCount: listMatch.length,
                    padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0, bottom: MediaQuery.of(context).size.height / 12),
                    itemBuilder: (context,i){
                      return Card(
                        child: MatchLayout(listMatch[i]),
                        elevation: 8.0,
                      );
                    },
                )
                )
              )
            ],
          ),
        ),
      ],
    );
  }

  initMatchs(){
    page = 1;
    listMatch.clear();
    // latest results
    if(selectedButton == 1){
      getResultMatchs();
    }
    // fixture
    else if(selectedButton == 2){
      getFixtureMatchs();
    }
  }

  getFixtureMatchs() {
    int idGroup = 0;
    if (competitionStage.type == CompetitionStage.COMPETIONSTAGE_TYPE_GROUP)
      idGroup = selectedGroup;
    CompetitionStage.getStageFixture(
        context, 0, page, competitionStage.id, idGroup).then((result) {
      if (mounted)
        setState(() {
          listMatch.addAll(result);
          isLoading = false;
          loadingDone = true;
          if (result.length > 0) {
            page++;
          }
        });
    });
  }

  getResultMatchs() async{
    await Future.delayed(Duration.zero);
    int idGroup = 0;
    if(competitionStage.type == CompetitionStage.COMPETIONSTAGE_TYPE_GROUP)
      idGroup = selectedGroup;
    CompetitionStage.getStageLatestResults(context, 0, page, competitionStage.id, idGroup).then((result){
      if(mounted)
        setState(() {
          listMatch.addAll(result);
          isLoading = false;
          loadingDone = true;
          if(result.length > 0){
            page++;
          }
        });
    });
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  Future addItems() async{
    // latest results
    if(selectedButton == 1){
      getResultMatchs();
    }
    // fixture
    else if(selectedButton == 2){
      getFixtureMatchs();
    }
    refreshController.loadComplete();
  }

}