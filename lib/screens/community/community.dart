import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/community/components/action_post_dialog.dart';
import 'package:flutter_cafclcc/screens/community/components/all_posts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Community extends StatefulWidget {

  Community();

  @override
  _CommunityState createState() {
    return _CommunityState();
  }

}

class _CommunityState extends State<Community> with SingleTickerProviderStateMixin {

  User user;
  int activeSubscriber = 0;
  TabController _tabController;

  _CommunityState();

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
            title: Text(MyLocalizations.instanceLocalization['community']),
            bottom: TabBar(
              tabs: [
                Tab(
                    text: MyLocalizations.instanceLocalization['all_posts'],
                    icon: ImageIcon(
                      AssetImage(
                        'assets/icons/all_posts.png',
                      ),
                    )
                ),
                Tab(
                  text: MyLocalizations.instanceLocalization['your_posts'],
                  icon: ImageIcon(
                    AssetImage(
                      'assets/icons/user_posts.png',
                    ),
                  )
                ),
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
            tooltip: MyLocalizations.instanceLocalization['add_post'],
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return PostDialog(null, user);
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
                AllPosts(activeSubscriber, 0): Container(),
                (activeSubscriber > 0)?
                AllPosts(activeSubscriber, activeSubscriber): Container()
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