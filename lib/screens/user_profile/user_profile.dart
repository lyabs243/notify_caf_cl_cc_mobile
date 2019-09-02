import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'components/body.dart';

class UserProfile extends StatelessWidget{

  User _currentUser;
  User _user;
  Map _localization;

  UserProfile(this._currentUser,this._user,this._localization);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: new Text(_localization['profil']),
      ),
      body: Body(this._currentUser, _user, _localization),
    );
  }

}