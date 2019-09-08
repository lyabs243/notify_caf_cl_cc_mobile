import 'package:flutter/material.dart';
import '../services/notify_api.dart';
import 'package:intl/intl.dart';

class CompetitionItem{

  int id;
  String title, title_small, description,trophy_icon_url;
  DateTime register_date;

  static final String URL_GET_COMPETITION = 'http://notifygroup.org/notifyapp/api/index.php/competition/get/';
  static final String URL_GET_COMPETITIONS = 'http://notifygroup.org/notifyapp/api/index.php/competition/get_all/';

  CompetitionItem(this.id, this.title, this.title_small, this.description,this.trophy_icon_url,this.register_date);

  Future<bool> getCompetition(BuildContext context) async{
    bool success = true;
    await NotifyApi(context).getJsonFromServer(URL_GET_COMPETITION+this.id.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == 1.toString()) {
        this.id = int.parse(map['NOTIFYGROUP'][0]['data'][0]['id']);
        this.title = map['NOTIFYGROUP'][0]['data'][0]['title'];
        this.title_small = map['NOTIFYGROUP'][0]['data'][0]['title_small'];
        this.trophy_icon_url = map['NOTIFYGROUP'][0]['data'][0]['trophy_icon_url'];
        this.description = map['NOTIFYGROUP'][0]['data'][0]['description'];

        String format = 'yyyy-MM-dd H:mm:ss';
        DateFormat formater = DateFormat(format);

        this.register_date = formater.parse(map['NOTIFYGROUP'][0]['data'][0]['register_date']);
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
          int id = int.parse(item['id']);
          String title = item['title'];
          String title_small = item['title_small'];
          String trophy_icon_url = item['trophy_icon_url'];
          String description = item['description'];

          String format = 'yyyy-MM-dd H:mm:ss';
          DateFormat formater = DateFormat(format);

          DateTime register_date = formater.parse(item['register_date']);

          list.add(new CompetitionItem(id, title, title_small, description, trophy_icon_url, register_date));
        });
      }
    });
    return list;
  }

}