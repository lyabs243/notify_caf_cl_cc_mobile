import 'package:flutter/material.dart';
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
      actions: <Widget>[
        (!(user != null && user.id_accout_type != User.NOT_CONNECTED_ACCOUNT_ID)) ?
        new FlatButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                return Login();
              }));
            },
            child: Text(localization['login'],style: TextStyle(color: Colors.white),)
        ) :
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
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}