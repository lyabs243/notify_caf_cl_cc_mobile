import 'package:flutter/material.dart';
import '../services/notify_api.dart';

class ScorerEdition{

  int id_player;
  int id_team;
  String name;
  String url_flag;
  String team_name;
  String team_name_small;
  int goals;
  int goalsPenalty;

  static final String URL_GET_SCORERS_EDITION = 'http://notifysport.org/api/v1/index.php/competition/scorers_edition/';

  ScorerEdition(this.id_player, this.id_team, this.name, this.url_flag,
      this.team_name, this.team_name_small, this.goals, this.goalsPenalty);

  static Future<List<ScorerEdition>> getScorers(BuildContext context,int idCompetition,int page) async{
    List<ScorerEdition> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_SCORERS_EDITION+idCompetition.toString()+'/'+page.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          int id_player = int.parse(item['id_player']);
          int id_team = int.parse(item['id_team']);
          String name = item['name'];
          String url_flag = item['url_flag'];
          String team_name = item['team_name'];
          String team_name_small = item['team_name_small'];
          int goals = int.parse(item['goals']);
          int goalsPenalty = int.parse(item['goalsPenalty']);

          list.add(new ScorerEdition(id_player, id_team, name, url_flag, team_name, team_name_small, goals, goalsPenalty));
        });
      }
    });
    return list;
  }


}
