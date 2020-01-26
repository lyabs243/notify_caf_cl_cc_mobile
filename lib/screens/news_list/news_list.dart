import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/news_item_widget.dart';
import 'package:flutter_cafclcc/models/news_item.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/constants.dart' as constant;

class NewsList extends StatefulWidget{

  Map localization;
  int idCompetitionType;

  NewsList(this.localization, this.idCompetitionType);

  @override
  _NewsListState createState() {
    return new _NewsListState(this.localization, this.idCompetitionType);
  }

}

class _NewsListState extends State<NewsList> {

  RefreshController refreshController;
  Map localization;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1, idCompetitionType;
  List<NewsItem> news = [];
  User user;
  AdmobBanner admobBanner;

  _NewsListState(this.localization, this.idCompetitionType);

  @override
  void initState() {
    super.initState();
    Admob.initialize(constant.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constant.getAdmobBannerId(),
      adSize: AdmobBannerSize.LARGE_BANNER,
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
          (news.length <= 0)?
          EmptyData(this.widget.localization):
          ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    (constant.canShowAds && (i - 1 == 0 || (i - 1) % 10 == 0))?
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: admobBanner,
                    ): Container(),
                    NewsItemWidget(this.widget.localization, news[i])
                  ],
                );
              }
          )
      ),
    );
  }

  void _onRefresh() async{
    isPageRefresh = true;
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
    refreshController.loadComplete();
  }

}