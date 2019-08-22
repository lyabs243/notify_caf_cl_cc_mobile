import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'components/body.dart';

class UserProfile extends StatelessWidget{

  User _user;
  Map _localization;

  UserProfile(this._user,this._localization);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: new Text(_localization['profil']),
      ),
      body: Body(_user, _localization),
    );
  }

}