import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/news_item.dart';
import 'package:flutter_cafclcc/screens/competition/competition.dart';
import 'package:flutter_cafclcc/screens/competition_list/competition_list.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
import 'package:flutter_html/flutter_html.dart';
import '../home.dart';
import '../../../models/competition_item.dart';
import '../../../models/home_infos.dart';
import '../../../models/user.dart';
import '../../../models/match_item.dart';
import '../../../components/match_layout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './../../../components/empty_data.dart';
import '../../matchs_list/matchs_list.dart';
import 'trending_news_widget.dart';
import '../../news_list/news_list.dart';
import '../../../models/constants.dart' as constant;

class Body extends StatefulWidget{

  CompetitionItem competitionItem;

  Body({this.competitionItem});

  @override
  _BodyState createState() {
    // TODO: implement createState
    return new _BodyState(competitionItem);
  }

}

class _BodyState extends State<Body>{

  Widget homeContenair;
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

  AdmobBanner admobBanner;

  _BodyState(this.competitionItem);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.LARGE_BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    refreshController = new RefreshController(initialRefresh: false);
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
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          EmptyData():
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    color: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingNews.length,
                      itemBuilder: (context,index){
                        return trendingNews[index];
                      },
                    ),
                  ),
                  Container(
                    height: 65.0,
                    padding: EdgeInsets.all(5.0),
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: homeInfos.featured_competitions.length+1,
                      itemBuilder: (context,index){
                        return Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            onPressed: (){
                              if(index == homeInfos.featured_competitions.length) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return CompetitionList();
                                        }
                                    ));
                              }
                              else {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return CompetitionPage(homeInfos
                                          .featured_competitions[index]);
                                    }
                                ));
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            elevation: 15.0,
                            textColor: Colors.white,
                            child: Text(
                              (index == homeInfos.featured_competitions.length)?
                              MyLocalizations.instanceLocalization['see_more']:
                              homeInfos.featured_competitions[index].title,
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                          padding: EdgeInsets.all(2.0),
                        );
                      },
                    ),
                  ),
                  (constant.canShowAds)?
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    child: admobBanner,
                  ) : Container(),
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
          ),
      );
    return homeContenair;
  }

  void _onRefresh() async{
    //isPageRefresh = true;
    homeInfos.trending_news.clear();
    homeInfos.current_match.clear();
    homeInfos.fixture.clear();
    homeInfos.latest_result.clear();
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
    initSpecificWidget(TypeList.LIVE, homeInfos.current_match, liveWidgets, MyLocalizations.instanceLocalization['live']);

    //init fixture widgets
    initSpecificWidget(TypeList.FIXTURE, homeInfos.fixture, fixtureWidgets, MyLocalizations.instanceLocalization['fixture']);

    //init fixture widgets
    initSpecificWidget(TypeList.RESULT, homeInfos.latest_result, resultWidgets, MyLocalizations.instanceLocalization['last_results']);
  }

  initNewsWidgets() {
    trendingNews.clear();
    homeInfos.trending_news.forEach((news){
      trendingNews.add(
          TrendingNewsWidget(news)
      );
    });
    if(trendingNews.length == 0) {
      trendingNews.add(EmptyData());
    } else {
      trendingNews.add(FlatButton(
        child: Text(
          MyLocalizations.instanceLocalization['see_more'],
          style: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColor
          ),
        ),
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (context){
                return NewsList(CompetitionItem.COMPETITION_TYPE);
              }
          );
          PageTransition(context, materialPageRoute, false).checkForRateAndShareSuggestion();
        },
      ));
    }
  }
  
  Widget initView(List<NewsItem> listN,int index) {
    return Text('${index} un item');
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
              MyLocalizations.instanceLocalization['see_more'],
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor
              ),
            ),
            onPressed: () {
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (context){
                    return MatchsList(null,typeList,idCompetitionType: CompetitionItem.COMPETITION_TYPE,);
                  }
              );
              PageTransition(context, materialPageRoute, false).checkForRateAndShareSuggestion();
            },
          )
        ],
      ));
    }
    for(int i=0;i<matchList.length;i++){
      widgets.add(MatchLayout(matchList[i]));
    }
  }
}

enum Fragment{
  HOME,
  COMPETITION,
  COMPETITION_LIST
}