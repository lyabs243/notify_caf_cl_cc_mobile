import 'package:flutter/cupertino.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class Comment {

  int id;
  int id_match;
  int id_post;
  int id_user;
  String comment;
  User subscriber;
  DateTime register_date;

  static final String URL_GET_MATCH_COMMENTS = 'http://notifygroup.org/notifyapp/api/index.php/match/comments/';
  static final String URL_GET_POST_COMMENTS = 'http://notifygroup.org/notifyapp/api/index.php/post/comments/';
  static final String URL_ADD_POST_COMMENT = 'http://notifygroup.org/notifyapp/api/index.php/post/add_comment/';
  static final String URL_ADD_MATCH_COMMENT = 'http://notifygroup.org/notifyapp/api/index.php/match/add_comment/';
  static final String URL_UPDATE_COMMENT = 'http://notifygroup.org/notifyapp/api/index.php/comment/update/';
  static final String URL_DELETE_COMMENT = 'http://notifygroup.org/notifyapp/api/index.php/comment/delete/';

  Comment(this.id, this.id_match, this.id_post, this.id_user, this.comment, this.subscriber,
      this.register_date);

  static Comment getFromMap(Map item){
    int id = int.parse(item['id']);
    int id_match, id_post;
    if(item['id_match'] != null) {
      id_match = int.parse(item['id_match']);
    }
    else {
      id_post = int.parse(item['id_post']);
    }
    int id_user = int.parse(item['id_user']);
    String comment_message = item['comment'];

    User subscriber = new User();
    subscriber.full_name = item['subscriber']['full_name'];
    subscriber.id_subscriber = int.parse(item['subscriber']['id_subscriber']);
    subscriber.url_profil_pic = item['subscriber']['url_profil_pic'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(
        item['register_date']);

    Comment comment = Comment(id, id_match, id_post, id_user, comment_message, subscriber, register_date);

    return comment;
  }

  static Future getMatchComments(BuildContext context, int id_match, int page) async {
    List<Comment> comments = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_MATCH_COMMENTS + id_match.toString() + '/' + page.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            Comment comment = Comment.getFromMap(map['NOTIFYGROUP']['data'][i]);
            comments.add(comment);
          }
        }
      }
    });
    return comments;
  }

  static Future getPostComments(BuildContext context, int id_post, int page) async {
    List<Comment> comments = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_POST_COMMENTS + id_post.toString() + '/' + page.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            Comment comment = Comment.getFromMap(map['NOTIFYGROUP']['data'][i]);
            comments.add(comment);
          }
        }
      }
    });
    return comments;
  }

  Future<Comment> addPostComment(BuildContext context) async{
    String url = URL_ADD_POST_COMMENT + this.id_user.toString() + "/" + this.id_post.toString();
    Map<String,dynamic> params = {
      'comment': this.comment,
    };
    Comment comment;
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP']['success'] == 1.toString()) {
        comment = Comment.getFromMap(map['NOTIFYGROUP']['data'] );
      }
    });
    return comment;
  }

  Future<Comment> addMatchComment(BuildContext context) async{
    String url = URL_ADD_MATCH_COMMENT + this.id_user.toString() + "/" + this.id_match.toString();
    Map<String,dynamic> params = {
      'comment': this.comment,
    };
    Comment comment;
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP']['success'] == 1.toString()) {
        comment = Comment.getFromMap(map['NOTIFYGROUP']['data'] );
      }
    });
    return comment;
  }

  Future<bool> updateComment(BuildContext context) async{
    bool success = true;
    String url = URL_UPDATE_COMMENT+this.id.toString() + '/' + this.id_user.toString();
    Map<String,dynamic> params = {
      'comment': this.comment,
    };
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP']['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> deleteComment(BuildContext context) async{
    bool success = true;
    String url = URL_DELETE_COMMENT+this.id.toString() + '/' + this.id_user.toString();
    Map<String,dynamic> params = {
    };
    await NotifyApi(context).getJsonFromServer(url,params).then((map){
      if(map != null && map['NOTIFYGROUP']['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

}