import 'package:flutter_cafclcc/models/post_reaction.dart';
import 'package:flutter_cafclcc/models/user.dart';
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
    subscriber.full_name = item['full_name'];
    subscriber.url_profil_pic = item['url_profil_pic'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(
        item['register_date']);

    PostReaction reaction = PostReaction.getFromMap(item['reaction']);

    Post post = Post(id, id_subscriber, post_message, url_image, subscriber, type, active, register_date, reaction);

    return post;
  }


}