import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class PostReport {

  int id;
  int id_post;
  String message;
  int active;
  int id_subscriber;
  DateTime register_date;
  User subscriber;
  Post post;

  static final String URL_GET_POST_REPORTS = 'http://notifygroup.org/notifyapp/api/index.php/post/get_abusive_posts/';

  PostReport(this.id, this.id_post, this.message, this.active,
      this.id_subscriber, this.register_date, this.subscriber, this.post);

  static PostReport getFromMap(Map item){

    int id = int.parse(item['id']);
    int id_subscriber = int.parse(item['id_subscriber']);
    String message = item['message'];
    int active = int.parse(item['active']);
    int id_post = int.parse(item['id_post']);

    User subscriber = new User();
    subscriber.full_name = item['subscriber']['full_name'];
    subscriber.url_profil_pic = item['subscriber']['url_profil'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(
        item['register_date']);

    Post post = Post.getFromMap(item['post']);

    PostReport postReport = new PostReport(id, id_post, message, active, id_subscriber, register_date, subscriber, post);

    return postReport;
  }

  static Future getPostsReported(BuildContext context,int activeSubscriber, int page) async {
    List<PostReport> postsReport = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_POST_REPORTS + activeSubscriber.toString() + '/' + page.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            PostReport postReport = PostReport.getFromMap(map['NOTIFYGROUP']['data'][i]);
            postsReport.add(postReport);
          }
        }
      }
    });
    return postsReport;
  }

}