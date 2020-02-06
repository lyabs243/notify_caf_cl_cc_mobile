import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/action_comment_dialog.dart';
import 'package:flutter_cafclcc/components/comment_widget.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import '../models/match_item.dart';
import 'empty_data.dart';

class MatchComments extends StatefulWidget{

  MatchItem matchItem;

  MatchComments(this.matchItem);

  @override
  _MatchCommentsState createState() {
    return _MatchCommentsState(this.matchItem);
  }

}

class _MatchCommentsState extends State<MatchComments>{

  MatchItem matchItem;

  List<Comment> comments = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1;

  ProgressDialog progressDialog;
  TextEditingController _controller;
  String commentText;

  User currentUser;

  _MatchCommentsState(this.matchItem);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    _controller = new TextEditingController();
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: MyLocalizations.instanceLocalization['loading']);
    User.getInstance().then((_user){
      setState(() {
        currentUser = _user;
      });
    });
    initItems();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        enablePullUp: (comments.length > 0)? true : false,
        enablePullDown: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        header: (WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
        )   ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else{
              body = Container();
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 80 / 100,
                    child: new TextField(
                      decoration: new InputDecoration(
                        hintText: MyLocalizations.instanceLocalization['type_comment'],
                      ),
                      maxLines: 1,
                      controller: _controller,
                      maxLength: 250,
                      onChanged: (val){
                        setState((){
                          commentText = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 10 / 100,
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 45.0,
                        ),
                        onPressed: () {
                          addComment();
                        }
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: (isLoadPage)?
              Center(
                child: CircularProgressIndicator(),
              ):
              (comments.length <= 0)?
              EmptyData():
              ListView.builder(
                  itemCount: comments.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    User user = new User();
                    user.url_profil_pic = comments[index].subscriber.url_profil_pic;
                    user.id_subscriber = comments[index].subscriber.id_subscriber;
                    user.full_name = comments[index].subscriber.full_name;
                    user.fanBadge = comments[index].subscriber.fanBadge;
                    return Container(
                      child: CommentWidget(comments[index], user, currentUser, deleteComment),
                      margin: EdgeInsets.only(bottom: (index == comments.length-1)?
                      MediaQuery.of(context).size.height / 12 : 0.0),
                    );
                  }
              ),
            )
          ],
        )
    );
  }

  void _onRefresh() async{
    setState(() {
      isPageRefresh = true;
      isLoadPage = true;
    });
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems() async{
    await Future.delayed(Duration.zero);
    page = 1;
    Comment.getMatchComments(context, matchItem.id, page).then((value){
      setState(() {
        comments = value;
        if (comments.length > 0) {
          page++;
        }
        isLoadPage = false;
      });
    });
  }

  Future addItems() async{
    List<Comment> postItems = [];
    postItems = await Comment.getMatchComments(context, matchItem.id, page);
    if(postItems.length > 0){
      setState(() {
        comments.addAll(postItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

  Future addComment() async{
    Comment comment = new Comment(0, this.matchItem.id, null, currentUser.id, commentText, null, null);
    progressDialog.show();
    await comment.addMatchComment(context).then((_comment) {
      if(_comment != null) {
        _controller.clear();
        setState(() {
          isLoadPage = true;
          isPageRefresh = true;
          comments.clear();
          initItems();
        });
      }
      else {
        Toast.show(MyLocalizations.instanceLocalization['error_occured'], context,duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    });
    progressDialog.hide();
  }

  deleteComment() {
    setState(() {
      isPageRefresh = true;
      isLoadPage = true;
      comments.clear();
      initItems();
    });
  }

}