import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/news_item_widget.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/news_item.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/constants.dart' as constant;

class NewsList extends StatefulWidget{

  int idCompetitionType;

  NewsList(this.idCompetitionType);

  @override
  _NewsListState createState() {
    return new _NewsListState(this.idCompetitionType);
  }

}

class _NewsListState extends State<NewsList> {

  RefreshController refreshController;
  bool isPageRefresh = false, isLoadPage = true, isAddingItems = false, showAdmobBanner = false,
      showAdmobBannerLarge = false, isFacebookBannerAdLoaded = false, isFacebookNativeAdLoaded = false;
  int page = 1, idCompetitionType;
  List<NewsItem> news = [];
  User user;
  AdmobBanner admobBanner, admobBannerBottom;
  FacebookBannerAd facebookBannerAd;
  FacebookNativeAd facebookNativeAd;

  _NewsListState(this.idCompetitionType);

  @override
  void initState() {
    super.initState();
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.LARGE_BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    facebookBannerAd = FacebookBannerAd(
      placementId: constant.FACEBOOK_AD_BANNER_ID,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            setState(() {
              showAdmobBanner = true;
            });
            break;
          case BannerAdResult.LOADED:
            setState(() {
              isFacebookBannerAdLoaded = true;
            });
            break;
          case BannerAdResult.CLICKED:
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            break;
        }
      },
    );
    facebookNativeAd = FacebookNativeAd(
      placementId: constant.FACEBOOK_AD_BANNER_NATIVE_ID,
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        switch (result) {
          case NativeAdResult.ERROR:
            setState(() {
              showAdmobBannerLarge = true;
            });
            break;
          case NativeAdResult.LOADED:
            setState(() {
              showAdmobBannerLarge = false;
              isFacebookNativeAdLoaded = true;
            });
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
    admobBannerBottom = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    refreshController = new RefreshController(initialRefresh: false);
    User.getInstance().then((user){
      this.user = user;
      if(this.news.length == 0) {
        initItems();
      }
    });

    //check if facebook ad is loaded, else it will show admob
    Future.delayed(const Duration(milliseconds: 3500), () {
      if(!isFacebookNativeAdLoaded) {
        setState(() {
          showAdmobBannerLarge = true;
        });
      }
      if(!isFacebookBannerAdLoaded) {
        setState(() {
          showAdmobBanner = true;
        });
      }
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
        title: Text('News'),
      ),
      body: SmartRefresher(
          controller: refreshController,
          enablePullUp: (news.length > 0)? true : false,
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
                body =  Container();
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
          (news.length <= 0)?
          EmptyData():
          ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, i) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      (constant.canShowAds && (i - 1 == 0 || (i - 1) % 10 == 0))?
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        child: (showAdmobBannerLarge)? admobBanner : facebookNativeAd,
                      ): Container(),
                      NewsItemWidget(news[i]),
                      (i == news.length - 1 && isAddingItems)?
                      Container(
                        child: Text(
                          MyLocalizations.instanceLocalization['loading'],
                          textScaleFactor: 2.0,
                        ),
                      ): Container(),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: (i == news.length -1)? 20.0 : 0.0),
                );
              }
          )
      ),
        bottomSheet: (constant.canShowAds)?
        Container(
          width: MediaQuery.of(context).size.width,
          child: (showAdmobBanner)? admobBannerBottom : facebookBannerAd,
        ): Container(height: 1.0,)
    );
  }

  void _onRefresh() async{
    setState(() {
      isLoadPage = true;
    });
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems(){
    page = 1;
    NewsItem.getLatestNews(context, this.user.id, page, competitionType: idCompetitionType).then((result){
      initNews(result);
    });
  }

  initNews(List<NewsItem> result){
    if (result.length > 0) {
      setState(() {
        page++;
        news.clear();
        news.addAll(result);
      });
    }
    setState(() {
      isLoadPage = false;
    });
  }

  Future addItems() async{
    setState(() {
      isAddingItems = true;
    });
    List<NewsItem> newsItems = [];
    newsItems = await NewsItem.getLatestNews(context, this.user.id, page, competitionType: idCompetitionType);
    if(newsItems.length > 0){
      admobBanner = AdmobBanner(
        adUnitId: constant.getAdmobBannerId(),
        adSize: AdmobBannerSize.LARGE_BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        },
      );
      setState(() {
        news.addAll(newsItems);
        page++;
      });
    }
    setState(() {
      isAddingItems = false;
    });
    refreshController.loadComplete();
  }

}