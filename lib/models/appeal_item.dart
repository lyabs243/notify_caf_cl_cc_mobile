import '../services/notify_api.dart';
import 'user.dart';
import 'package:intl/intl.dart';

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
  static final String URL_GET_APPEALS = 'http://notifygroup.org/notifyapp/api/index.php/subscriberAppeal/get_appeals/';
  static final String URL_APPROVE_APPEAL = 'http://notifygroup.org/notifyapp/api/index.php/subscriberAppeal/approve_appeal/';

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

  Future<bool> approveAppeal(int id_admin) async{
    bool success = true;
    await NotifyApi().getJsonFromServer(URL_APPROVE_APPEAL+id.toString()+'/'+id_admin.toString()+'/'+
        id_subscriber.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {
        approve = true;
      }
      else{
        success = false;
      }
    });
    return success;
  }

   static Future<List<AppealItem>> getAppeals({page: 1}) async{
    List<AppealItem> items = new List<AppealItem>();
    await NotifyApi().getJsonFromServer(URL_GET_APPEALS+page.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1.toString()) {
        List data = map['NOTIFYGROUP'][0]['data'];
        data.forEach((map){
          int id = int.parse(map['id']);
          int id_subscriber = int.parse(map['id_subscriber']);
          bool is_policie_violate = (int.parse(map['is_policie_violate']) == 1)? true : false;
          bool is_policie_respect_after_activation = (int.parse(map['is_policie_respect_after_activation']) == 1)? true : false;
          String full_name = map['full_name'];
          String appeal_description = map['appeal_description'];
          bool approve = (int.parse(map['approve']) == 1)? true : false;

          String format = 'yyyy-MM-dd H:mm:ss';
          DateFormat formater = DateFormat(format);

          DateTime register_date = formater.parse(map['register_date']);
          bool active = (int.parse(map['active']) == 1)? true : false;

          AppealItem item = new AppealItem(id, id_subscriber, is_policie_violate, is_policie_respect_after_activation,
              full_name, appeal_description, approve, register_date, active);
          items.add(item);
        });
      }
    });
    return items;
  }

}