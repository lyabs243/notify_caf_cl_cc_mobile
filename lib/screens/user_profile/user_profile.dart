import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import '../../models/user.dart';
import 'components/body.dart';

class UserProfile extends StatelessWidget{

  User _currentUser;
  User _user;

  UserProfile(this._currentUser,this._user);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: new Text(MyLocalizations.instanceLocalization['profil']),
      ),
      body: Body(this._currentUser, _user),
    );
  }

}