import 'package:flutter/material.dart';
import '../services/notify_api.dart';

class GroupTableItem{

  int id;
  int id_stage_group;
  int id_team;
  String title;
  String title_small;
  String url_logo;
  int points;
  int matchs_played;
  int win;
  int draw;
  int lose;
  int scored;
  int conceded;
  int goal_difference;

  static final String URL_GET_GROUP_TABLE = 'http://notifysport.org/api/v1/index.php/competition/group_details/';


  GroupTableItem(this.id, this.id_stage_group, this.id_team, this.title,
      this.title_small, this.url_logo, this.points, this.matchs_played,
      this.win, this.draw, this.lose, this.scored, this.conceded,
      this.goal_difference);

  static Future<List<GroupTableItem>> getGroupTable(BuildContext context,int idStageGroup,int idEditionStage) async{
    List<GroupTableItem> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_GROUP_TABLE+idStageGroup.toString()+'/'+idEditionStage.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          int id = int.parse(item['id']);
          int id_stage_group = int.parse(item['id_stage_group']);
          int id_team = int.parse(item['id_team']);
          String title = item['title'];
          String title_small = item['title_small'];
          String url_logo = item['url_logo'];
          int points = item['points'];
          int matchs_played = item['matchs_played'];
          int win = item['win'];
          int draw = item['draw'];
          int lose = item['lose'];
          int scored = item['scored'];
          int conceded = item['conceded'];
          int goal_difference = item['goal_difference'];

          list.add(new GroupTableItem(id, id_stage_group, id_team, title, title_small, url_logo, points, matchs_played, win, draw, lose, scored, conceded, goal_difference));
        });
      }
    });
    return list;
  }

}