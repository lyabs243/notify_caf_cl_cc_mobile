import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_reaction_box.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/post_reaction.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';

class PostWidget extends StatefulWidget {

  Map localization;
  Post post;

  PostWidget(this.localization, this.post);

  @override
  _PostWidgetState createState() {
    return new _PostWidgetState(this.localization, this.post);
  }

}

class _PostWidgetState extends State<PostWidget> {

  Map localization;
  Post post;
  User currentUser;

  bool showReactionBox = false;

  _PostWidgetState(this.localization, this.post);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = new User();
    user.url_profil_pic = post.subscriber.url_profil_pic;
    User.getInstance().then((_user){
      setState(() {
        currentUser = _user;
      });
    });
    return Stack(
      children: <Widget>[
        Card(
          elevation: 15.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
                        Column(
                          children: <Widget>[
                            RichText(
                              text: new TextSpan(
                                text: post.subscriber.full_name,
                                style: new TextStyle(
                                    color: Theme.of(context).textTheme.body1.color,fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      User user = new User();
                                      user.id_subscriber = post.id_subscriber;
                                      return new UserProfile(currentUser,user,localization);
                                    }));
                                  },
                              ),
                            ),
                            Text(convertDateToAbout(post.register_date, localization)),
                          ],
                        )
                      ],
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        var list = List<PopupMenuEntry<Object>>();
                        list.add(
                          PopupMenuItem(
                            child: Text(localization['update']),
                            value: 1,
                            enabled: (currentUser.id_subscriber == post.id_subscriber),
                          ),
                        );
                        list.add(
                          PopupMenuItem(
                            child: Text(localization['delete']),
                            value: 1,
                            enabled: (currentUser.id_subscriber == post.id_subscriber),
                          ),
                        );
                        list.add(
                          PopupMenuDivider(
                            height: 10,
                          ),
                        );
                        list.add(
                          PopupMenuItem(
                            child: Text(localization['report_as_abusive']),
                            value: 1,
                            enabled: (currentUser.active == 1),
                          ),
                        );
                        list.add(
                            PopupMenuItem(
                              child: Text(localization['block_post']),
                              value: 2,
                              enabled: (currentUser.active == 1 && currentUser.type == User.USER_TYPE_ADMIN),
                            )
                        );
                        return list;
                      },
                    )
                  ],
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: (post.post.length > 150)?
                          post.post.substring(0, 150):
                          post.post,
                          style: new TextStyle(color: Theme.of(context).textTheme.body1.color),
                        ),
                        (post.post.length > 150)?
                        new TextSpan(
                          text: '...${localization['see_more']}',
                          style: new TextStyle(color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {

                            },
                        ):
                        TextSpan(),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 8.0)),
                (post.url_image != null && post.url_image.length > 0)?
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Image.network(
                    post.url_image,
                    fit: BoxFit.cover,
                  ),
                ):
                Container(),
                Padding(padding: EdgeInsets.only(bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Row(
                      children: getTopReactions(),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey[800],
                ),
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () {
                          setState(() {
                            showReactionBox = !showReactionBox;
                          });
                        },
                        icon: ImageIcon(
                          AssetImage
                          (
                            PostReaction.getReactionIconPath(post.reaction.subscriber_reaction)
                          ),
                          size: 20.0
                        ),
                        label: Text(
                          PostReaction.getReactionText(post.reaction.subscriber_reaction, localization),
                          style: TextStyle(
                            color: PostReaction.getReactionColor(post.reaction.subscriber_reaction, context)
                          ),
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        (showReactionBox)?
        Positioned(
          child: PostReactionBox(localization),
          right: 40.0,
          bottom: 60.0,
        ):
        Container()
      ],
    );
  }

  getTopReactions(){
    List<Widget> reactionsWidget = [];
    post.reaction.top_reactions.forEach((reaction){
      reactionsWidget.add(Image.asset(
        PostReaction.getReactionIconPath(reaction),
        height: 20.0,
      ));
    });
    if(post.reaction.total > 0) {
      reactionsWidget.add(
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: Text(post.reaction.total.toString()),
          )
      );
    }
    return reactionsWidget;
  }

}