import 'package:flutter/material.dart';
import 'group_stage.dart';
import '../services/notify_api.dart';
import 'match_item.dart';

class CompetitionStage{

  int id;
  int id_edition;
  String title;
  int type;
  List<GroupStage> groups = [];

  static final int COMPETIONSTAGE_TYPE_GROUP = 1;
  static final int COMPETIONSTAGE_TYPE_NORMAL = 2;

  static final String URL_GET_STAGES = 'http://notifysport.org/api/v1/index.php/competition/stages_edition/';
  static final String URL_GET_STAGE_RESULTS = 'http://notifysport.org/api/v1/index.php/competition/stage_result/';
  static final String URL_GET_STAGE_FIXTURE = 'http://notifysport.org/api/v1/index.php/competition/stage_fixture/';

  CompetitionStage(this.id, this.id_edition, this.title, this.type,
      this.groups);

  static Future<List<CompetitionStage>> getCompetitionStages(BuildContext context,int competitionId) async{
    List<CompetitionStage> list = [];

    await NotifyApi(context).getJsonFromServer(URL_GET_STAGES+competitionId.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          int id = int.parse(item['id']);
          int id_edition = int.parse(item['id_edition']);
          String title = item['title'];
          int type = int.parse(item['type']);

          List<GroupStage> groupStages = [];
          item['groups'].forEach((grp){
            int grpId = int.parse(grp['id']);
            int grpIdEditionStage = int.parse(grp['id_edition_stage']);
            String grpTitle = grp['title'];


            GroupStage groupStage = new GroupStage(grpId, grpIdEditionStage, grpTitle);
            groupStages.add(groupStage);
          });

          list.add(new CompetitionStage(id, id_edition, title, type, groupStages));
        });
      }
    });
    return list;
  }

  static Future getStageLatestResults(BuildContext context,int idCompetition, int page, int idEditionStage, int idGroup) async {
    List<MatchItem> matchs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_STAGE_RESULTS + idCompetition.toString() + '/' + idEditionStage.toString() + '/' + idGroup.toString() + '/' +
            page.toString(), null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP'][i]);
          matchs.add(matchItem);
        }
      }
    });
    return matchs;
  }

  static Future getStageFixture(BuildContext context,int idCompetition, int page, int idEditionStage, int idGroup) async {
    List<MatchItem> matchs = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_STAGE_FIXTURE + idCompetition.toString() + '/' + idEditionStage.toString() + '/' + idGroup.toString() + '/' +
            page.toString(), null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP'][i]);
          matchs.add(matchItem);
        }
      }
    });
    return matchs;
  }

}