import 'package:flutter_cafclcc/models/fan_badge.dart';

import '../services/notify_api.dart';
import 'dart:async';
import '../screens/login/components/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

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
  FanBadge fanBadge;

  Function setLoginState;

  static User currentUser;

  static final int GOOGLE_ACCOUNT_ID = 1;
  static final int FACEBOOK_ACCOUNT_ID = 2;
  static final int NOT_CONNECTED_ACCOUNT_ID = -1;

  static final String URL_CONTINUE_WITHOUT_LOGIN = 'http://notifysport.org/api/v1/index.php/user/add';
  static final String URL_ADD_SUBSCRIBER = 'http://notifysport.org/api/v1/index.php/subscriber/add';
  static final String URL_GET_SUBSCRIBER = 'http://notifysport.org/api/v1/index.php/subscriber/get/';
  static final String URL_BLOCK_SUBSCRIBER = 'http://notifysport.org/api/v1/index.php/subscriber/block/';
  static final String URL_UNBLOCK_SUBSCRIBER = 'http://notifysport.org/api/v1/index.php/subscriber/unblock/';

  static final int USER_TYPE_ADMIN = 2;
  static final int USER_TYPE_SIMPLE = 1;

  Future<bool> login(LoginType type,Function setLoginState,BuildContext context) async{
    this.setLoginState = setLoginState;
    if(type == LoginType.Nope){
      return continueWithoutLogin();
    }
    else if(type == LoginType.Google){
      return googleLogin(context);
    }
    else if(type == LoginType.Facebook){
      return facebookLogin(context);
    }
  }

  Future<bool> continueWithoutLogin() async{
    this.setLoginState(true);
    this.id_accout_type = NOT_CONNECTED_ACCOUNT_ID;
    this.toMap();
    this.setLoginState(false);
    return true;
  }

  Future<bool> facebookLogin(BuildContext context) async{
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
        await this.getFieldsFromServer(context).then((_success){
          success = _success;
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

  Future<bool> googleLogin(BuildContext context) async{
    bool success = true;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      final result = await _googleSignIn.signIn();
      this.setLoginState(true);
      this.full_name = result.displayName;
      this.id_account_user = result.id;
      this.url_profil_pic = result.photoUrl;
      this.id_accout_type = GOOGLE_ACCOUNT_ID;
      await this.getFieldsFromServer(context).then((_success){
        success = _success;
      });
    } catch (error) {
      success = false;
      print(error);
    }
    this.setLoginState(false);
    return success;
  }

  Future<bool> getFieldsFromServer(BuildContext context) async{
    bool success = true;
    Map<String,String> params = {
      'full_name': this.full_name.toString(),
      'url_profil_pic': this.url_profil_pic.toString(),
      'id_account': this.id_account_user.toString(),
      'id_account_type': this.id_accout_type.toString()
    };
    await NotifyApi(context).getJsonFromServer(URL_ADD_SUBSCRIBER,params).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'] == 1) {
        this.id = int.parse(map['NOTIFYGROUP'][0]['id'].toString());
        this.id_subscriber = int.parse(map['NOTIFYGROUP'][0]['id_subscriber']);
        this.active = int.parse(map['NOTIFYGROUP'][0]['active']);
        this.type = int.parse(map['NOTIFYGROUP'][0]['type']);
        //get badge
        if(map['NOTIFYGROUP'][0]['badge'] != null) {
          try {
            this.fanBadge = FanBadge.getFromMap(map['NOTIFYGROUP'][0]['badge']);
          }
          catch(e){}
        }
        this.toMap();
      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> getSubscriber(BuildContext context) async{
    bool success = true;
    await NotifyApi(context).getJsonFromServer(URL_GET_SUBSCRIBER+this.id_subscriber.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == 1.toString()) {
        this.id = int.parse(map['NOTIFYGROUP'][0]['id']);
        this.id_subscriber = int.parse(map['NOTIFYGROUP'][0]['id_subscriber']);
        this.active = int.parse(map['NOTIFYGROUP'][0]['active']);
        this.type = int.parse(map['NOTIFYGROUP'][0]['type']);
        this.full_name = map['NOTIFYGROUP'][0]['full_name'];
        this.url_profil_pic = map['NOTIFYGROUP'][0]['url_profil_pic'];
        this.id_accout_type = int.parse(map['NOTIFYGROUP'][0]['id_account_type']);
        this.id_account_user = map['NOTIFYGROUP'][0]['id_account_user'];

        //get badge
        if(map['NOTIFYGROUP'][0]['badge'] != null) {
          try {
            this.fanBadge = FanBadge.getFromMap(map['NOTIFYGROUP'][0]['badge']);
          }
          catch(e){}
        }
      }
      else{
        success = false;
      }
    });
    return success;
  }

  Future<bool> block(User user,Function setBlockingState,BuildContext context) async{
    bool success = true;
    setBlockingState(true);
    String url = URL_BLOCK_SUBSCRIBER + this.id_subscriber.toString() + "/" + user.id_subscriber.toString();
    await NotifyApi(context).getJsonFromServer(url,null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == '1') {
        user.active = 0;
        if(user.id_subscriber == this.id_subscriber) {
          this.active = 0;
          this.toMap();
        }
      }
      else{
        success = false;
      }
    });
    setBlockingState(false);
    return success;
  }

  Future<bool> unblock(User user,Function setBlockingState,BuildContext context) async{
    bool success = true;
    setBlockingState(true);
    String url = URL_UNBLOCK_SUBSCRIBER + this.id_subscriber.toString() + "/" + user.id_subscriber.toString();
    await NotifyApi(context).getJsonFromServer(url,null).then((map){
      if(map != null && map['NOTIFYGROUP'][0]['success'].toString() == '1') {
        user.active = 1;
        if(user.id_subscriber == this.id_subscriber) {
          this.active = 1;
          this.toMap();
        }
      }
      else{
        success = false;
      }
    });
    setBlockingState(false);
    return success;
  }

  Future toMap() async{
    String mapBadge = "{}";
    if(this.fanBadge != null) {
       mapBadge = """
    {
        "id_subscriber": "${this.fanBadge.id_subscriber}",
        "id_team": "${this.fanBadge.id_team}",
        "category": "${this.fanBadge.category}",
        "title": "${this.fanBadge.title}",
        "country_code": "${this.fanBadge.country_code}",
        "url_logo": "${this.fanBadge.url_logo}",
        "top_club": "${this.fanBadge.top_club}",
        "color": "${this.fanBadge.color}"
      }
    """;
    }
    String map = """{
      "id": ${this.id},
      "id_subscriber": ${this.id_subscriber},
      "username": ${this.username},
      "full_name": "${this.full_name}",
      "id_accout_type": ${this.id_accout_type},
      "id_account_user": "${this.id_account_user}",
      "url_profil_pic": "${this.url_profil_pic}",
      "active": ${this.active},
      "type": ${this.type},
      "badge": $mapBadge
    }""";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', map);
  }

  logout(){
    if(currentUser.id_accout_type == FACEBOOK_ACCOUNT_ID){
      final facebookLogin = FacebookLogin();
      facebookLogin.logOut();
    }
    else if(currentUser.id_accout_type == GOOGLE_ACCOUNT_ID){
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      _googleSignIn.signOut();
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
        if(userMap['badge'] != null) {
          try {
            currentUser.fanBadge = FanBadge.getFromMap(userMap['badge']);
          }
          catch(e){}
        }
      }
    }
    return currentUser;
  }

}