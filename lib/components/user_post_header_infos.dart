import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/badge_layout.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import '../models/constants.dart' as constants;

class UserPostHeaderInfos extends StatelessWidget {

  User user, currentUser;
  DateTime registerDate;

  UserPostHeaderInfos(this.user, this.currentUser, this.registerDate);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ProfilAvatar(user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
        Column(
          children: <Widget>[
            (user.fanBadge != null)?
            Row(
              children: <Widget>[
                Container(
                  width: 15.0,
                  height: 15.0,
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: Image.network(
                        this.user.fanBadge.url_logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                Text(
                  this.user.fanBadge.title,
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: constants.fromHex(this.user.fanBadge.color),
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ):
            Container(),
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
                      return new UserProfile(currentUser,user);
                    }));
                  },
              ),
            ),
            Text(convertDateToAbout(registerDate)),
          ],
        )
      ],
    );
  }

}