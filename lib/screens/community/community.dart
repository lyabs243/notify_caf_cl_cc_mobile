import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/community/components/action_post_dialog.dart';
import 'package:flutter_cafclcc/screens/community/components/all_posts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Community extends StatefulWidget {

  Map localization;

  Community(this.localization);

  @override
  _CommunityState createState() {
    return _CommunityState(this.localization);
  }

}

class _CommunityState extends State<Community> with SingleTickerProviderStateMixin {

  Map localization;
  User user;
  int activeSubscriber = 0;
  TabController _tabController;

  _CommunityState(this.localization);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    User.getInstance().then((user){
      this.user = user;
      setState((){
        activeSubscriber = user.id_subscriber;
      });
    });
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(this.widget.localization['community']),
            bottom: TabBar(
              tabs: [
                Tab(text: localization['all_posts'], icon: Icon(Icons.all_inclusive),),
                Tab(text: localization['your_posts'], icon: Icon(Icons.plus_one)),
              ],
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal:16.0)
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: localization['add_post'],
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return PostDialog(localization, null, user);
                  },
                  fullscreenDialog: true
              )).then((v){
                setState((){
                  _tabController.animateTo(1);
                });
              });
            }
          ),
          body: TabBarView(
            controller: _tabController,
              children: [
                (activeSubscriber > 0)?
                AllPosts(localization, activeSubscriber, 0): Container(),
                (activeSubscriber > 0)?
                AllPosts(localization, activeSubscriber, activeSubscriber): Container()
              ]
          ),
        ),
      );
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

}