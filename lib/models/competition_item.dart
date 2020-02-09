import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notify_api.dart';
import 'package:intl/intl.dart';

class CompetitionItem{

  int id, category;
  String title, title_small, description,trophy_icon_url;
  DateTime register_date;

  static final int COMPETITION_TYPE = 1;

  static final String URL_GET_COMPETITION = 'http://notifysport.org/api/v1/index.php/competition/get/';
  static final String URL_GET_COMPETITIONS = 'http://notifysport.org/api/v1/index.php/competition/get_all/'+ COMPETITION_TYPE.toString() + '/';

  CompetitionItem(this.id, this.title, this.title_small, this.description,this.trophy_icon_url,this.category,this.register_date);

  static CompetitionItem getFromMap(Map item){

    int id = int.parse(item['id']);
    String title = item['title'];
    String title_small = item['title_small'];
    String trophy_icon_url = item['trophy_icon_url'];
    String description = item['description'];
    int category = int.parse(item['category']);

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime register_date = formater.parse(item['register_date']);

    CompetitionItem competitionItem = new CompetitionItem(id, title, title_small, description, trophy_icon_url, category, register_date);

    return competitionItem;
  }

  Future<bool> getCompetition(BuildContext context) async{
    bool success = true;
    await NotifyApi(context).getJsonFromServer(URL_GET_COMPETITION+this.id.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == 1.toString()) {
        CompetitionItem competitionItem = CompetitionItem.getFromMap(map['NOTIFYGROUP'][0]['data'][0]);
        this.id = competitionItem.id;
        this.title = competitionItem.title;
        this.title_small = competitionItem.title_small;
        this.trophy_icon_url = competitionItem.trophy_icon_url;
        this.category = competitionItem.category;
        this.description = competitionItem.description;
        this.register_date = competitionItem.register_date;
      }
      else{
        success = false;
      }
    });
    return success;
  }

  static Future<List<CompetitionItem>> getCompetitions(BuildContext context,int page) async{
    List<CompetitionItem> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_COMPETITIONS+page.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP'][0]['data'];
        result.forEach((item){
          CompetitionItem competitionItem = CompetitionItem.getFromMap(item);
          list.add(competitionItem);
        });
      }
    });
    return list;
  }

  static Future<List<CompetitionItem>> getFeaturedCompetitions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<CompetitionItem> list = [];
    String map = sharedPreferences.getString('featured_competition');
    if(map != null) {
      List result = jsonDecode(map);
      result.forEach((item){
        CompetitionItem competitionItem = CompetitionItem.getFromMap(item);
        list.add(competitionItem);
      });
    }
    else { //default competitions
      CompetitionItem champions_league = new CompetitionItem(2, MyLocalizations.instanceLocalization['champions_league'],
          null, '','',1,null);
      CompetitionItem confederation_cup = new CompetitionItem(3, MyLocalizations.instanceLocalization['confederation_cup'],
          null, '','',1,null);

      list.add(champions_league);
      list.add(confederation_cup);
    }

    return list;
  }

  static Future mapCompetitionsFeature(List<CompetitionItem> competitions) async{
    String map = "[";
    for(int i=0; i<competitions.length; i++) {
      map += """{
      "id": "${competitions[i].id}",
      "title": "${competitions[i].title}",
      "title_small": "${competitions[i].title_small}",
      "trophy_icon_url": "${competitions[i].trophy_icon_url}",
      "description": "${competitions[i].description}",
      "category": "${competitions[i].category}",
      "register_date": "${competitions[i].register_date}"
    }""";
      if(i < competitions.length-1) {
        map += ",";
      }
    }
    map += "]";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('featured_competition', map);
  }

}