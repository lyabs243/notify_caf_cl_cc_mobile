import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/comment.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../components/alert_dialog.dart' as alert;

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

  List<Comment> comments = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1;

  User currentUser;

  _PostDetailsState(this.localization, this.post);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBexIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                Wrap(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: PostWidget(localization, post, clickable: false, updateView: updateView, showAllText: true, elevation: 0.0,)
                    )
                  ],
                ),
                context,
                (post.url_image != null && post.url_image.length > 0)
              ),
              pinned: true,
            )
          ];
        },
        body: new Container(
          height: MediaQuery.of(context).size.height/2.8,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
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
                        maxLines: 1,
                        maxLength: 250,
                        onChanged: (val){
                          setState((){

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

                          }
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SmartRefresher(
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
                      itemCount: comments.length,
                      padding: EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        User user = new User();
                        user.url_profil_pic = comments[index].subscriber.url_profil_pic;
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
                                      Column(
                                        children: <Widget>[
                                          RichText(
                                            text: new TextSpan(
                                              text: comments[index].subscriber.full_name,
                                              style: new TextStyle(
                                                  color: Theme.of(context).textTheme.body1.color,fontSize: 16.0,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              recognizer: new TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                                    user.id_subscriber = comments[index].subscriber.id_subscriber;
                                                    return new UserProfile(currentUser,user,localization);
                                                  }));
                                                },
                                            ),
                                          ),
                                          Text(convertDateToAbout(comments[index].register_date, localization)),
                                        ],
                                      )
                                    ],
                                  ),
                                  PopupMenuButton(
                                    onSelected: (index) {
                                      switch(index) {
                                        case 1: //udate
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                //return PostDialog(localization, post, currentUser);
                                              }
                                          ));
                                          break;
                                        case 2: //delete
                                          alert.showAlertDialog
                                            (
                                              context,
                                              this.widget.localization['warning'],
                                              this.widget.localization['want_delete_post'],
                                              this.widget.localization,
                                                  (){
                                                //deletePost();
                                              }
                                          );
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) {
                                      var list = List<PopupMenuEntry<Object>>();
                                      if(currentUser.id_subscriber == comments[index].subscriber.id_subscriber && currentUser.active == 1) {
                                        list.add(
                                          PopupMenuItem(
                                            child: Text(localization['update']),
                                            value: 1,
                                            enabled: (currentUser.id_subscriber ==
                                                comments[index].subscriber.id_subscriber &&
                                                currentUser.active == 1),
                                          ),
                                        );
                                        list.add(
                                          PopupMenuItem(
                                            child: Text(localization['delete']),
                                            value: 2,
                                            enabled: (currentUser.id_subscriber ==
                                                comments[index].subscriber.id_subscriber &&
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
                                        text: comments[index].comment,
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
                  ),
              )
              )
            ],
          ),
        ),
      ),
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
    postItems = await Comment.getMatchComments(context, post.id, page);
    if(postItems.length > 0){
      setState(() {
        comments.addAll(postItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._wrap, this._context, this._isContainImage);

  final Wrap _wrap;
  BuildContext _context;
  bool _isContainImage = false;

  @override
  double get minExtent => 100.0;
  @override
  double get maxExtent => (_isContainImage)?
  MediaQuery.of(_context).size.height / 1.6
      : MediaQuery.of(_context).size.height / 3.5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: _wrap,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}