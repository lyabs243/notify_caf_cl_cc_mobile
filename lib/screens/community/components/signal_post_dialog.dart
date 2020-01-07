import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/screens/post_details/post_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import '../../../models/user.dart';

class SignalPostDialog extends StatefulWidget{

  Map localization;
  User currentUser;
  Post post;

  SignalPostDialog(this.localization,this.post,this.currentUser);

  @override
  _SignalPostDialogState createState() {
    return new _SignalPostDialogState(this.localization,this.post,this.currentUser);
  }

}

class _SignalPostDialogState extends State<SignalPostDialog>{

  bool isLoading = false;
  User currentUser;
  Post post;
  String signalText;
  Map localization;

  TextEditingController _controller;

  _SignalPostDialogState(this.localization,this.post,this.currentUser);

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
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
        title: Text(this.localization['signal_post']),
        actions: <Widget>[
          FlatButton(
            child: Text(
              this.widget.localization['signal'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: (){
              if(signalText != null && signalText.length > 0) {
                setState(() {
                  isLoading = true;
                  signalPost();
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
                      labelText: this.widget.localization['why_signal_post'],
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
                      signalText = val;
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

  signalPost() {
    this.post.signalPost(context, currentUser.id_subscriber, signalText).then((success){
      setState(() {
        isLoading = false;
      });
      if(success) {
        Toast.show(this.widget.localization['post_signaled'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.pop(context, this.widget.post);
      }
      else{
        Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
  }

}