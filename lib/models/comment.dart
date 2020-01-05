import 'package:flutter_cafclcc/models/user.dart';

class Comment {

  int id;
  int id_match;
  int id_post;
  int id_user;
  String comment;
  User subscriber;
  DateTime register_date;

  Comment(this.id, this.id_match, this.id_post, this.id_user, this.comment, this.subscriber,
      this.register_date);

}