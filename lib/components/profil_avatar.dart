import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfilAvatar extends StatelessWidget{

  User user;
  double width;
  double height;

  ProfilAvatar(this.user,{this.width: 40.0,this.height: 40.0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 9.0,bottom: 9.0, right: 5.0),
      child: (user != null && user.url_profil_pic != null)?
      CircleAvatar(
        radius: 30.0,
        child: ClipOval(
          child: Image.network(
            user.url_profil_pic,
          ),
        ),
        backgroundImage: AssetImage('assets/icons/profile.png'),
        backgroundColor: Colors.transparent,
      ):
      Image.asset('assets/icons/profile.png'),
    );
  }

}