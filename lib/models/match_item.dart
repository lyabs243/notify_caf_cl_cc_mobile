import 'competition_item.dart';
import 'package:intl/intl.dart';

class MatchItem{

  int id, teamAId, teamBId, id_edition_stage, teamA_goal, teamB_goal, team_a_penalty, team_b_penalty, idGroupA, idGroupB;
  String teamA_small, teamB_small, teamA, teamB, teamA_logo, teamB_logo, match_date, status;
  CompetitionItem competition;

  MatchItem(this.id, this.teamAId, this.teamBId, this.id_edition_stage,
      this.teamA_goal, this.teamB_goal, this.team_a_penalty,
      this.team_b_penalty, this.idGroupA, this.idGroupB, this.teamA_small,
      this.teamB_small, this.teamA, this.teamB, this.teamA_logo,
      this.teamB_logo, this.match_date, this.status, this.competition);


  static MatchItem getFromMap(Map item){
    int id = int.parse(item['id']);
    int teamAId = int.parse(item['teamAId']);
    int teamBId = int.parse(item['teamBId']);
    int id_edition_stage = int.parse(item['id_edition_stage']);
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
    String match_date = item['match_date'];
    String status = item['status'];

    CompetitionItem competition;
    int cId = int.parse(item['competition']['id']);
    String cTitle = item['competition']['title'];
    String cTitle_small = item['competition']['title_small'];
    String cTrophy_icon_url = item['competition']['trophy_icon_url'];
    int cCategory = item['competition']['category'];
    String cDescription = item['competition']['description'];

    String format = 'yyyy-MM-dd H:mm:ss';
    DateFormat formater = DateFormat(format);

    DateTime cRegister_date = formater.parse(
        item['competition']['register_date']);
    competition = new CompetitionItem(
        cId,
        cTitle,
        cTitle_small,
        cDescription,
        cTrophy_icon_url,
        cCategory,
        cRegister_date);

    MatchItem matchItem = new MatchItem(
        id,
        teamAId,
        teamBId,
        id_edition_stage,
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
        competition);

    return matchItem;
  }

}