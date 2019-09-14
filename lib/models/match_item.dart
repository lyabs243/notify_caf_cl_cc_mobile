import 'competition_item.dart';

class MatchItem{

  int id, teamAId, teamBId, id_edition_stage, teamA_goal, teamB_goal, team_a_penalty, team_b_penalty, idGroupA, idGroupB;
  String teamA_small, teamB_small, teamA, teamB, teamA_logo, teamB_logo, match_date, status;
  CompetitionItem competition;

  MatchItem(this.id, this.teamAId, this.teamBId, this.id_edition_stage,
      this.teamA_goal, this.teamB_goal, this.team_a_penalty,
      this.team_b_penalty, this.idGroupA, this.idGroupB, this.teamA_small,
      this.teamB_small, this.teamA, this.teamB, this.teamA_logo,
      this.teamB_logo, this.match_date, this.status, this.competition);


}