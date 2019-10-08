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
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    if(competitionItem != null){
      idCompetition = competitionItem.id;
    }
    if(typeList == TypeList.LIVE){
      title = this.widget.localization['live'];
    }
  }

  @override
  Widget build(BuildContext context) {
    if(list.length <= 0)
      initItems();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: (isLoadPage)?
      Center(
        child: CircularProgressIndicator(),
      ):
      (list.length <= 0)?
      EmptyData(this.widget.localization):
      Container(
        padding: EdgeInsets.all(4.0),
        child: SmartRefresher(
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
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context,i){
                return Card(
                  child: MatchLayout(this.widget.localization, list[i]),
                  elevation: 8.0,
                );
              }
          ),
        ),
      )
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

  initItems(){
    page = 1;
    if(typeList == TypeList.LIVE) {
      MatchItem.getCurrentMatchs(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
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
      });
    }
  }

  Future addItems() async{
    List<MatchItem> matchItems = await MatchItem.getCurrentMatchs(context, idCompetition, page, competitionType: idCompetitionType);
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