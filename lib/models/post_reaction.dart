import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';

class PostReaction {

  int id_post;
  int total;
  int subscriber_reaction;
  List<int> top_reactions = [];

  static final int REACTION_LIKE = 1;
  static final int REACTION_LOVE = 2;
  static final int REACTION_REDCARD = 3;
  static final int REACTION_GOAL = 4;
  static final int REACTION_OFFSIDE = 5;
  static final int REACTION_ANGRY = 6;

  static final String URL_ADD_POSTREACTION = 'http://notifygroup.org/notifyapp/api/index.php/postReaction/add/';

  PostReaction(this.id_post, this.total, this.subscriber_reaction,
      this.top_reactions);

  static PostReaction getFromMap(Map item){
    int id_post = int.parse(item['id_post']);
    int total = int.parse(item['total']);
    int subscriber_reaction = int.parse(item['subscriber_reaction']);
    List<int> top_reactions = [];

    item['top_reactions'].forEach((result){

      int reaction_type = int.parse(result['reaction_type']);
      top_reactions.add(reaction_type);

    });

    PostReaction postReaction = new PostReaction(id_post, total, subscriber_reaction,
        top_reactions);

    return postReaction;
  }

  static Future<bool> add(int id_post, int id_subscriber, int reaction,BuildContext context) async{
    String url = URL_ADD_POSTREACTION + id_post.toString() + "/" + id_subscriber.toString() + '/'
        + reaction.toString();
    bool success = true;
    await NotifyApi(context).getJsonFromServer(url,null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == '1') {
        success = true;
      }
      else{
        success = false;
      }
    });
    return success;
  }

  static String getReactionIconPath(int reaction) {
    if(reaction == REACTION_LIKE) {
      return 'assets/icons/reaction/like.png';
    }
    else if(reaction == REACTION_LOVE) {
      return 'assets/icons/reaction/love.png';
    }
    else if(reaction == REACTION_GOAL) {
      return 'assets/icons/reaction/goal.png';
    }
    else if(reaction == REACTION_OFFSIDE) {
      return 'assets/icons/reaction/offside.jpg';
    }
    else if(reaction == REACTION_REDCARD) {
      return 'assets/icons/reaction/red_card.png';
    }
    else if(reaction == REACTION_ANGRY) {
      return 'assets/icons/reaction/angry.png';
    }
    else {
      return 'assets/icons/reaction/like_empty.png';
    }
  }

  static Color getReactionColor(int reaction, BuildContext context) {
    if(reaction == REACTION_LIKE) {
      return Colors.blue;
    }
    else if(reaction == REACTION_LOVE) {
      return Colors.red;
    }
    else if(reaction == REACTION_GOAL) {
      return Colors.black;
    }
    else if(reaction == REACTION_OFFSIDE) {
      return Colors.orange;
    }
    else if(reaction == REACTION_REDCARD) {
      return Colors.red;
    }
    else if(reaction == REACTION_ANGRY) {
      return Colors.red[900];
    }
    else {
      return Theme.of(context).textTheme.body1.color;
    }
  }

  static String getReactionText(int reaction, Map localization) {
    if(reaction == REACTION_LIKE) {
      return localization['like'];
    }
    else if(reaction == REACTION_LOVE) {
      return localization['love'];
    }
    else if(reaction == REACTION_GOAL) {
      return localization['goal'];
    }
    else if(reaction == REACTION_OFFSIDE) {
      return localization['offside'];
    }
    else if(reaction == REACTION_REDCARD) {
      return localization['red_card'];
    }
    else if(reaction == REACTION_ANGRY) {
      return localization['angry'];
    }
    else {
      return localization['like'];
    }
  }


}