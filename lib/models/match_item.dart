import 'package:flutter/material.dart';
import 'competition_item.dart';
import 'edition_stage.dart';
import 'package:intl/intl.dart';
import '../services/notify_api.dart';

class MatchItem{

  static final String URL_GET_CURRENT_MATCHS = 'http://notifygroup.org/notifyapp/api/index.php/competition/current_matchs/';
  static final String URL_GET_FIXTURE_MATCHS = 'http://notifygroup.org/notifyapp/api/index.php/competition/fixture/';
  static final String URL_GET_LATEST_RESULTS = 'http://notifygroup.org/notifyapp/api/index.php/competition/latest_results/';
  static final String URL_GET_MATCH = 'http://notifygroup.org/notifyapp/api/index.php/match/get/';

  static final String MATCH_STATUS_TYPE_PENDING = "0";
  static final String MATCH_STATUS_TYPE_IN_PROGRESS = "1";
  static final String MATCH_STATUS_TYPE_HALFTIME = "2";
  static final String MATCH_STATUS_TYPE_FULLTIME = "3";
  static final String MATCH_STATUS_TYPE_EXTRATIME = "4";
  static final String MATCH_STATUS_TYPE_PENALTYKICK = "5";
  static final String MATCH_STATUS_TYPE_REPORT = "6";
  static final String MATCH_STATUS_TYPE_START_SECONDHALF = "7";
  static final String MATCH_STATUS_TYPE_START_EXTRATIME = "8";
  static final String MATCH_STATUS_TYPE_HALF_EXTRATIME = "9";
  static final String MATCH_STATUS_TYPE_START_SECONDEXTRA = "10";
  static final String MATCH_STATUS_TYPE_ENDEXTRATIME = "11";
  static final String MATCH_STATUS_TYPE_LINEUP_AVAILABLE = "-10";
  static final String MATCH_STATUS_TYPE_VIDEO_AVAILABLE = "-11";

  int id, teamAId, teamBId, teamA_goal, teamB_goal, team_a_penalty, team_b_penalty, idGroupA, idGroupB;
  String teamA_small, teamB_small, teamA, teamB, teamA_logo, teamB_logo, match_status, status;
  DateTime match_date;
  CompetitionItem competition;
  EditionStage editionStage;

  MatchItem(this.id, this.teamAId, this.teamBId,
      this.teamA_goal, this.teamB_goal, this.team_a_penalty,
      this.team_b_penalty, this.idGroupA, this.idGroupB, this.teamA_small,
      this.teamB_small, this.teamA, this.teamB, this.teamA_logo,
      this.teamB_logo, this.match_date, this.status, this.competition,this.editionStage, this.match_status);

  static Future getCurrentMatchs(BuildContext context,int idCompetition, int page, {competitionType: 0}) async {
    List<MatchItem> matchs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_CURRENT_MATCHS + idCompetition.toString() + '/' + page.toString() + '/' + competitionType.toString()
        , null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP'][i]);
          matchs.add(matchItem);
        }
      }
    });
    return matchs;
  }

  static Future get(BuildContext context,int idMatch) async {
    MatchItem match;
    await NotifyApi(context).getJsonFromServer(
        URL_GET_MATCH + idMatch.toString()
        , null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP']['data'].length;i++){
          match = MatchItem.getFromMap(map['NOTIFYGROUP']['data'][i]);
        }
      }
    });
    return match;
  }

  static Future getFixtureMatchs(BuildContext context,int idCompetition, int page, {competitionType: 0}) async {
    List<MatchItem> matchs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_FIXTURE_MATCHS + idCompetition.toString() + '/' + page.toString() + '/' + competitionType.toString()
        , null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP'][i]);
          matchs.add(matchItem);
        }
      }
    });
    return matchs;
  }

  static Future getLatestResults(BuildContext context,int idCompetition, int page, {competitionType: 0}) async {
    List<MatchItem> matchs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_LATEST_RESULTS + idCompetition.toString() + '/' + page.toString() + '/' + competitionType.toString()
        , null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP'][i]);
          matchs.add(matchItem);
        }
      }
    });
    return matchs;
  }

  static MatchItem getFromMap(Map item){
    int id = int.parse(item['id']);
    int teamAId = int.parse(item['teamAId']);
    int teamBId = int.parse(item['teamBId']);
    int teamA_goal = int.parse(item['teamA_goal']);
    int teamB_goal = int.parse(item['teamB_goal']);
    int team_a_penalty = int.parse(item['team_a_penalty']);
    int team_b_penalty = int.parse(item['team_b_penalty']);
    int idGroupA = (item['idGroupA'] != null)? int.parse(item['idGroupA']) : 0;
    int idGroupB = (item['idGroupB'] != null)? int.parse(item['idGroupB']) : 0;
    String teamA_small = item['teamA_small'];
    String teamB_small = item['teamB_small'];
    String teamA = item['teamA'];
    String teamB = item['teamB'];
    String teamA_logo = item['teamA_logo'];
    String teamB_logo = item['teamB_logo'];
    String match_status = item['match_status'];
    String status = item['status'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime match_date = formater.parse(
        item['match_date']);

    EditionStage editionStage;
    int esId = int.parse(item['edition_stage']['id']);
    int esId_edition = int.parse(item['edition_stage']['id_edition']);
    String esTitle = item['edition_stage']['title'];
    int esType = int.parse(item['edition_stage']['type']);

    CompetitionItem competition;
    int cId = int.parse(item['competition']['id']);
    String cTitle = item['competition']['title'];
    String cTitle_small = item['competition']['title_small'];
    String cTrophy_icon_url = item['competition']['trophy_icon_url'];
    int cCategory = item['competition']['category'];
    String cDescription = item['competition']['description'];

    DateTime cRegister_date = formater.parse(
        item['competition']['register_date']);

    DateTime esRegister_date = formater.parse(
        item['edition_stage']['register_date']);

    competition = new CompetitionItem(
        cId,
        cTitle,
        cTitle_small,
        cDescription,
        cTrophy_icon_url,
        cCategory,
        cRegister_date);

    editionStage = new EditionStage(
        esId,
        esId_edition,
        esTitle,
        esType,
        esRegister_date);

    MatchItem matchItem = new MatchItem(
        id,
        teamAId,
        teamBId,
        teamA_goal,
        teamB_goal,
        team_a_penalty,
        team_b_penalty,
        idGroupA,
        idGroupB,
        teamA_small,
        teamB_small,
        teamA,
        teamB,
        teamA_logo,
        teamB_logo,
        match_date,
        status,
        competition,
        editionStage,
        match_status);

    return matchItem;
  }

}