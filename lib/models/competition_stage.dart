import 'group_stage.dart';

class CompetitionStage{

  int id;
  int id_edition;
  String title;
  int type;
  List<GroupStage> groups = [];

  static final int COMPETIONSTAGE_TYPE_GROUP = 1;
  static final int COMPETIONSTAGE_TYPE_NORMAL = 2;

  CompetitionStage(this.id, this.id_edition, this.title, this.type,
      this.groups);

}