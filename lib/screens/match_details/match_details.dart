import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/match_comments.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/competition/competition.dart';
import 'package:flutter_cafclcc/screens/home/home.dart';
import 'package:flutter_cafclcc/screens/match_edit/match_edit.dart';
import 'package:share/share.dart';
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

  MatchItem match;
  bool fromNotification;
  int matchId;
  int pageType;

  final int MOVE_TO_ACTION_TAB = 0;
  final int MOVE_TO_LINEUP_TAB = 1;
  final int MOVE_TO_VIDEO_TAB = 2;

  MatchDetails(this.match, {this.fromNotification: false, this.matchId: 0, this.pageType: 0});

  @override
  _MatchDetailsState createState() {
    return new _MatchDetailsState(this.match);
  }

}

class _MatchDetailsState extends State<MatchDetails> with SingleTickerProviderStateMixin{

  MatchItem matchItem;
  List<DrawerItem> tabsItem = [];

  List<Widget> tabViews = [];
  List<Tab> tabs = [];
  bool isLoad = true;
  User user;

  AdmobBanner admobBanner;
  
  TabController _controller;

  _MatchDetailsState(this.matchItem);

  @override
  void initState() {
    super.initState();
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    User.getInstance().then((_user) {
      setState(() {
        user = _user;
      });
    });
    //if is from notification, init match item
    if(this.widget.fromNotification) {
      initMatch();
    }
    if(matchItem != null) {
      initTabsDetails();
    }
  }

  initMatch() async {
    MatchItem.get(context, this.widget.matchId).then((value) {
      this.matchItem = value;
      initTabsDetails();
    });
  }

  initTabsDetails () {
    initTabsItems();
    initTabs();
    initTabsViews();
    _controller = TabController(
        length: tabsItem.length,
        vsync: this
    );
    
    if(this.widget.pageType == this.widget.MOVE_TO_LINEUP_TAB) {
      _controller.animateTo(1);
    }
    else if(this.widget.pageType == this.widget.MOVE_TO_VIDEO_TAB) {
      _controller.animateTo(tabsItem.length - 1);
    }
    else {
      _controller.animateTo(0);
    }
    
    setState(() {
      isLoad = false;
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
    return Scaffold(
      body: (isLoad)?
          Center(
            child: CircularProgressIndicator(),
          ):
      ((this.matchItem != null)?
      NestedScrollView(
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
                    Header(matchItem)
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
                        return new CompetitionPage(matchItem.competition);
                      }));
                    }
                ),
                IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      Share.share(matchItem.toString());
                    }
                ),
                (user != null && user.type == User.USER_TYPE_ADMIN)?
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return MatchEdit(matchItem);
                      })).then((result) {
                        if(result != null) {
                          setState(() {
                            matchItem = result;
                          });
                        }
                      });
                    }
                ): Container()
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
      ) : EmptyData()),
      appBar: (this.matchItem != null)? null :
      AppBar(
        title: Text(''),
      ),
      bottomSheet: (constant.canShowAds)?
      Container(
        width: MediaQuery.of(context).size.width,
        child: admobBanner,
      ): Container(height: 1.0,),
    );
  }

  initTabsItems(){
    DrawerItem actions = new DrawerItem(0, MyLocalizations.instanceLocalization['actions'], DrawerType.item);
    DrawerItem line_up = new DrawerItem(1, MyLocalizations.instanceLocalization['line_up'], DrawerType.item);
    DrawerItem table = new DrawerItem(2, MyLocalizations.instanceLocalization['table'], DrawerType.item);
    DrawerItem comments = new DrawerItem(3, MyLocalizations.instanceLocalization['comments'], DrawerType.item);
    DrawerItem video = new DrawerItem(4, MyLocalizations.instanceLocalization['video'], DrawerType.item);

    tabsItem.add(actions);
    tabsItem.add(line_up);
    if(this.matchItem.editionStage.type == EditionStage.TYPE_GROUP)
      tabsItem.add(table);
    tabsItem.add(comments);
    tabsItem.add(video);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) {
        /*Navigator.push(context, MaterialPageRoute(
            builder: (_context){
              return HomePage(localization);
            }
        ));*/
        return HomePage();
      },
    )) ?? false;
  }


  initTabs(){
    tabsItem.forEach((item){
      tabs.add(Tab(text: item.title,));
    });
  }

  initTabsViews(){
    //init actions
    tabViews.add(MatchActionsLayout(matchItem));

    //init line up
    tabViews.add(MatchLineupLayout(matchItem));

    //init table
    if(this.matchItem.editionStage.type == EditionStage.TYPE_GROUP)
      tabViews.add(CompetitionTableLayout(matchItem.idGroupA,matchItem.editionStage.id));

    //init comments
    tabViews.add(MatchComments(matchItem));

    //init video
    tabViews.add(YoutubeVideo(this.matchItem));
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