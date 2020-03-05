import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/news_item.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/header.dart';
import '../../models/constants.dart';

class NewsDetails extends StatefulWidget {

  NewsItem newsItem;

  NewsDetails(this.newsItem);

  @override
  _NewsDetailsState createState() {
    return _NewsDetailsState(this.newsItem);
  }

}

class _NewsDetailsState extends State<NewsDetails> {

  NewsItem newsItem;
  AdmobBanner admobBanner;
  FacebookBannerAd facebookBannerAd;
  bool showAdmobBanner = false, isFacebookBanerLoaded = false;

  _NewsDetailsState(this.newsItem);

  @override
  void initState() {
    super.initState();
    Admob.initialize(ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );

    facebookBannerAd = FacebookBannerAd(
      placementId: FACEBOOK_AD_BANNER_ID,
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
              isFacebookBanerLoaded = true;
            });
            break;
          case BannerAdResult.CLICKED:
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            break;
        }
      },
    );

    //check if facebook ad is loaded, else it will show admob
    Future.delayed(const Duration(milliseconds: 3500), () {
      if(!isFacebookBanerLoaded) {
        setState(() {
          showAdmobBanner = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User.getInstance().then((user){
      NewsItem.viewNews(context, newsItem.id, user.id);
    });
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBexIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height / 3.45,
              flexibleSpace: FlexibleSpaceBar(
                background: Header(newsItem)
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 8.0),),
                (canShowAds)?
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: (showAdmobBanner)? admobBanner : facebookBannerAd,
                ): Container(),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: <Widget>[
                      ImageIcon(AssetImage('assets/icons/date.png'),size: 15.0, color: Colors.grey[600],),
                      Padding(padding: EdgeInsets.only(left: 2.0,right: 2.0),),
                      new Text(
                        convertDateToAbout(this.newsItem.news_date),
                        style: new TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Text(
                  this.newsItem.news_heading,
                  textScaleFactor: 1.7,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Text(
                  this.newsItem.news_description,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                      color: Colors.grey[600]
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Container(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    child: Text(
                      MyLocalizations.instanceLocalization['read_more'],
                      style: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                    onPressed: () {
                      launch(
                          this.newsItem.url_article,
                          forceWebView: true
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}