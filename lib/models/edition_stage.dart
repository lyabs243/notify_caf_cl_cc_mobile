class EditionStage{

  int id;
  int id_edition;
  String title;
  int type;
  DateTime register_date;

  static final int TYPE_GROUP = 1;
  static final int TYPE_NORMAL = 2;

  EditionStage(this.id, this.id_edition, this.title, this.type,
      this.register_date);

}