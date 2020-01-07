import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';

class UserPostHeaderInfos extends StatelessWidget {

  User user, currentUser;
  Map localization;
  DateTime registerDate;

  UserPostHeaderInfos(this.localization, this.user, this.currentUser, this.registerDate);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
        Column(
          children: <Widget>[
            RichText(
              text: new TextSpan(
                text: user.full_name,
                style: new TextStyle(
                    color: Theme.of(context).textTheme.body1.color,fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return new UserProfile(currentUser,user,localization);
                    }));
                  },
              ),
            ),
            Text(convertDateToAbout(registerDate, localization)),
          ],
        )
      ],
    );
  }

}