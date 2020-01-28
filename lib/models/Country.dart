import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/services/notify_api.dart';

class Country {

  String nicename;
  String url_flag;
  String country_code;

  static final String URL_GET_COUNTRIES_CLUB = 'http://notifysport.org/api/v1/index.php/fanClub/get_countries/';

  Country(this.nicename, this.url_flag, this.country_code);

  static Country getFromMap(Map item){

    String nicename = item['nicename'];
    String url_flag = item['url_flag'];
    String country_code = item['country_code'];

    Country country = Country(nicename, url_flag, country_code);

    return country;
  }

  static Future getCountriesClub(BuildContext context, int competitionType) async {
    List<Country> countries = [];
    await NotifyApi(context).getJsonFromServer(
        URL_GET_COUNTRIES_CLUB + competitionType.toString()
        , null).then((map) {
      if (map != null) {
        if(map['NOTIFYGROUP']['data'] != null) {
          for (int i = 0; i < map['NOTIFYGROUP']['data'].length; i++) {
            Country country = Country.getFromMap(map['NOTIFYGROUP']['data'][i]);
            countries.add(country);
          }
        }
      }
    });
    return countries;
  }

}