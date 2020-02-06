import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class CommentDialog extends StatefulWidget{

  User currentUser;
  Comment comment;

  CommentDialog(this.comment,this.currentUser);

  @override
  _CommentDialogState createState() {
    return new _CommentDialogState(this.comment);
  }

}

class _CommentDialogState extends State<CommentDialog>{

  bool isLoading = false;
  String commentText;
  Comment comment;

  TextEditingController _controller;
  bool itUpdate = false;

  _CommentDialogState(this.comment);

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(
        text: this.comment.comment
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              MyLocalizations.instanceLocalization['update_comment']
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                MyLocalizations.instanceLocalization['update'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                if(commentText != null && commentText.length > 0) {
                setState(() {
                  isLoading = true;
                  actionUpdate();
                });
                }
              },
            ),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.5,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(bottom: 30.0),),
                  TextField(
                    decoration: new InputDecoration(
                        labelText: MyLocalizations.instanceLocalization['comment_description'],
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.8, //width of the border
                            ),
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        alignLabelWithHint: true
                    ),
                    maxLines: 10,
                    controller: _controller,
                    maxLength: 1000,
                    onChanged: (val){
                      setState((){
                        commentText = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  actionUpdate() {
    this.widget.comment.comment = commentText;
    this.widget.comment.updateComment(context).then((success){
      setState(() {
        isLoading = false;
        itUpdate = success;
      });
      if(success) {
        Toast.show(MyLocalizations.instanceLocalization['comment_updated'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.pop(context, commentText);
      }
      else {
        Toast.show(MyLocalizations.instanceLocalization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
  }

}