import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'alert_dialog.dart' as alert;
import '../models/constants.dart' as constants;

import 'action_comment_dialog.dart';

class CommentWidget extends StatefulWidget {

  Comment comment;
  User user, currentUser;
  Map localization;
  Function updateDeleleteState;

  CommentWidget(this.comment, this.user, this.currentUser,
      this.localization, this.updateDeleleteState);

  @override
  _CommentWidgetState createState() {
    return _CommentWidgetState(this.comment, this.user, this.currentUser,
        this.localization, this.updateDeleleteState);
  }

}

class _CommentWidgetState extends State<CommentWidget> {

  Comment comment;
  User user, currentUser;
  Map localization;

  ProgressDialog progressDialog;

  Function updateDeleleteState;

  _CommentWidgetState(this.comment, this.user, this.currentUser,
      this.localization, this.updateDeleleteState);

  @override
  void initState() {
    super.initState();
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: localization['loading']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 15 / 100,
            child: ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 70 / 100,
            child: Bubble(
              margin: BubbleEdges.only(top: 10),
              nip: BubbleNip.leftTop,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          (user.fanBadge != null)?
                          Row(
                            children: <Widget>[
                              Container(
                                width: 15.0,
                                height: 15.0,
                                child: CircleAvatar(
                                  radius: 30.0,
                                  child: ClipOval(
                                    child: Image.network(
                                      this.user.fanBadge.url_logo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Text(
                                this.user.fanBadge.title,
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                    color: constants.fromHex(this.user.fanBadge.color),
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ):
                          Container(),
                          RichText(
                            text: new TextSpan(
                              text: user.full_name,
                              style: new TextStyle(
                                  color: Theme.of(context).textTheme.body1.color,fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return new UserProfile(currentUser,user,localization);
                                  }));
                                },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0),),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: comment.comment,
                            style: new TextStyle(color: Theme.of(context).textTheme.body1.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0),),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      constants.convertDateToAbout(this.comment.register_date, localization),
                      textScaleFactor: 0.8,
                      style: TextStyle(
                      ),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 10/100,
            child: PopupMenuButton(
              onSelected: (index) {
                switch(index) {
                  case 1: //udate
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CommentDialog(localization, comment, currentUser);
                        }
                    )).then((_comment){
                      if(_comment != null && _comment.toString().length > 0) {
                        setState(() {
                          comment.comment = _comment.toString();
                        });
                      }
                    });
                    break;
                  case 2: //delete
                    alert.showAlertDialog
                      (
                        context,
                        this.localization['warning'],
                        this.localization['want_delete_comment'],
                        this.localization,
                            (){
                          deleteComment();
                        }
                    );
                    break;
                }
              },
              itemBuilder: (context) {
                var list = List<PopupMenuEntry<Object>>();
                if(currentUser.id_subscriber == comment.subscriber.id_subscriber && currentUser.active == 1) {
                  list.add(
                    PopupMenuItem(
                      child: Text(localization['update']),
                      value: 1,
                      enabled: (currentUser.id_subscriber ==
                          comment.subscriber.id_subscriber &&
                          currentUser.active == 1),
                    ),
                  );
                  list.add(
                    PopupMenuItem(
                      child: Text(localization['delete']),
                      value: 2,
                      enabled: (currentUser.id_subscriber ==
                          comment.subscriber.id_subscriber &&
                          currentUser.active == 1),
                    ),
                  );
                }
                return list;
              },
            ),
          )
        ],
      ),
    );
  }

  deleteComment() {
    progressDialog.show();
    this.comment.deleteComment(context).then((success){
      progressDialog.hide();
      if(success) {
        Toast.show(this.widget.localization['comment_deleted'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        updateDeleleteState();
      }
      else{
        Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
  }

}