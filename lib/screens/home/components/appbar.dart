import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../login/login.dart';

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
        new Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(top: 9.0,bottom: 9.0, right: 5.0),
          child: (user != null && user.url_profil_pic != null)?
          CircleAvatar(
            radius: 30.0,
            backgroundImage:
            NetworkImage(user.url_profil_pic),
            backgroundColor: Colors.transparent,
          ):
          Image.asset('assets/icons/profile.png'),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}