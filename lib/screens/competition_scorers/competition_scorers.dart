import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/competition_item.dart';
import '../../models/scorer_edition.dart';
import '../../components/empty_data.dart';
import '../../models/constants.dart' as constant;

class CompetitionScorers extends StatefulWidget{

  CompetitionItem competitionItem;

  CompetitionScorers(this.competitionItem);

  @override
  _CompetitionScorersState createState() {
    return _CompetitionScorersState(this.competitionItem);
  }

}

class _CompetitionScorersState extends State<CompetitionScorers>{

  CompetitionItem competitionItem;

  List<ScorerEdition> scorerItems = [];
  AdmobBanner admobBanner;

  bool isLoading = true;
  int page = 1;
  RefreshController refreshController;

  _CompetitionScorersState(this.competitionItem);

  @override
  void initState() {
    super.initState();
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    refreshController = new RefreshController(initialRefresh: false);
    getScorers();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  getScorers() async {
    await Future.delayed(Duration.zero);
    ScorerEdition.getScorers(context, competitionItem.id, 1).then((items){
      setState(() {
        scorerItems.addAll(items);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${competitionItem.title_small} ${MyLocalizations.instanceLocalization['scorers']}',
          overflow: TextOverflow.fade,
        ),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
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
        child: (isLoading)?
         Center(
          child: CircularProgressIndicator(),
         ) :
        ((scorerItems.length <= 0)?
        EmptyData() :
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: getScorersRows(context),
            ),
          ),
        )),
      )
    );
  }

  void _onRefresh() async{
    page = 1;
    isLoading = true;
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems(){
    ScorerEdition.getScorers(context, competitionItem.id, 1).then((items){
      setState(() {
        if(items.length > 0)
          scorerItems.clear();
        scorerItems.addAll(items);
          isLoading = false;
      });
    });
  }

  addItems(){
    ScorerEdition.getScorers(context, competitionItem.id, ++page).then((items){
      setState(() {
        scorerItems.addAll(items);
        if(items.length > 0)
          page++;
      });
      refreshController.loadComplete();
    });
  }

  List<Widget> getScorersRows(BuildContext context){
    List<Widget> scorerRows = [];
    //add ads
    scorerRows.add((constant.canShowAds)?
    Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: admobBanner,
    ): Container());
    //add header
    scorerRows.add(Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(4.0),
      height: 45,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
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
            width: MediaQuery.of(context).size.width * 10/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 40/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: new Container(
              width: 100,
              height: 100,
              child: ImageIcon(
                AssetImage(
                'assets/icons/match/goal.png'
                ),
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: new Container(
              width: 100,
              height: 100,
              child: Image.asset('assets/icons/match/match_action_goal_penalty.png'),
            ),
          ),
        ],
      ),
    ));

    //add rows
    for(int i = 1;i<= scorerItems.length;i++){
      scorerRows.add(Container(
        color: (i % 2 == 0)?Colors.grey[400] : Colors.white,
        height: 45,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
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
              width: MediaQuery.of(context).size.width * 10/100,
              child: Container(
                width: 100,
                height: 100,
                child: Image.network(scorerItems[i-1].url_flag),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].team_name_small,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 40/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].name,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].goals.toString(),
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 10/100,
              child: Center(
                child: Text(
                  scorerItems[i-1].goalsPenalty.toString(),
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
    setState(() {
      isLoading = false;
    });
    return scorerRows;
  }

}