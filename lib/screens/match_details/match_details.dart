import 'package:flutter/material.dart';
import '../../models/match_item.dart';
import '../../models/edition_stage.dart';
import 'components/header.dart';
import '../../models/drawer_item.dart';
import '../../components/match_actions_layout.dart';
import '../../components/match_lineup_layout.dart';

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
  
  TabController _controller;

  _MatchDetailsState(this.localization,this.matchItem);

  @override
  void initState() {
    super.initState();
    initTabsItems();
    initTabs();
    initTabsViews();
    _controller = TabController(length: tabsItem.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            expandedHeight: 220.0,
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
                    Icons.share,
                    color: Colors.white,
                  ),
                  onPressed: (){

                  }
              )
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(color: Colors.black),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: new TabBar(
                      controller: _controller,
                      tabs: tabs,
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 3.0,color: Colors.white),
                          insets: EdgeInsets.symmetric(horizontal:16.0,vertical: 2.0)
                      ),
                    ),
                  ),
                ),
                new Container(
                  height: MediaQuery.of(context).size.height/1.9,
                  child: new TabBarView(
                    controller: _controller,
                    children: tabViews,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
      tabViews.add(Center(child: Text('Table',textScaleFactor: 2.5,),));

    //init comments
    tabViews.add(Center(child: Text('Comments',textScaleFactor: 2.5,),));

    //init video
    tabViews.add(Center(child: Text('Video',textScaleFactor: 2.5,),));
  }

}