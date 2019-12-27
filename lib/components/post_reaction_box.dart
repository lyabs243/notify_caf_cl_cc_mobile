import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post_reaction.dart';
import 'package:youtube_player/controls.dart';

class PostReactionBox extends StatefulWidget {

  Map localization;
  Function setReaction;
  int id_post, id_subscriber;

  PostReactionBox(this.localization, this.setReaction, this.id_post, this.id_subscriber);

  @override
  _PostReactionBoxState createState() {
    return new _PostReactionBoxState(localization, this.setReaction, this.id_post, this.id_subscriber);
  }

}

class _PostReactionBoxState extends State<PostReactionBox> {

  Map localization;
  int currentIconFocus;
  Function setReaction;
  int id_post, id_subscriber;

  double iconHeight, iconMargin = 4.0, boxWidth;

  _PostReactionBoxState(this.localization, this.setReaction, this.id_post, this.id_subscriber);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  updateReaction(int reaction) {
    this.setReaction(reaction);
    PostReaction.add(id_post, id_subscriber, reaction, context).then((result){
        this.setReaction(reaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    iconHeight = MediaQuery.of(context).size.width / 12;
    boxWidth = MediaQuery.of(context).size.width /1.3;
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        width: boxWidth,
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/like.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_LIKE);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/love.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_LOVE);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/goal.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_GOAL);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/offside.jpg',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_OFFSIDE);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/red_card.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_REDCARD);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/angry.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_ANGRY);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: iconHeight/1.2, color: Colors.red,),
              onPressed: (){
                updateReaction(0);
              },
            )
          ],
        ),
      ),
    );
  }

}