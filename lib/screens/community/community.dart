import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';

class Community extends StatefulWidget {

  Map localization;

  Community(this.localization);

  @override
  _CommunityState createState() {
    return _CommunityState(this.localization);
  }

}

class _CommunityState extends State<Community> {

  Map localization;

  _CommunityState(this.localization);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0,color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal:16.0)
              ),
            ),
          ),
          body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 10,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    return PostWidget(localization, null);
                  }
                ),
                Center(
                  child: Text(
                    'Pour toi',
                    textScaleFactor: 3.0,
                  ),
                )
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