import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/screens/community/components/post_details.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/appeal_item.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import '../../../models/user.dart';
import '../../user_profile/user_profile.dart';
import '../../../models/constants.dart' as constant;

class PostDialog extends StatefulWidget{

  Map localization;
  User currentUser;
  Post post;

  PostDialog(this.localization,this.post,this.currentUser);

  @override
  _PostDialogState createState() {
    return new _PostDialogState();
  }

}

class _PostDialogState extends State<PostDialog>{

  bool isLoading = false;
  File _image;
  String post;
  bool updatePost = false;

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    updatePost = (this.widget.post != null);
    _controller = new TextEditingController(
        text: (updatePost)? this.widget.post.post : ''
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
            (updatePost)?
              this.widget.localization['update_post']:
              this.widget.localization['add_post']
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                (!updatePost)?
                this.widget.localization['add']:
                this.widget.localization['update'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                if(post != null && post.length > 0) {
                setState(() {
                  isLoading = true;
                  if(updatePost) {
                    actionUpdate();
                  }
                  else {
                    actionAdd();
                  }
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
                        labelText: this.widget.localization['post_description'],
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
                        post = val;
                      });
                    },
                  ),
                  (updatePost)?
                  Container():
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(
                                  Icons.add_a_photo
                              ),
                              label: Text(this.widget.localization['add_image'])
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: (_image == null)?
                        Center(
                          child: Text(this.widget.localization['no_image_selected']),
                        ):
                        Image.file(
                          _image,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }

  actionAdd() {
    this.widget.post = new Post(null, this.widget.currentUser.id_subscriber, post, null, null, 1, null,
          null, null, null);
    this.widget.post.addPost(context, _image).then((success){
      setState(() {
        isLoading = false;
      });
      if(success) {
        Toast.show(this.widget.localization['post_added'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.pop(context, this.widget.post);
      }
      else{
        Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
  }

  actionUpdate() {
    this.widget.post.post = post;
    this.widget.post.updatePost(context).then((success){
      setState(() {
        isLoading = false;
      });
      if(success) {
        Toast.show(this.widget.localization['post_updated'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return PostDetails(this.widget.localization, this.widget.post);
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