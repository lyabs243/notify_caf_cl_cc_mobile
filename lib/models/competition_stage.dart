import 'package:flutter/material.dart';
import 'group_stage.dart';
import '../services/notify_api.dart';

class CompetitionStage{

  int id;
  int id_edition;
  String title;
  int type;
  List<GroupStage> groups = [];

  static final int COMPETIONSTAGE_TYPE_GROUP = 1;
  static final int COMPETIONSTAGE_TYPE_NORMAL = 2;

  static final String URL_GET_STAGES = 'http://notifygroup.org/notifyapp/api/index.php/competition/stages_edition/';

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

}