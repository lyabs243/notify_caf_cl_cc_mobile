import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/screens/community/community.dart';
import 'package:flutter_cafclcc/services/page_transition.dart';
import '../../../models/user.dart';
import '../../login/login.dart';
import '../../user_profile/user_profile.dart';
import '../../../components/profil_avatar.dart';

class HomeAppBar extends StatelessWidget  with PreferredSizeWidget{

  User user;

  HomeAppBar(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text(MyLocalizations.instanceLocalization['app_title']),
      actions: appbarIcons(context)
    );
  }
  
  List<Widget> appbarIcons(BuildContext context) {
    if(!(user != null && user.id_accout_type != User.NOT_CONNECTED_ACCOUNT_ID)) {
      return [
        new FlatButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                return Login();
              }));
            },
            child: Text(MyLocalizations.instanceLocalization['login'],style: TextStyle(color: Colors.white),)
        )
      ];
    }
    else {
      return [
        IconButton(
          icon: Icon(
            Icons.group,
            size: 40.0,
          ),
          tooltip: MyLocalizations.instanceLocalization['community'],
          onPressed: () {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context){
                  return Community();
                }
            );
            PageTransition(context, materialPageRoute, false).checkForRateAndShareSuggestion();
          },
        ),
        Padding(padding: EdgeInsets.only(right: 5.0, left: 5.0),),
        new InkWell(
          child: ProfilAvatar(user,width: 40.0,height: 40.0),
          onTap: (){
            MaterialPageRoute materialPageRoute = MaterialPageRoute
              (
                builder: (BuildContext context){
                  return UserProfile(this.user,this.user);
                }
            );
            PageTransition(context, materialPageRoute, false).checkForRateAndShareSuggestion();
          },
        ),
        Padding(padding: EdgeInsets.only(right: 8.0),),
      ];
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}