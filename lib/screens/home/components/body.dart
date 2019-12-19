import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'fragment/fragment_competitionlist.dart';
import '../../../models/competition_item.dart';
import '../../../models/home_infos.dart';
import '../../../models/user.dart';
import '../../../models/match_item.dart';
import '../../../components/match_layout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './../../../components/empty_data.dart';
import '../../matchs_list/matchs_list.dart';
import 'trending_news_widget.dart';

class Body extends StatefulWidget{

  Fragment fragment;
  CompetitionItem competitionItem;
  Map localization;

  Body(this.localization,{this.fragment: Fragment.HOME,this.competitionItem});

  @override
  _BodyState createState() {
    // TODO: implement createState
    return new _BodyState(fragment,competitionItem);
  }

}

class _BodyState extends State<Body>{

  Widget homeContenair;
  Fragment fragment;
  CompetitionItem competitionItem;
  HomeInfos homeInfos;
  RefreshController refreshController;
  bool loadData = true;
  bool hasHomeInfos = false;
  User user;

  List<Widget> liveWidgets = [];
  List<Widget> fixtureWidgets = [];
  List<Widget> resultWidgets = [];
  List<Widget> trendingNews = [];

  _BodyState(this.fragment,this.competitionItem);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.fragment == Fragment.HOME) {
      refreshController = new RefreshController(initialRefresh: false);
    }
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(this.fragment == Fragment.COMPETITION_LIST){
      homeContenair = FragmentCompetitionList(this.widget.localization);
    }
    else{
      homeInfos = new HomeInfos();
      User.getInstance().then((user){
        this.user = user;
        if(!hasHomeInfos) {
          homeInfos.initData(context, user.id,this.setHomeInfos).then((v) {
            setState(() {
              initData();
            });
          });
        }
      });
      homeContenair = SmartRefresher(
          controller: refreshController,
          enablePullUp: false,
          enablePullDown: true,
          onRefresh: _onRefresh,
          header: (WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).primaryColor,
          )),
          child:(loadData)?
          Center(child: CircularProgressIndicator(),):
          (!hasHomeInfos)?
          EmptyData(this.widget.localization):
          DefaultTabController(
            length: trendingNews.length,
            // Use a Builder here, otherwise `DefaultTabController.of(context)` below
            // returns null.
            child: Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TabPageSelector(),
                    Expanded(
                      child: TabBarView(children: trendingNews),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Card(
                              elevation: 10.0,
                              child: Column(
                                children: liveWidgets,
                              ),
                            ),
                            Card(
                              elevation: 10.0,
                              child: Column(
                                children: fixtureWidgets,
                              ),
                            ),
                            Card(
                              elevation: 10.0,
                              child: Column(
                                children: resultWidgets,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      );
    }
    return homeContenair;
  }

  void _onRefresh() async{
    //isPageRefresh = true;
    homeInfos.initData(context, user.id,this.setHomeInfos).then((v) {
      setState(() {
        initData();
        refreshController.refreshCompleted();
      });
    });
  }

  setHomeInfos(HomeInfos _homeInfos){
    setState(() {
      homeInfos = _homeInfos;
    });
  }

  initData(){
    //init news widgets
    initNewsWidgets();

    //init live widgets
    initSpecificWidget(TypeList.LIVE, homeInfos.current_match, liveWidgets, this.widget.localization['live']);

    //init fixture widgets
    initSpecificWidget(TypeList.FIXTURE, homeInfos.fixture, fixtureWidgets, this.widget.localization['fixture']);

    //init fixture widgets
    initSpecificWidget(TypeList.RESULT, homeInfos.latest_result, resultWidgets, this.widget.localization['last_results']);
  }

  initNewsWidgets() {
    trendingNews.clear();
    for(int i=0;i<5;i++) {
      trendingNews.add(
          TrendingNewsWidget()
      );
    }
  }

  initSpecificWidget(TypeList typeList,List<MatchItem> matchList,List<Widget> widgets,String title){
    loadData = false;
    //add live match
    if(matchList.length > 0) {
      hasHomeInfos = true;
      widgets.clear();
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            textScaleFactor: 1.4,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .primaryColor
            ),
          ),
          FlatButton(
            child: Text(
              this.widget.localization['see_more'],
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor
              ),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return MatchsList(this.widget.localization,null,typeList,idCompetitionType: CompetitionItem.COMPETITION_TYPE,);
                  }
              ));
            },
          )
        ],
      ));
    }
    for(int i=0;i<matchList.length;i++){
      widgets.add(MatchLayout(this.widget.localization, matchList[i]));
    }
  }
}

enum Fragment{
  HOME,
  COMPETITION,
  COMPETITION_LIST
}