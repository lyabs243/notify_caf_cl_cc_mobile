import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_reaction_box.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/post_reaction.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/community/community.dart';
import 'package:flutter_cafclcc/screens/community/components/action_post_dialog.dart';
import 'package:flutter_cafclcc/screens/community/components/all_posts.dart';
import 'package:flutter_cafclcc/screens/post_details/post_details.dart';
import 'package:flutter_cafclcc/screens/community/components/signal_post_dialog.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'alert_dialog.dart' as alert;

class PostWidget extends StatefulWidget {

  Map localization;
  Post post;
  double elevation;
  bool clickable = true, showAllText;

  Function updateView;

  PostWidget(this.localization, this.post, {this.clickable: true, this.updateView: null, this.showAllText: false, this.elevation: 15.0});

  @override
  _PostWidgetState createState() {
    return new _PostWidgetState(this.localization, this.post, this.updateView, this.showAllText, this.elevation);
  }

}

class _PostWidgetState extends State<PostWidget> {

  Map localization;
  Post post;
  User currentUser, user;
  Function updateView;
  double elevation;
  ProgressDialog progressDialog;

  bool showReactionBox = false, showAllText;

  UserPostHeaderInfos userPostHeaderInfos;

  _PostWidgetState(this.localization, this.post, this.updateView, this.showAllText, this.elevation);

  @override
  void initState() {
    super.initState();
    user = new User();
    user.id_subscriber = post.id_subscriber;
    user.full_name = post.subscriber.full_name;
    user.url_profil_pic = post.subscriber.url_profil_pic;
    user.fanBadge = post.subscriber.fanBadge;
    User.getInstance().then((_user){
      setState(() {
        currentUser = _user;
        userPostHeaderInfos = UserPostHeaderInfos(localization, user, currentUser, post.register_date);
      });
    });
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: localization['loading']);
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        InkWell(
          child: Card(
            elevation: this.elevation,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (userPostHeaderInfos != null)? userPostHeaderInfos : Container(),
                      PopupMenuButton(
                        onSelected: (index) {
                          switch(index) {
                            case 1: //udate
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PostDialog(localization, post, currentUser);
                                  }
                              ));
                              break;
                            case 2: //delete
                              alert.showAlertDialog
                              (
                                  context,
                                  this.widget.localization['warning'],
                                  this.widget.localization['want_delete_post'],
                                  this.widget.localization,
                                  (){
                                    deletePost();
                                  }
                              );
                              break;
                            case 3:
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return SignalPostDialog(localization, post, currentUser);
                              }));
                              break;
                          }
                        },
                        itemBuilder: (context) {
                          var list = List<PopupMenuEntry<Object>>();
                          if(currentUser.id_subscriber == post.id_subscriber && currentUser.active == 1) {
                            list.add(
                              PopupMenuItem(
                                child: Text(localization['update']),
                                value: 1,
                                enabled: (currentUser.id_subscriber ==
                                    post.id_subscriber &&
                                    currentUser.active == 1),
                              ),
                            );
                            list.add(
                              PopupMenuItem(
                                child: Text(localization['delete']),
                                value: 2,
                                enabled: (currentUser.id_subscriber ==
                                    post.id_subscriber &&
                                    currentUser.active == 1),
                              ),
                            );
                            list.add(
                              PopupMenuDivider(
                                height: 10,
                              ),
                            );
                          }
                          if(currentUser.active == 1) {
                            list.add(
                              PopupMenuItem(
                                child: Text(localization['report_as_abusive']),
                                value: 3,
                                enabled: (currentUser.active == 1),
                              ),
                            );
                          }
                          if(currentUser.active == 1 && currentUser.type == User.USER_TYPE_ADMIN) {
                            list.add(
                                PopupMenuItem(
                                  child: Text(localization['block_post']),
                                  value: 2,
                                  enabled: (currentUser.active == 1 &&
                                      currentUser.type == User.USER_TYPE_ADMIN),
                                )
                            );
                          }
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
                            text: (showAllText)?
                            post.post :
                            ((post.post.length > 150)?
                            post.post.substring(0, 150):
                            post.post),
                            style: new TextStyle(color: Theme.of(context).textTheme.body1.color),
                          ),
                          (post.post.length > 150 && !showAllText)?
                          new TextSpan(
                            text: '...${localization['see_more']}',
                            style: new TextStyle(color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  showAllText = true;
                                });
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: getTopReactions(),
                      ),
                      (this.widget.post.total_comments > 0)?
                      FlatButton(
                        child: Text(
                          '${this.widget.post.total_comments} ${localization['comments']}'
                        ),
                        onPressed: () {
                          if(this.widget.clickable) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return new PostDetails(localization, post);
                            }));
                          }
                        },
                      ) : Container()
                    ],
                  ),
                  Divider(
                    color: Colors.grey[800],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton.icon(
                          onPressed: () {
                            setState(() {
                              showReactionBox = !showReactionBox;
                            });
                          },
                          icon: Image.asset(
                            PostReaction.getReactionIconPath(post.reaction.subscriber_reaction),
                            height: 20.0,
                          ),
                          label: Text(
                            PostReaction.getReactionText(post.reaction.subscriber_reaction, localization),
                            style: TextStyle(
                                color: PostReaction.getReactionColor(post.reaction.subscriber_reaction, context)
                            ),
                          )
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            if(this.widget.clickable) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return new PostDetails(localization, post);
                              }));
                            }
                          },
                          icon: ImageIcon(
                              AssetImage(
                                  'assets/icons/date.png'
                              ),
                              size: 20.0
                          ),
                          label: Text(
                            localization['comment'],
                            style: TextStyle(
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            if(this.widget.clickable) {
              MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (context) {
                return new PostDetails(localization, post);
              });
              PageTransition(context, localization, materialPageRoute, false).checkForRateAndShareSuggestion();
            }
          },
        ),
        (showReactionBox)?
        Positioned(
          child: PostReactionBox(localization, setReaction, post.id, currentUser.id_subscriber),
          right: 40.0,
          bottom: 60.0,
        ):
        Container()
      ],
    );
  }

  setReaction(reaction) {
      setState(() {
        if(reaction > -1) {
          post.reaction.subscriber_reaction = reaction;
          Post.getPost(context, post.id, currentUser.id_subscriber).then((nPost){
            post = nPost;
            if(updateView != null) {
              updateView(post);
            }
          });
        }
        showReactionBox = false;
      });
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

  deletePost() {
    progressDialog.show();
    this.widget.post.deletePost(context).then((success){
      progressDialog.hide();
      if(success) {
        Toast.show(this.widget.localization['post_deleted'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return Community(localization);
            }
        ));
      }
      else{
        Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
  }

}