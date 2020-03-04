import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../models/constants.dart' as constant;

class AllPosts extends StatefulWidget {

  int activeSubscriber, idSubscriber;

  AllPosts(this.activeSubscriber, this.idSubscriber);

  @override
  _AllPostsState createState() {
    return _AllPostsState(this.activeSubscriber, this.idSubscriber);
  }

}

class _AllPostsState extends State<AllPosts> {

  int activeSubscriber, idSubscriber;

  List<Post> posts = [];
  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true, showAdmobBannerRectangle = false;
  int page = 1;
  AdmobBanner admobBanner;
  FacebookNativeAd facebookNativeAd;

  _AllPostsState(this.activeSubscriber, this.idSubscriber);

  @override
  void initState() {
    super.initState();
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    facebookNativeAd = FacebookNativeAd(
      placementId: constant.FACEBOOK_AD_NATIVE_ID,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        switch (result) {
          case NativeAdResult.ERROR:
            break;
          case NativeAdResult.LOADED:
            break;
          case NativeAdResult.CLICKED:
            break;
          case NativeAdResult.LOGGING_IMPRESSION:
            break;
          case NativeAdResult.MEDIA_DOWNLOADED:
            break;
        }
      },
    );
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
        EmptyData():
        ListView.builder(
          itemCount: posts.length,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                (constant.canShowAds && (index - 1 == 0 || (index - 1) % 10 == 0))?
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: (showAdmobBannerRectangle)? admobBanner : facebookNativeAd,
                ): Container(),
                PostWidget(posts[index]),
              ],
            );
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
      admobBanner = AdmobBanner(
        adUnitId: constant.getAdmobBannerId(),
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        },
      );
      setState(() {
        posts.addAll(postItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

}