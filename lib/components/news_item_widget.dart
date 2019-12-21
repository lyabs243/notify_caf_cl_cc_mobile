import 'package:flutter/material.dart';
import '../models/news_item.dart';
import '../models/constants.dart';
import '../screens/news_details/news_details.dart';

class NewsItemWidget extends StatelessWidget {

  NewsItem newsItem;
  Map localization;

  NewsItemWidget(this.localization, this.newsItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 15.0,
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height/7,
                child: (this.newsItem.news_featured_image.length > 0)?
                Image.network(
                  this.newsItem.news_featured_image,
                  fit: BoxFit.cover,
                ):
                Image.asset(
                  'assets/icons/latest.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height/7,
                padding: EdgeInsets.only(left: 7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      this.newsItem.news_heading,
                      maxLines: 2,
                      textScaleFactor: 1.1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      this.newsItem.news_description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.grey[600]
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/icons/date.png'),size: 15.0, color: Colors.grey[600],),
                          Padding(padding: EdgeInsets.only(left: 2.0,right: 2.0),),
                          new Text(
                            convertDateToAbout(this.newsItem.news_date, localization),
                            maxLines: 1,
                            style: new TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context){
                  return NewsDetails(this.localization, newsItem);
                }
            ));
      },
    );
  }

}