import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/competition_item.dart';
import '../../models/match_item.dart';
import '../../components/match_layout.dart';
import '../../components/empty_data.dart';

class MatchsList extends StatefulWidget{

  Map localization;
  CompetitionItem competitionItem;
  int idCompetitionType;
  TypeList typeList;

  MatchsList(this.localization,this.competitionItem,this.typeList,{this.idCompetitionType: 0});

  @override
  _MatchListState createState() {
    return new _MatchListState(this.competitionItem,this.idCompetitionType,this.typeList);
  }

}

class _MatchListState extends State<MatchsList>{

  RefreshController refreshController;
  List<MatchItem> list = [];
  int page = 1;
  bool isPageRefresh = false, isLoadPage = true;
  CompetitionItem competitionItem;
  int idCompetitionType;
  TypeList typeList;
  int idCompetition = 0;
  String title = '';

  _MatchListState(this.competitionItem,this.idCompetitionType,this.typeList);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    if(competitionItem != null){
      idCompetition = competitionItem.id;
    }
    if(typeList == TypeList.LIVE){
      title = this.widget.localization['live'];
    }
    else if(typeList == TypeList.FIXTURE){
    title = this.widget.localization['fixture'];
    }
    else{
      title = this.widget.localization['last_results'];
    }
    initItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SmartRefresher(
          controller: refreshController,
          enablePullUp: (list.length > 0)? true : false,
          enablePullDown: true,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          header: (WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).primaryColor,
          )),
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
          child: (isLoadPage)?
          Center(
            child: CircularProgressIndicator(),
          ):
          (list.length <= 0)?
          EmptyData(this.widget.localization):
          ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.all(4.0),
              itemBuilder: (context,i){
                return Card(
                  child: MatchLayout(this.widget.localization, list[i]),
                  elevation: 8.0,
                );
              }
          ),
        ),
    );
  }

  void _onRefresh() async{
    isPageRefresh = true;
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems() async{
    await Future.delayed(Duration.zero);
    page = 1;
    if(typeList == TypeList.LIVE) {
      MatchItem.getCurrentMatchs(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
        initMatchs(result);
      });
    }
    else if(typeList == TypeList.FIXTURE) {
      MatchItem.getFixtureMatchs(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
        initMatchs(result);
      });
    }
    else {
      MatchItem.getLatestResults(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
        initMatchs(result);
      });
    }
  }

  initMatchs(List<MatchItem> result){
    if (result.length > 0) {
      setState(() {
        page++;
        list.clear();
        list.addAll(result);
      });
    }
    setState(() {
      isLoadPage = false;
    });
  }

  Future addItems() async{
    List<MatchItem> matchItems = [];
    if(typeList == TypeList.LIVE)
      matchItems = await MatchItem.getCurrentMatchs(context, idCompetition, page, competitionType: idCompetitionType);
    else if(typeList == TypeList.FIXTURE)
      matchItems = await MatchItem.getFixtureMatchs(context, idCompetition, page, competitionType: idCompetitionType);
    else
      matchItems = await MatchItem.getLatestResults(context, idCompetition, page, competitionType: idCompetitionType);
    if(matchItems.length > 0){
      setState(() {
        list.addAll(matchItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

}

enum TypeList{
  LIVE,
  FIXTURE,
  RESULT
}