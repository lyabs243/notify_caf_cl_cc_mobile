import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/news_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/header.dart';
import '../../models/constants.dart';

class NewsDetails extends StatelessWidget {

  Map localization;
  NewsItem newsItem;

  NewsDetails(this.localization, this.newsItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: MediaQuery.of(context).size.height / 3.45,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: <Widget>[
                  Header(localization, newsItem)
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 8.0),),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/icons/date.png'),size: 15.0, color: Colors.grey[600],),
                          Padding(padding: EdgeInsets.only(left: 2.0,right: 2.0),),
                          new Text(
                            convertDateToAbout(this.newsItem.news_date, localization),
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
                          'Read more',
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
          )
        ],
      ),
    );
  }

}