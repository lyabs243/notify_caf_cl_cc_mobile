import 'package:flutter/material.dart';
import '../services/notify_api.dart';

class MatchLineup{

  int id_player;
  int id_team;
  String description;
  String name;
  String num_player;

  static final String URL_GET_MATCH_LINEUP = 'http://notifygroup.org/notifyapp/api/index.php/match/lineup/';

  MatchLineup(this.id_player, this.id_team, this.description, this.name,
      this.num_player);

  static Future<List<MatchLineup>> getMatchActions(BuildContext context,int idMatch,int idTeam) async{
    List<MatchLineup> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_MATCH_LINEUP+idMatch.toString()+'/'+idTeam.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          int id_player = int.parse(item['id_player']);
          int id_team = int.parse(item['id_team']);
          String description = item['description'];
          String name = item['name'];
          String num_player = item['num_player'];

          list.add(new MatchLineup(id_player, id_team, description, name, num_player));
        });
      }
    });
    return list;
  }

}