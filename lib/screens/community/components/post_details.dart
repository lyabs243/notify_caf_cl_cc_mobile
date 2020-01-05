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
            PostWidget(localization, post, clickable: false, updateView: updateView, showAllText: true, elevation: 0.0,),
            Container(
              padding: EdgeInsets.all(8.0),
              height: MediaQuery.of(context).size.height / 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.16,
                    child: new TextField(
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: localization['type_comment'],
                      ),
                      maxLines: 1,
                      maxLength: 250,
                      onChanged: (val){
                        setState((){

                        });
                      },
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                        size: 45.0,
                      ),
                      onPressed: () {

                      }
                  )
                ],
              ),
            )
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