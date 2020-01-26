import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/match_comments.dart';
import 'package:flutter_cafclcc/screens/competition/competition.dart';
import '../../models/match_item.dart';
import '../../models/edition_stage.dart';
import 'components/header.dart';
import '../../models/drawer_item.dart';
import '../../components/match_actions_layout.dart';
import '../../components/match_lineup_layout.dart';
import '../../components/youtube_video.dart';
import '../../components/competition_table_layout.dart';
import '../../models/constants.dart' as constant;

class MatchDetails extends StatefulWidget{

  Map localization;
  MatchItem match;

  MatchDetails(this.localization,this.match);

  @override
  _MatchDetailsState createState() {
    return new _MatchDetailsState(this.localization,this.match);
  }

}

class _MatchDetailsState extends State<MatchDetails> with SingleTickerProviderStateMixin{

  Map localization;
  MatchItem matchItem;
  List<DrawerItem> tabsItem = [];

  List<Widget> tabViews = [];
  List<Tab> tabs = [];

  AdmobBanner admobBanner;
  
  TabController _controller;

  _MatchDetailsState(this.localization,this.matchItem);

  @override
  void initState() {
    super.initState();
    Admob.initialize(constant.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    initTabsItems();
    initTabs();
    initTabsViews();
    _controller = TabController(
        length: tabsItem.length,
        vsync: this
    );
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBexIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height / 2.8,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25.0),),
                    Header(localization, matchItem)
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return new CompetitionPage(matchItem.competition, localization);
                      }));
                    }
                ),
                IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: (){

                    }
                )
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _controller,
                  unselectedLabelColor: Colors.grey,
                  tabs: tabs,
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0,color: Colors.white),
                      insets: EdgeInsets.symmetric(horizontal:16.0,vertical: 2.0)
                  ),
                ),
              ),
              pinned: true,
            )
          ];
        },
        body: new TabBarView(
                controller: _controller,
                children: tabViews,
              ),
      ),
      bottomSheet: (constant.canShowAds)?
      Container(
        width: MediaQuery.of(context).size.width,
        child: admobBanner,
      ): Container(),
    );
  }

  initTabsItems(){
    DrawerItem actions = new DrawerItem(0, localization['actions'], DrawerType.item);
    DrawerItem line_up = new DrawerItem(1, localization['line_up'], DrawerType.item);
    DrawerItem table = new DrawerItem(2, localization['table'], DrawerType.item);
    DrawerItem comments = new DrawerItem(3, localization['comments'], DrawerType.item);
    DrawerItem video = new DrawerItem(4, localization['video'], DrawerType.item);

    tabsItem.add(actions);
    tabsItem.add(line_up);
    if(this.matchItem.editionStage.type == EditionStage.TYPE_GROUP)
      tabsItem.add(table);
    tabsItem.add(comments);
    tabsItem.add(video);
  }

  initTabs(){
    tabsItem.forEach((item){
      tabs.add(Tab(text: item.title,));
    });
  }

  initTabsViews(){
    //init actions
    tabViews.add(MatchActionsLayout(localization, matchItem));

    //init line up
    tabViews.add(MatchLineupLayout(localization, matchItem));

    //init table
    if(this.matchItem.editionStage.type == EditionStage.TYPE_GROUP)
      tabViews.add(CompetitionTableLayout(localization,matchItem.idGroupA,matchItem.editionStage.id));

    //init comments
    tabViews.add(MatchComments(localization, matchItem));

    //init video
    tabViews.add(YoutubeVideo(this.localization,this.matchItem));
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.black),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: _tabBar,
        )
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}