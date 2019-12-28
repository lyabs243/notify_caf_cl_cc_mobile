import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post.dart';
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
    return ModalProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.localization['add_post']),
          actions: <Widget>[
            FlatButton(
              child: Text(
                this.widget.localization['add'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                setState(() {
                  isLoading = true;
                  /*this.widget.appealItem.approveAppeal(this.widget.currentUser.id_subscriber,context).then((success){
                    setState(() {
                      isLoading = false;
                    });
                    if(success) {
                      Toast.show(this.widget.localization['appeal_approved'], context,duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                      Navigator.pop(context, this.widget.appealItem);
                    }
                    else{
                      Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                    }
                  });*/
                });
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
                    maxLength: 1000,
                    onChanged: (val){
                      //appealDescription = val;
                    },
                  ),
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
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ],
              ),
            ),
          ),
        ),
      ),
      opacity: 0.5,
      color: Colors.black,
      inAsyncCall: isLoading,
      dismissible: false,
    );
  }

}