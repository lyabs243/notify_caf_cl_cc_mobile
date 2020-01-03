import 'dart:io';

import 'package:dio/dio.dart';
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
  static final String URL_ADD_POST = 'http://notifygroup.org/notifyapp/api/index.php/post/add/';
  static final String URL_UPDATE_POST = 'http://notifygroup.org/notifyapp/api/index.php/post/update/';
  static final String URL_DELETE_POST = 'http://notifygroup.org/notifyapp/api/index.php/post/delete/';
  static final String URL_SIGNAL_POST = 'http://notifygroup.org/notifyapp/api/index.php/post/signal/';

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

  Future<bool> addPost(BuildContext context, File image) async{
    bool success = true;
    String url = URL_ADD_POST+this.id_subscriber.toString();
    Map<String,dynamic> params = {
      'post': this.post,
      'type': this.type.toString(),
    };
    if(image != null) {

      params['img_post'] = await MultipartFile.fromFile(image.path);
      url += '/1';
    }
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> updatePost(BuildContext context) async{
    bool success = true;
    String url = URL_UPDATE_POST+this.id.toString() + '/' + this.id_subscriber.toString();
    Map<String,dynamic> params = {
      'post': this.post,
    };
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> deletePost(BuildContext context) async{
    bool success = true;
    String url = URL_DELETE_POST+this.id.toString() + '/' + this.id_subscriber.toString();
    Map<String,dynamic> params = {
      'post': this.post,
    };
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> signalPost(BuildContext context, String message) async{
    bool success = true;
    String url = URL_SIGNAL_POST+this.id.toString() + '/' + this.id_subscriber.toString();
    Map<String,dynamic> params = {
      'message': message,
    };
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }


}