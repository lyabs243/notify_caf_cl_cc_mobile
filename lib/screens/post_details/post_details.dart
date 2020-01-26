import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/comment_widget.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import '../../components/alert_dialog.dart' as alert;
import '../../models/constants.dart' as constant;

class PostDetails extends StatefulWidget {

  Map localization;
  Post post;

  PostDetails(this.localization, this.post);

  @override
  _PostDetailsState createState() {
    return _PostDetailsState(this.localization, this.post);
  }

}

class _PostDetailsState extends State<PostDetails> with SingleTickerProviderStateMixin {

  Map localization;
  Post post;
  String commentText;

  List<Comment> comments = [];
  RefreshController refreshController;
  ProgressDialog progressDialog;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1;

  User currentUser;
  TextEditingController _controller;

  AdmobBanner admobBanner;

  _PostDetailsState(this.localization, this.post);

  @override
  void initState() {
    super.initState();
    Admob.initialize(constant.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    refreshController = new RefreshController(initialRefresh: false);
    _controller = new TextEditingController();
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: localization['loading']);
    User.getInstance().then((_user){
      setState(() {
        currentUser = _user;
      });
    });
    initItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localization['post']),
      ),
      body: SmartRefresher(
                  controller: refreshController,
                  enablePullUp: (comments.length > 0)? true : false,
                  enablePullDown: false,
                  onLoading: _onLoading,
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
                  child: ListView.builder(
                      itemCount: comments.length + 2,
                      padding: EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        User user = new User();
                        if(index > 1) {
                          user.id_subscriber =
                              comments[index - 2].subscriber.id_subscriber;
                          user.full_name =
                              comments[index - 2].subscriber.full_name;
                          user.url_profil_pic =
                              comments[index - 2].subscriber.url_profil_pic;
                          user.fanBadge =
                              comments[index - 2].subscriber.fanBadge;
                        }
                        return (index == 0)?
                        Column(
                          children: <Widget>[
                            PostWidget(localization, post, clickable: false, updateView: updateView, showAllText: true, elevation: 0.0,),
                            (constant.canShowAds)?
                            Container(
                              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                              child: admobBanner,
                            ): Container()
                          ],
                        ) :
                        ((index == 1)?
                        Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height / 8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 80 / 100,
                                child: new TextField(
                                  decoration: new InputDecoration(
                                    hintText: localization['type_comment'],
                                  ),
                                  controller: _controller,
                                  maxLines: 1,
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
                        ):
                        CommentWidget(comments[index-2], user, currentUser, localization, deleteComment)
                        );
                      }
                  ),
      )
              );
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

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems() async{
    await Future.delayed(Duration.zero);
    page = 1;
    Comment.getPostComments(context, post.id, page).then((value){
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
    postItems = await Comment.getPostComments(context, post.id, page);
    if(postItems.length > 0){
      setState(() {
        comments.addAll(postItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

  Future addComment() async{
    Comment comment = new Comment(0, null, this.post.id, currentUser.id, commentText, null, null);
    progressDialog.show();
    await comment.addPostComment(context).then((_comment) {
      if(_comment != null) {
        _controller.clear();
        setState(() {
          comments.clear();
          isLoadPage = true;
          initItems();
        });
      }
      else {
        Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
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