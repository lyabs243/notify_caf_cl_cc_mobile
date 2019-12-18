import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';
import '../models/match_item.dart';
import '../models/match_video.dart';
import 'empty_data.dart';

class YoutubeVideo extends StatefulWidget{

  Map localization;
  MatchItem matchItem;

  YoutubeVideo(this.localization, this.matchItem);

  @override
  _YoutubeVideoState createState() {
    return _YoutubeVideoState(this.localization, this.matchItem);
  }

}

class _YoutubeVideoState extends State<YoutubeVideo>{

  bool play = false;
  Map localization;
  MatchItem matchItem;
  MatchVideo matchVideo;

  String videoPreview = '';

  _YoutubeVideoState(this.localization, this.matchItem);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    matchVideo = new MatchVideo(matchItem.id);
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(matchVideo.youtube_video.length == 0){
        matchVideo.initByIdMatch(context).then((r){
          setState(() {
            videoPreview = matchVideo.thumbnails;
            if(matchVideo.thumbnails.length == 0 && matchVideo.youtube_video.length > 0){
              videoPreview = 'http://i3.ytimg.com/vi/${matchVideo.youtube_video}/hqdefault.jpg';
            }
          });
        });
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: (videoPreview.length == 0)?
      EmptyData(localization) :
      ((play && matchVideo.youtube_video.length > 0)?
      YoutubePlayer(
        context: context,
        source: matchVideo.youtube_video,
        autoPlay: true,
        controlsColor: ControlsColor(
          progressBarPlayedColor: Theme.of(context).primaryColor,
          seekBarPlayedColor: Theme.of(context).primaryColor,
        ),
        quality: YoutubeQuality.MEDIUM,
      ) :
      new Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage(videoPreview),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: InkWell(
            child: Image.asset('assets/play_video.png'),
            onTap: (){
              setState(() {
                play = true;
              });
            },
          ),
        ),
      )),
    );
  }

}