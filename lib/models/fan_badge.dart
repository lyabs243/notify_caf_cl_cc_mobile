import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class FanBadge {

  int id_subscriber;
  int id_team;
  int category;
  String title;
  String country_code;
  String url_logo;
  int top_club;
  String color;

  static final String URL_ADD_BADGE = 'http://notifygroup.org/notifyapp/api/index.php/fanClub/add/';
  static final String URL_DELETE_BADGE = 'http://notifygroup.org/notifyapp/api/index.php/fanClub/delete/';

  FanBadge(this.id_subscriber, this.id_team, this.category, this.title,
      this.country_code, this.url_logo, this.top_club, this.color);

  static FanBadge getFromMap(Map item){

    int id_subscriber = int.parse(item['id_subscriber']);
    int id_team = int.parse(item['id_team']);
    String title = item['title'];
    String country_code = item['country_code'];
    String url_logo = item['url_logo'];
    String color = item['color'];
    int category = int.parse(item['category']);
    int top_club = int.parse(item['top_club']);

    FanBadge fanBadge = FanBadge(id_subscriber, id_team, category, title, country_code, url_logo, top_club, color);

    return fanBadge;
  }

  Future toMap() async{
    String map = """{
      "id_subscriber": ${this.id_subscriber},
      "id_team": ${this.id_team},
      "category": ${this.category},
      "title": "${this.title}",
      "country_code": "${this.country_code}",
      "url_logo": "${this.url_logo}",
      "top_club": ${this.top_club},
      "color": "${this.color}"
    }""";

    return map;
  }

  Future<bool> add(BuildContext context) async{
    bool success = true;
    String url = URL_ADD_BADGE+this.id_subscriber.toString() + '/' + id_team.toString() + '/' + this.category.toString();
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

  Future<bool> delete(BuildContext context) async{
    bool success = true;
    String url = URL_DELETE_BADGE+this.id_subscriber.toString() + '/' + this.category.toString();
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