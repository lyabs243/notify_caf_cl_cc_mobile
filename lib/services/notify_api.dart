import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotifyApi {

  int statusCode;
  Map mapResult;
  BuildContext context;

  NotifyApi(this.context);

  Future<Map> getJsonFromServer(String url, Map params) async {
    Locale myLocale = Localizations.localeOf(context);
    String langCode = myLocale.languageCode;
    String timezone = DateTime.now().timeZoneOffset.toString().substring(0,
        DateTime.now().timeZoneOffset.toString().lastIndexOf(new RegExp(':')));
    timezone = ((timezone.startsWith(new RegExp('-')))? '' : '+') + timezone;
    Map<String,String> map = {
      'access_api': 'sgdhrnt_234lyS__',
      'lang': langCode,
      'version': '1',
      'timezone': timezone
    };
    //print("params -- ${params}");
    if (params != null) {
      map.addAll(params);
    }

    try{
      //final response = await http.post(url,body: map).timeout(Duration(seconds: 15));
      FormData formData = new FormData.fromMap(map);
      final response = await Dio().post(url, data: formData);
      this.statusCode = response.statusCode;
      if (response.statusCode == 200) {
          //print(response.data.toString());
          mapResult = response.data;
          //print(mapResult['NOTIFYGROUP']);
      }
    }
    catch(e){
      //print(e);
    }

    return mapResult;
  }

}