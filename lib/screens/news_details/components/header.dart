import 'package:flutter/material.dart';
import '../../../models/news_item.dart';

class Header extends StatefulWidget{

  NewsItem newsItem;

  Header(this.newsItem);

  @override
  _HeaderState createState() {
    return new _HeaderState(newsItem);
  }

}

class _HeaderState extends State<Header>{

  NewsItem newsItem;

  _HeaderState(this.newsItem);

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