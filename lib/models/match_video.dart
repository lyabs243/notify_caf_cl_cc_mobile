import 'package:flutter/material.dart';
import '../services/notify_api.dart';

class MatchVideo{

  int id_match;
  String youtube_video;
  String title;
  String channelTitle;
  String thumbnails;

  static final String URL_GET_MATCH_VIDEO = 'http://notifysport.org/api/v1/index.php/match/video/';
  static final String URL_ADD_MATCH_VIDEO = 'http://notifysport.org/api/v1/index.php/match/add_video/';


  MatchVideo(this.id_match,{this.youtube_video: '', this.title: '', this.channelTitle: '',
      this.thumbnails: ''});

  Future initByIdMatch(BuildContext context) async{
    MatchVideo matchVideo;

    await NotifyApi(context).getJsonFromServer(URL_GET_MATCH_VIDEO+id_match.toString(),null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        List result = map['NOTIFYGROUP']['data'];
        result.forEach((item){
          youtube_video = item['youtube_video'];
          title = item['title'];
          channelTitle = item['channelTitle'];
          thumbnails = item['thumbnails'];
        });
      }
    });
  }

  Future addVideo(BuildContext context, String youtubeId) async{
    bool result = false;
    await NotifyApi(context).getJsonFromServer(URL_ADD_MATCH_VIDEO+id_match.toString()+'/'+youtubeId,null).then((map){
      if(map != null && map['NOTIFYGROUP']['success'].toString() == 1.toString()) {
        result = true;
      }
    });
    return result;
  }

}