import 'package:flutter/material.dart';
import 'fragment/fragment_competitionlist.dart';
import '../../../models/competition_item.dart';
import '../../../models/home_infos.dart';
import '../../../models/user.dart';
import '../../../models/match_item.dart';
import '../../../components/match_layout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './../../../components/empty_data.dart';

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
  Widget build(BuildContext context) {
    if(this.fragment == Fragment.COMPETITION_LIST){
      homeContenair = FragmentCompetitionList(this.widget.localization);
    }
    else{
      homeInfos = new HomeInfos();
      User.getInstance().then((user){
        this.user = user;
        if(!hasHomeInfos) {
          homeInfos.initData(context, user.id).then((v) {
            setState(() {
              initLiveWidgets();
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  elevation: 10.0,
                  child: Column(
                    children: liveWidgets,
                  ),
                )
              ],
            ),
          )
      );
    }
    return homeContenair;
  }

  void _onRefresh() async{
    //isPageRefresh = true;
    homeInfos.initData(context, user.id).then((v) {
      setState(() {
        initLiveWidgets();
        refreshController.refreshCompleted();
      });
    });
  }

  initLiveWidgets(){
    loadData = false;
    //add live match
    if(homeInfos.current_match.length > 0) {
      hasHomeInfos = true;
      liveWidgets.clear();
      liveWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Live',
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
              'See more',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor
              ),
            ),
            onPressed: () {},
          )
        ],
      ));
    }
    for(int i=0;i<homeInfos.current_match.length;i++){
      liveWidgets.add(MatchLayout(this.widget.localization, homeInfos.current_match[i]));
    }
  }
}

enum Fragment{
  HOME,
  COMPETITION,
  COMPETITION_LIST
}