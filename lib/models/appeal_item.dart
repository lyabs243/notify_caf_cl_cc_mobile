

class AppealItem{
  
  int id;
  int id_subscriber;
  bool is_policie_violate;
  bool is_policie_respect_after_activation;
  String full_name;
  String appeal_description;
  bool approve;
  DateTime register_date;
  bool active;

  AppealItem.name(this.id, this.id_subscriber, this.is_policie_violate,
      this.is_policie_respect_after_activation, this.full_name,
      this.appeal_description, this.approve, this.register_date, this.active);


}