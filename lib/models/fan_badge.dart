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


}