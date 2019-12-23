import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/screens/community/community.dart';
import '../../../models/user.dart';
import '../../login/login.dart';
import '../../user_profile/user_profile.dart';
import '../../../components/profil_avatar.dart';

class HomeAppBar extends StatelessWidget  with PreferredSizeWidget{

  Map localization;
  User user;

  HomeAppBar(this.user,this.localization);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text(localization['app_title']),
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
            child: Text(localization['login'],style: TextStyle(color: Colors.white),)
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
          tooltip: localization['community'],
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context){
                      return Community(this.localization);
                    }
                ));
          },
        ),
        Padding(padding: EdgeInsets.only(right: 5.0, left: 5.0),),
        new InkWell(
          child: ProfilAvatar(user,width: 40.0,height: 40.0),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute
                  (
                    builder: (BuildContext context){
                      return UserProfile(this.user,this.user,localization);
                    }
                ));
          },
        ),
        Padding(padding: EdgeInsets.only(right: 8.0),),
      ];
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}