import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class NewsItem {

  int id;
  String url_share;
  String url_article;
  int cat_id;
  String url_fav;
  String news_type;
  String news_heading;
  String news_description;
  int news_video_id;
  String news_video_url;
  DateTime news_date;
  String news_featured_image;
  int total_views;
  int cid;
  String category_name;

  static final String URL_GET_LATEST_NEWS = 'http://notifygroup.org/notifyapp/api/index.php/competition/news/';

  NewsItem(this.id, this.url_share, this.url_article, this.cat_id, this.url_fav,
      this.news_type, this.news_heading, this.news_description,
      this.news_video_id, this.news_video_url, this.news_date,
      this.news_featured_image, this.total_views, this.cid, this.category_name);

  static NewsItem getFromMap(Map item){
    int id = int.parse(item['id']);
    String url_share = item['url_share'];
    String url_article = item['url_article'];
    int cat_id = int.parse(item['cat_id']);
    String url_fav = item['url_fav'];
    String news_type = item['news_type'];
    String news_heading = item['news_heading'];
    String news_description = item['news_description'];
    int news_video_id = int.parse(item['news_video_id']);
    String news_video_url = item['news_video_url'];
    String news_featured_image = item['news_featured_image'];
    int total_views = int.parse(item['total_views']);
    int cid = int.parse(item['cid']);
    String category_name = item['category_name'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime news_date = formater.parse(
        item['news_date']);

    NewsItem newsItem = new NewsItem(id, url_share, url_article, cat_id, url_fav, news_type, news_heading,
        news_description, news_video_id, news_video_url, news_date, news_featured_image, total_views, cid,
        category_name);

    return newsItem;
  }

  static Future getLatestNews(BuildContext context,int idUser, int page, {competitionType: 0}) async {
    List<NewsItem> news = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_LATEST_NEWS + idUser.toString() + '/' + competitionType.toString() + '/' + page.toString()
        , null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          NewsItem newsItem = NewsItem.getFromMap(map['NOTIFYGROUP'][i]);
          news.add(newsItem);
        }
      }
    });
    return news;
  }

}