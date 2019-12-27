import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/post_reaction.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class Post {

  int id;
  int id_subscriber;
  String post;
  String url_image;
  User subscriber;
  int active;
  int type;
  DateTime register_date;
  PostReaction reaction;

  static final String URL_GET_POSTS = 'http://notifygroup.org/notifyapp/api/index.php/post/get_posts/';
  static final String URL_GET_POST = 'http://notifygroup.org/notifyapp/api/index.php/post/get_post/';

  Post(this.id, this.id_subscriber, this.post, this.url_image, this.subscriber,
      this.type, this.active, this.register_date, this.reaction);

  static Post getFromMap(Map item){
    int id = int.parse(item['id']);
    int id_subscriber = int.parse(item['id_subscriber']);
    String post_message = item['post'];
    String url_image = item['url_image'];
    int active = int.parse(item['active']);
    int type = int.parse(item['type']);

    User subscriber = new User();
    subscriber.full_name = item['subscriber']['full_name'];
    subscriber.url_profil_pic = item['subscriber']['url_profil_pic'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(
        item['register_date']);

    PostReaction reaction = PostReaction.getFromMap(item['reaction']);

    Post post = Post(id, id_subscriber, post_message, url_image, subscriber, type, active, register_date, reaction);

    return post;
  }

  static Future getPosts(BuildContext context,int activeSubscriber, int page, {idSubscriber: 0}) async {
    List<Post> posts = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_POSTS + activeSubscriber.toString() + '/' + idSubscriber.toString() + '/' + page.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            Post post = Post.getFromMap(map['NOTIFYGROUP']['data'][i]);
            posts.add(post);
          }
        }
      }
    });
    return posts;
  }

  static Future getPost(BuildContext context,int idPost, int activeSubscriber) async {
    Post post;
    await NotifyApi(context).getJsonFromServer(
        URL_GET_POST + idPost.toString() + '/' + activeSubscriber.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
            post = Post.getFromMap(map['NOTIFYGROUP']['data']);
        }
      }
    });
    return post;
  }


}