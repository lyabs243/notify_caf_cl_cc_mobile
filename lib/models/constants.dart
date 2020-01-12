import 'package:flutter/material.dart';

List<String> languages = ['en', 'fr'];
const LINK_TERMS_USE = 'http://www.notifygroup.org';

/// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String convertDateToAbout(DateTime dateTime,Map localization){

  int sec=0,min=0,hour=0,days=0,months=0,years=0;

  sec = DateTime.now().difference(dateTime).inSeconds;
  String result = '?';
  if(sec >= 0){
    result = localization['about_sec'].toString().replaceAll(new RegExp('{{value}}'), sec.toString()) +
        ((sec > 1)? 's' : '');
    if(sec > 59){
      min = (sec/60).floor();
      result = localization['about_min'].toString().replaceAll(new RegExp('{{value}}'), min.toString()) +
          ((min > 1)? 's' : '');
    }
    if(min > 59){
      hour = (min/60).floor();
      result = localization['about_hour'].toString().replaceAll(new RegExp('{{value}}'), hour.toString()) +
          ((hour > 1)? 's' : '');
    }
    if(hour > 23){
      days = (hour/24).floor();
      result = localization['about_day'].toString().replaceAll(new RegExp('{{value}}'), days.toString()) +
          ((days > 1)? 's' : '');
    }
    if(days > 29){
      months = (days/30).floor();
      result = localization['about_month'].toString().replaceAll(new RegExp('{{value}}'), months.toString()) +
          ((months > 1)? 's' : '');
    }
    if(days>364){
      years = (days/365).floor();
      result = localization['about_year'].toString().replaceAll(new RegExp('{{value}}'), years.toString()) +
          ((years > 1)? 's' : '');
    }
  }
  return result;
}