import '../services/notify_api.dart';
import 'dart:async';
import '../screens/login/components/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User{

  int id=0;
  int id_subscriber=0;
  String id_account_user=null;
  String username=null;
  String full_name=null;
  int id_accout_type;

  static User currentUser;

  static final int GOOGLE_ACCOUNT_ID = 1;
  static final int FACEBOOK_ACCOUNT_ID = 2;
  static final int NOT_CONNECTED_ACCOUNT_ID = -1;

  static final String URL_CONTINUE_WITHOUT_LOGIN = 'http://notifygroup.org/notifyapp/api/index.php/user/add';

  Future<bool> login(LoginType type) async{
    if(type == LoginType.Nope){
      return continueWithoutLogin();
    }
  }

  Future<bool> continueWithoutLogin() async{
    this.id_accout_type = NOT_CONNECTED_ACCOUNT_ID;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', this.toMap());
    return true;
  }

  String toMap(){
    return """{
      "id": ${this.id},
      "id_subscriber": ${this.id_subscriber},
      "username": ${this.username},
      "full_name": ${this.full_name},
      "id_accout_type": ${this.id_accout_type},
      "id_account_user": ${this.id_account_user}
    }""";
  }

  static Future<User> getInstance() async{
    if(currentUser == null){
      currentUser = new User();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userString = sharedPreferences.getString('user');
      if(userString != null) {
        print(userString);
        Map userMap = json.decode(userString);
        currentUser.id = userMap['id'];
        currentUser.id_subscriber = userMap['id_subscriber'];
        currentUser.id_accout_type = userMap['id_accout_type'];
        currentUser.username = userMap['username'];
        currentUser.full_name = userMap['full_name'];
        currentUser.id_account_user = userMap['id_account_user'];
      }
    }
    return currentUser;
  }

}