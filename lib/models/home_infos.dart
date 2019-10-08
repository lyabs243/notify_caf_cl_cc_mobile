import 'match_item.dart';
import 'competition_item.dart';
import 'package:flutter/material.dart';
import '../services/notify_api.dart';
import 'package:intl/intl.dart';

class HomeInfos{

  static final String URL_GET_HOME_INFOS = 'http://notifygroup.org/notifyapp/api/index.php/competition/home_infos/';

  List<MatchItem> current_match = [];
  List<MatchItem> fixture = [];
  List<MatchItem> latest_result = [];

  Future initData(BuildContext context,int idUser,Function setHomeInfos) async {
    await NotifyApi(context).getJsonFromServer(
        URL_GET_HOME_INFOS + idUser.toString() + '/0/1', null).then((map) {
      if (map != null) {
        for(int i=0;i<map['NOTIFYGROUP']['current_match'].length;i++){
          MatchItem matchItem = MatchItem.getFromMap(map['NOTIFYGROUP']['current_match'][i]);
          this.current_match.add(matchItem);
        }
        setHomeInfos(this);
      }
    });
  }

}