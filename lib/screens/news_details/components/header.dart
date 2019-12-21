import 'package:flutter/material.dart';
import '../../../models/news_item.dart';

class Header extends StatefulWidget{

  Map localization;
  NewsItem newsItem;

  Header(this.localization,this.newsItem);

  @override
  _HeaderState createState() {
    return new _HeaderState(localization, newsItem);
  }

}

class _HeaderState extends State<Header>{

  Map localization;
  NewsItem newsItem;

  _HeaderState(this.localization,this.newsItem);

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          width: MediaQuery.of(context).size.width,
          child: (newsItem.news_featured_image.length > 0)?
          Image.network(
            newsItem.news_featured_image,
            fit: BoxFit.cover,
          ):
          Image.asset(
            'assets/icons/latest.png',
            fit: BoxFit.cover,
          ),
        );
  }

}