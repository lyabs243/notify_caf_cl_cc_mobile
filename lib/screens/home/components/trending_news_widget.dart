import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/screens/news_details/news_details.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
import '../../../models/news_item.dart';
import '../../../models/constants.dart';

class TrendingNewsWidget extends StatelessWidget{

  Map localization;
  NewsItem newsItem;

  TrendingNewsWidget(this.localization,this.newsItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Card(
        elevation: 30.0,
        child: Container(
          decoration: new BoxDecoration(
            color: /*const Color(0xff7c94b6)*/Colors.black,
            borderRadius: BorderRadius.circular(5),
            image: new DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: (newsItem.news_featured_image.length > 0) ?
              new NetworkImage(newsItem.news_featured_image) :
              new AssetImage('assets/icons/latest.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                newsItem.news_heading,
                maxLines: 2,
                textScaleFactor: 1.5,
                style: new TextStyle(
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    ImageIcon(AssetImage('assets/icons/date.png'),size: 15.0, color: Colors.white,),
                    Padding(padding: EdgeInsets.only(left: 2.0,right: 2.0),),
                    new Text(
                      convertDateToAbout(newsItem.news_date, localization),
                      maxLines: 1,
                      style: new TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 3.35,
        ),
      ),
      onTap: () {
        PageTransition(context, localization).checkForRateAndShareSuggestion().then((value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context){
                    return NewsDetails(this.localization, newsItem);
                  }
              ));
        });
      },
    );
  }

}