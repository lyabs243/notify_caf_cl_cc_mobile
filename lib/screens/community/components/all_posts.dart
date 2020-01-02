import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllPosts extends StatefulWidget {

  Map localization;
  int activeSubscriber, idSubscriber;

  AllPosts(this.localization, this.activeSubscriber, this.idSubscriber);

  @override
  _AllPostsState createState() {
    return _AllPostsState(this.localization, this.activeSubscriber, this.idSubscriber);
  }

}

class _AllPostsState extends State<AllPosts> {

  Map localization;
  int activeSubscriber, idSubscriber;

  List<Post> posts = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1;

  _AllPostsState(this.localization, this.activeSubscriber, this.idSubscriber);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    if(this.posts.length == 0) {
      initItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        enablePullUp: (posts.length > 0)? true : false,
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
        child: (isLoadPage)?
        Center(
          child: CircularProgressIndicator(),
        ):
        (posts.length <= 0)?
        EmptyData(this.widget.localization):
        ListView.builder(
          itemCount: posts.length,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return PostWidget(localization, posts[index]);
          }
      ));
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
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
    Post.getPosts(context, activeSubscriber, page, idSubscriber: idSubscriber).then((value){
      setState(() {
        posts = value;
        if (posts.length > 0) {
          page++;
        }
        isLoadPage = false;
      });
    });
  }

  Future addItems() async{
    List<Post> postItems = [];
    postItems = await Post.getPosts(context, activeSubscriber, page, idSubscriber: idSubscriber);
    if(postItems.length > 0){
      setState(() {
        posts.addAll(postItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

}