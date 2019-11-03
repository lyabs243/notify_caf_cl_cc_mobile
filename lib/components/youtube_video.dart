import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class YoutubeVideo extends StatefulWidget{

  @override
  _YoutubeVideoState createState() {
    return _YoutubeVideoState();
  }

}

class _YoutubeVideoState extends State<YoutubeVideo>{

  bool play = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: (play)?
      YoutubePlayer(
        context: context,
        source: "nPt8bK2gbaU",
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
            image: new NetworkImage('https://pbs.twimg.com/profile_images/939161800037355520/lvGNqhFT_400x400.jpg'),
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
      ),
    );
  }

}