import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:youtube_player/youtube_player.dart';
import '../models/match_item.dart';
import '../models/match_video.dart';
import 'empty_data.dart';

class MatchComments extends StatefulWidget{

  Map localization;
  MatchItem matchItem;

  MatchComments(this.localization, this.matchItem);

  @override
  _MatchCommentsState createState() {
    return _MatchCommentsState(this.localization, this.matchItem);
  }

}

class _MatchCommentsState extends State<MatchComments>{

  Map localization;
  MatchItem matchItem;

  List<Comment> comments;

  _MatchCommentsState(this.localization, this.matchItem);

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  initData() async {
    await Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.16,
            child: new TextField(
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintText: localization['type_comment'],
              ),
              maxLines: 1,
              maxLength: 250,
              onChanged: (val){
                setState((){

                });
              },
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
                size: 45.0,
              ),
              onPressed: () {

              }
          )
        ],
      ),
    );
  }

}