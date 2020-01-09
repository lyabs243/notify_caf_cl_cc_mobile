import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'alert_dialog.dart' as alert;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              UserPostHeaderInfos(localization, user, currentUser, comment.register_date),
              PopupMenuButton(
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
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 50.0),
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