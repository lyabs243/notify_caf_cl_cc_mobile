import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/models/post.dart';

class PostDetails extends StatefulWidget {

  Map localization;
  Post post;

  PostDetails(this.localization, this.post);

  @override
  _PostDetailsState createState() {
    return _PostDetailsState(this.localization, this.post);
  }

}

class _PostDetailsState extends State<PostDetails> {

  Map localization;
  Post post;

  _PostDetailsState(this.localization, this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localization['post']),
      ),
      body: Container(
        child: Wrap(
          children: <Widget>[
            PostWidget(localization, post, clickable: false, updateView: updateView, showAllText: true,)
          ],
        ),
      ),
    );;
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  updateView(Post _post) {
    setState(() {
      post = _post;
    });
  }
}