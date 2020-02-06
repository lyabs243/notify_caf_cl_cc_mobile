import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post_reaction.dart';

class PostReactionBox extends StatefulWidget {

  Function setReaction;
  int id_post, id_subscriber;

  PostReactionBox(this.setReaction, this.id_post, this.id_subscriber);

  @override
  _PostReactionBoxState createState() {
    return new _PostReactionBoxState(this.setReaction, this.id_post, this.id_subscriber);
  }

}

class _PostReactionBoxState extends State<PostReactionBox> {

  int currentIconFocus;
  Function setReaction;
  int id_post, id_subscriber;

  double iconHeight, iconMargin = 4.0, boxWidth;

  _PostReactionBoxState(this.setReaction, this.id_post, this.id_subscriber);

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

  deleteReaction() {
    this.setReaction(0);
    PostReaction.delete(id_post, id_subscriber, context).then((result){
      this.setReaction(0);
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
                  'assets/icons/reaction/ah_ah.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_AHAH);
              },
            ),
            InkWell(
              child: Container(
                child: Image.asset(
                  'assets/icons/reaction/trophy.png',
                  height: iconHeight,
                ),
                margin: EdgeInsets.only(right: iconMargin),
              ),
              onTap: () {
                updateReaction(PostReaction.REACTION_TROPHY);
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
                deleteReaction();
              },
            )
          ],
        ),
      ),
    );
  }

}