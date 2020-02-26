import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/competition_item.dart';
import '../../models/match_item.dart';
import '../../components/match_layout.dart';
import '../../components/empty_data.dart';
import '../../models/constants.dart' as constants;

class MatchsList extends StatefulWidget{

  CompetitionItem competitionItem;
  int idCompetitionType;
  TypeList typeList;

  MatchsList(this.competitionItem,this.typeList,{this.idCompetitionType: 0});

  @override
  _MatchListState createState() {
    return new _MatchListState(this.competitionItem,this.idCompetitionType,this.typeList);
  }

}

class _MatchListState extends State<MatchsList>{

  RefreshController refreshController;
  List<MatchItem> list = [];
  List<CompetitionItem> listCompetitions = [];
  int pageCompetitions=1;
  int page = 1;
  int selectedCompetition = 0;
  bool isLoadPage = true, isLoadCompetition = false, isLoadCompetitionMatchs = false, isAddingItems = false;
  CompetitionItem competitionItem;
  int idCompetitionType;
  TypeList typeList;
  int idCompetition = 0;
  String title = '';
  ScrollController _scrollController;
  AdmobBanner admobBanner, admobBannerBottom;

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
    Admob.initialize(constants.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constants.getAdmobBannerId(),
      adSize: AdmobBannerSize.LARGE_BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    admobBannerBottom = AdmobBanner(
      adUnitId: constants.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_competitionScrollListener);
    refreshController = new RefreshController(initialRefresh: false);
    if(competitionItem != null){
      idCompetition = competitionItem.id;
    }
    if(typeList == TypeList.LIVE){
      title = MyLocalizations.instanceLocalization['live'];
    }
    else if(typeList == TypeList.FIXTURE){
    title = MyLocalizations.instanceLocalization['fixture'];
    }
    else if(typeList == TypeList.OTHER){
      title = MyLocalizations.instanceLocalization['other_matchs'];
    }
    else{
      title = MyLocalizations.instanceLocalization['last_results'];
    }
    initCompetitions();
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
          child: Column(
            children: <Widget>[
              (competitionItem != null)?
              Container():
              Container(
                height: 65.0,
                padding: EdgeInsets.all(5.0),
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listCompetitions.length+2,
                  controller: _scrollController,
                  itemBuilder: (context,index){
                    return (index > listCompetitions.length)?
                    (
                        (isLoadCompetition)?
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          width: 50.0,
                          child: CircularProgressIndicator(),
                        ): Container()
                    ):
                      Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            selectedCompetition = index;
                          });
                          if(index == 0) {
                            idCompetition = 0;
                            idCompetitionType = CompetitionItem.COMPETITION_TYPE;
                          }
                          else {
                            idCompetition = listCompetitions[index-1].id;
                            idCompetitionType = 0;
                          }
                          setState(() {
                            isLoadPage = true;
                            list.clear();
                            isLoadCompetitionMatchs = true;
                            initItems();
                          });
                        },
                        color: (selectedCompetition == index)? Theme.of(context).primaryColor : Colors.white,
                        elevation: 15.0,
                        textColor: (selectedCompetition == index)? Colors.white : Theme.of(context).primaryColor,
                        child: Text(
                          (index == 0)?
                          MyLocalizations.instanceLocalization['all_competitions']:
                          listCompetitions[index-1].title,
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      padding: EdgeInsets.all(2.0),
                    );
                  },
                ),
              ),
              (isLoadPage)?
              Center(
                child: CircularProgressIndicator(),
              ):
              (list.length <= 0)?
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
                      body =  Container();
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
                child: (isLoadCompetitionMatchs)?
                Center(
                  child: CircularProgressIndicator(),
                ):
                ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.all(4.0),
                    itemBuilder: (context,i){
                      return Container(
                        child: Column(
                          children: <Widget>[
                            (constants.canShowAds && (i - 1 == 0 || (i - 1) % 10 == 0))?
                            Container(
                              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                              child: admobBanner,
                            ): Container(),
                            Card(
                              child: MatchLayout(list[i]),
                              elevation: 8.0,
                            ),
                            (i == list.length - 1 && isAddingItems)?
                            Container(
                              child: Text(
                                MyLocalizations.instanceLocalization['loading'],
                                textScaleFactor: 2.0,
                              ),
                            ): Container(),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: (i == list.length -1)? 20.0 : 0.0),
                      );
                    }
                ),
                )
              )
            ],
          ),
        ),
        bottomSheet: (constants.canShowAds)?
        Container(
          width: MediaQuery.of(context).size.width,
          child: admobBannerBottom,
        ): Container(height: 1.0,)
    );
  }

  void _onRefresh() async{
    setState(() {
      isLoadPage = true;
    });
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
    else if(typeList == TypeList.OTHER) {
      MatchItem.getOtherFixtures(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
        initMatchs(result);
      });
    }
    else {
      MatchItem.getLatestResults(context, idCompetition, page, competitionType: idCompetitionType).then((result) {
        initMatchs(result);
      });
    }
  }

  initCompetitions() async{
    await Future.delayed(Duration.zero);
    pageCompetitions = 1;
    CompetitionItem.getCompetitions(context, pageCompetitions).then((result){
      if(result.length > 0){
        setState(() {
          pageCompetitions++;
          listCompetitions.clear();
          listCompetitions.addAll(result);
        });
      }
    });
  }

  initMatchs(List<MatchItem> result){
    setState(() {
      if (result.length > 0) {
        setState(() {
          page++;
          list.clear();
          list.addAll(result);
        });
      }
      isLoadPage = false;
      isLoadCompetitionMatchs = false;
    });
  }

  Future addItems() async{
    setState(() {
      isAddingItems = true;
    });
    List<MatchItem> matchItems = [];
    if(typeList == TypeList.LIVE) {
      matchItems = await MatchItem.getCurrentMatchs(
          context, idCompetition, page, competitionType: idCompetitionType);
    }
    else if(typeList == TypeList.FIXTURE) {
      matchItems = await MatchItem.getFixtureMatchs(
          context, idCompetition, page, competitionType: idCompetitionType);
    }
    else if(typeList == TypeList.OTHER) {
      matchItems = await MatchItem.getOtherFixtures(
          context, idCompetition, page, competitionType: idCompetitionType);
    }
    else {
      matchItems = await MatchItem.getLatestResults(
          context, idCompetition, page, competitionType: idCompetitionType);
    }
    if(matchItems.length > 0){
      admobBanner = AdmobBanner(
        adUnitId: constants.getAdmobBannerId(),
        adSize: AdmobBannerSize.LARGE_BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        },
      );
      setState(() {
        list.addAll(matchItems);
        page++;
      });
    }
    setState(() {
      isAddingItems = false;
    });
    refreshController.loadComplete();
  }

  _competitionScrollListener() { //top
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isLoadCompetition = true;
      });
      addCompetitionItems();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) { //top

    }
  }

  Future addCompetitionItems() async{
    List<CompetitionItem> competItems = await CompetitionItem.getCompetitions(context,pageCompetitions);
    if(competItems.length > 0){
      setState(() {
        listCompetitions.addAll(competItems);
        pageCompetitions++;
      });
    }
    setState(() {
      isLoadCompetition = false;
    });
  }

}

enum TypeList{
  LIVE,
  FIXTURE,
  RESULT,
  OTHER
}