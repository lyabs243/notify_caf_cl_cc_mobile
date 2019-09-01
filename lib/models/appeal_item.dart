import '../services/notify_api.dart';
import 'user.dart';

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

  static final String URL_ADD_APPEAL = 'http://notifygroup.org/notifyapp/api/index.php/subscriberAppeal/add/';

  AppealItem(this.id, this.id_subscriber, this.is_policie_violate,
      this.is_policie_respect_after_activation, this.full_name,
      this.appeal_description, this.approve, this.register_date, this.active);

  Future<bool> addAppeal() async{
    bool success = true;
    Map<String,String> params = {
      'is_policie_violate': this.is_policie_violate? 1.toString() : 0.toString(),
      'is_policie_respect_after_activation': this.is_policie_respect_after_activation? 1.toString() : 0.toString(),
      'appeal_description': this.appeal_description
    };
    await NotifyApi().getJsonFromServer(URL_ADD_APPEAL+id_subscriber.toString(),params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {

      }
      else{
        success = false;
      }
    });
    return success;
  }

}