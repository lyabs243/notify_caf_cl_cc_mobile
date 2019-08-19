import 'dart:convert';
import 'package:http/http.dart' as http;

class NotifyApi {

  int statusCode;
  Map mapResult;

  Future<Map> getJsonFromServer(String url, Map params) async {

    Map<String,String> map = {
      'access_api': 'sgdhrnt_234lyS__',
      'lang': 'en',
      'version': '1',
      'timezone': '+00:00'
    };
    //print("params -- ${params}");
    if (params != null) {
      map.addAll(params);
    }

    final response = await http.post(url,body: map);
    this.statusCode = response.statusCode;
    if (response.statusCode == 200) {
      mapResult = json.decode(response.body);
    }

    //print(mapResult['NOTIFYGROUP']);

    return mapResult;
  }

}