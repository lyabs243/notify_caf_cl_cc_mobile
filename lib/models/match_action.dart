import 'package:flutter/material.dart';
import '../services/notify_api.dart';

class MatchAction{

  int id;
  int id_match;
  int type;
  String detail_a;
  String detail_b;
  String detail_c;
  String detail_d;
  int teamA_goal;
  int teamB_goal;
  int minute;
  int id_team;
  int position;

  static final String URL_GET_MATCH_ACTIONS = 'http://notifygroup.org/notifyapp/api/index.php/match/actions/';

  static final int ACTION_POSITION_LEFT = 0;
  static final int ACTION_POSITION_RIGHT = 1;

  static final int MATCH_ACTION_TYPE_KICKOFF = 0;
  static final int MATCH_ACTION_TYPE_GOAL = 1;
  static final int MATCH_ACTION_TYPE_GOAL_PENALTY = 2;
  static final int MATCH_ACTION_TYPE_GOAL_CANCEL = 3;
  static final int MATCH_ACTION_TYPE_PENALTY_MISS = 4;
  static final int MATCH_ACTION_TYPE_HALF_TIME = 5;
  static final int MATCH_ACTION_TYPE_FULL_TIME = 6;
  static final int MATCH_ACTION_TYPE_EXTRA_TIME = 7;
  static final int MATCH_ACTION_TYPE_PENALTY_KICK = 8;
  static final int MATCH_ACTION_TYPE_OFFSIDE = 9;
  static final int MATCH_ACTION_TYPE_CHANGE = 10;
  static final int MATCH_ACTION_TYPE_YELLOW_CARD = 11;
  static final int MATCH_ACTION_TYPE_RED_CARD = 12;

  MatchAction(this.id, this.id_match, this.type, this.detail_a, this.detail_b,
      this.detail_c, this.detail_d, this.teamA_goal, this.teamB_goal,
      this.minute, this.id_team, this.position);

  static Future<List<MatchAction>> getMatchActions(BuildContext context,int idMatch,{minId: 0}) async{
    List<MatchAction> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_MATCH_ACTIONS+idMatch.toString()+'/'+minId.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          int id = int.parse(item['id']);
          int id_match = int.parse(item['id_match']);
          int type = int.parse(item['type']);
          String detail_a = item['detail_a'];
          String detail_b = item['detail_b'];
          String detail_c = item['detail_c'];
          String detail_d = item['detail_d'];
          int teamA_goal = int.parse(item['teamA_goal']);
          int teamB_goal = int.parse(item['teamB_goal']);
          int minute = int.parse(item['minute']);
          int id_team = int.parse(item['id_team']);
          int position = int.parse(item['position']);

          list.add(new MatchAction(id, id_match, type, detail_a, detail_b, detail_c, detail_d, teamA_goal, teamB_goal, minute, id_team, position));
        });
      }
    });
    return list;
  }

}