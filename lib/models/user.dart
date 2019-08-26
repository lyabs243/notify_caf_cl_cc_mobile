import '../services/notify_api.dart';
import 'dart:async';
import '../screens/login/components/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class User{

  int id=0;
  int id_subscriber=0;
  String id_account_user=null;
  String username=null;
  String full_name=null;
  int id_accout_type;
  int active=0;
  int type=0;
  String url_profil_pic=null;

  Function setLoginState;

  static User currentUser;

  static final int GOOGLE_ACCOUNT_ID = 1;
  static final int FACEBOOK_ACCOUNT_ID = 2;
  static final int NOT_CONNECTED_ACCOUNT_ID = -1;

  static final String URL_CONTINUE_WITHOUT_LOGIN = 'http://notifygroup.org/notifyapp/api/index.php/user/add';
  static final String URL_ADD_SUBSCRIBER = 'http://notifygroup.org/notifyapp/api/index.php/subscriber/add';
  static final String URL_BLOCK_SUBSCRIBER = 'http://notifygroup.org/notifyapp/api/index.php/subscriber/block/';
  static final String URL_UNBLOCK_SUBSCRIBER = 'http://notifygroup.org/notifyapp/api/index.php/subscriber/unblock/';

  static final int USER_TYPE_ADMIN = 2;
  static final int USER_TYPE_SIMPLE = 1;

  Future<bool> login(LoginType type,Function setLoginState) async{
    this.setLoginState = setLoginState;
    if(type == LoginType.Nope){
      return continueWithoutLogin();
    }
    else if(type == LoginType.Facebook){
      return facebookLogin();
    }
  }

  Future<bool> continueWithoutLogin() async{
    this.setLoginState(true);
    this.id_accout_type = NOT_CONNECTED_ACCOUNT_ID;
    this.toMap();
    this.setLoginState(false);
    return true;
  }

  Future<bool> facebookLogin() async{
    bool success = true;
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    this.setLoginState(true);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken.token}');
        final profile = json.decode(graphResponse.body);
        this.full_name = profile['name'];
        this.id_account_user = profile['id'];
        this.url_profil_pic = profile["picture"]["data"]["url"];
        this.id_accout_type = FACEBOOK_ACCOUNT_ID;
        Map<String,String> params = {
          'full_name': this.full_name.toString(),
          'url_profil_pic': this.url_profil_pic.toString(),
          'id_account': this.id_account_user.toString(),
          'id_account_type': this.id_accout_type.toString()
        };
        await NotifyApi().getJsonFromServer(URL_ADD_SUBSCRIBER,params).then((map){
          if(map != null && map['NOTIFYGROUP'][0]['success'] == 1) {
            this.id = int.parse(map['NOTIFYGROUP'][0]['id']);
            this.id_subscriber = int.parse(map['NOTIFYGROUP'][0]['id_subscriber']);
            this.active = int.parse(map['NOTIFYGROUP'][0]['active']);
            this.type = int.parse(map['NOTIFYGROUP'][0]['type']);
            this.toMap();
            currentUser = null;
          }
          else{
            success = false;
          }
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        success = false;
        break;
      case FacebookLoginStatus.error:
        success = false;
        print("error -- "+result.errorMessage);
        break;
    }
    this.setLoginState(false);
    return success;
  }

  Future<bool> block(int idSubscriber,Function setBlockingState) async{
    bool success = true;
    setBlockingState(true);
    String url = URL_BLOCK_SUBSCRIBER + this.id_subscriber.toString() + "/" + idSubscriber.toString();
    print(url);
    await NotifyApi().getJsonFromServer(url,null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == '1') {
        this.active = 0;
        this.toMap();
      }
      else{
        success = false;
      }
    });
    setBlockingState(false);
    return success;
  }

  Future<bool> unblock(int idSubscriber,Function setBlockingState) async{
    bool success = true;
    setBlockingState(true);
    String url = URL_UNBLOCK_SUBSCRIBER + this.id_subscriber.toString() + "/" + idSubscriber.toString();
    print(url);
    await NotifyApi().getJsonFromServer(url,null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == '1') {
        this.active = 1;
        this.toMap();
      }
      else{
        success = false;
      }
    });
    setBlockingState(false);
    return success;
  }

  Future toMap() async{
    String map = """{
      "id": ${this.id},
      "id_subscriber": ${this.id_subscriber},
      "username": ${this.username},
      "full_name": "${this.full_name}",
      "id_accout_type": ${this.id_accout_type},
      "id_account_user": "${this.id_account_user}",
      "url_profil_pic": "${this.url_profil_pic}",
      "active": ${this.active},
      "type": ${this.type}
    }""";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', map);
  }

  logout(){
    if(currentUser.id_accout_type == FACEBOOK_ACCOUNT_ID){
      final facebookLogin = FacebookLogin();
      facebookLogin.logOut();
    }
    currentUser.id=0;
    currentUser.id_subscriber=0;
    currentUser.active=0;
    currentUser.type=0;
    currentUser.id_account_user=null;
    currentUser.username=null;
    currentUser.full_name=null;
    currentUser.id_accout_type=null;
    currentUser.url_profil_pic=null;
    currentUser.toMap();
    currentUser = null;
  }

  static Future<User> getInstance() async{
    if(currentUser == null){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userString = sharedPreferences.getString('user');
      if(userString != null) {
        Map userMap = json.decode(userString);
        currentUser = new User();
        currentUser.id = userMap['id'];
        currentUser.id_subscriber = userMap['id_subscriber'];
        currentUser.id_accout_type = userMap['id_accout_type'];
        currentUser.username = userMap['username'];
        currentUser.full_name = userMap['full_name'];
        currentUser.id_account_user = userMap['id_account_user'];
        currentUser.url_profil_pic = userMap['url_profil_pic'];
        currentUser.active = userMap['active'];
        currentUser.type = userMap['type'];
      }
    }
    return currentUser;
  }

}