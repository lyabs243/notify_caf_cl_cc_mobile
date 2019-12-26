import 'package:flutter/material.dart';
import 'package:youtube_player/controls.dart';

class PostReactionBox extends StatefulWidget {

  Map localization;

  PostReactionBox(this.localization);

  @override
  _PostReactionBoxState createState() {
    return new _PostReactionBoxState(localization);
  }

}

class _PostReactionBoxState extends State<PostReactionBox> {

  Map localization;
  int currentIconFocus;

  double iconHeight, iconMargin = 4.0, boxWidth;

  _PostReactionBoxState(this.localization);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
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

              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: iconHeight/1.2, color: Colors.red,),
              onPressed: (){

              },
            )
          ],
        ),
      ),
    );
  }

}