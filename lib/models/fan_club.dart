import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';
import 'package:intl/intl.dart';

class FanClub {

  int id;
  String title;
  String title_small;
  int is_national_team;
  String country_code;
  String url_logo;
  int category;
  int top_club;
  String color;
  DateTime register_date;

  static final String URL_GET_BADGES = 'http://notifysport.org/api/v1/index.php/fanClub/get_country_clubs/';

  FanClub(this.id, this.title, this.title_small, this.is_national_team,
      this.country_code, this.url_logo, this.category, this.top_club,
      this.color, this.register_date);

  static FanClub getFromMap(Map item){

    int id = int.parse(item['id']);
    String title = item['title'];
    String title_small = item['title_small'];
    int is_national_team = int.parse(item['is_national_team']);
    String country_code = item['country_code'];
    String url_logo = item['url_logo'];
    String color = item['color'];
    int category = int.parse(item['category']);
    int top_club = int.parse(item['top_club']);

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(
        item['register_date']);

    FanClub fanClub = FanClub(id, title, title_small, is_national_team, country_code, url_logo, category, top_club, color, register_date);

    return fanClub;
  }

  static Future getClubs(BuildContext context, String countryCode, int competitionType) async {
    List<FanClub> clubs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_BADGES + countryCode + '/' + competitionType.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            FanClub club = FanClub.getFromMap(map['NOTIFYGROUP']['data'][i]);
            clubs.add(club);
          }
        }
      }
    });
    return clubs;
  }
}