import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:youtube_player/youtube_player.dart';
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
  User currentUser;
  TextEditingController _controller;

  String videoPreview = '', youtubeVideoId = '';

  _YoutubeVideoState(this.localization, this.matchItem);

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    matchVideo = new MatchVideo(matchItem.id);
    User.getInstance().then((_currentUser) {
      currentUser = _currentUser;
      initData();
    });
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  initData() async {
    await Future.delayed(Duration.zero);
    matchVideo.initByIdMatch(context).then((r){
        setState(() {
          videoPreview = matchVideo.thumbnails;
          if(matchVideo.thumbnails.length == 0 && matchVideo.youtube_video.length > 0){
            videoPreview = 'http://i3.ytimg.com/vi/${matchVideo.youtube_video}/hqdefault.jpg';
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            (currentUser != null && currentUser.type == User.USER_TYPE_ADMIN)?
            RaisedButton(
              child: Text(
                localization['add_match_video'],
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 150,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 80 / 100,
                                  child: new TextField(
                                    decoration: new InputDecoration(
                                      hintText: localization['add_youtube_video_id'],
                                    ),
                                    maxLines: 1,
                                    controller: _controller,
                                    maxLength: 100,
                                    onChanged: (val){
                                      setState((){
                                        youtubeVideoId = val;
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text(
                                        localization['add'],
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        if(youtubeVideoId.length > 0) {
                                          addVideo();
                                        }
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text(
                                        localization['cancel'],
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        _controller.clear();
                                        youtubeVideoId = '';
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                              ]
                          ),
                        ),
                      );
                    });
              },
            ): Container(),
            (videoPreview.length == 0)?
            EmptyData(localization) :
            (/*(play && matchVideo.youtube_video.length > 0)?
          YoutubePlayer(
            context: context,
            source: matchVideo.youtube_video,
            autoPlay: false,
            controlsColor: ControlsColor(
              progressBarPlayedColor: Theme.of(context).primaryColor,
              seekBarPlayedColor: Theme.of(context).primaryColor,
            ),
            quality: YoutubeQuality.LOW,
          ) :*/
                new Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(videoPreview),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height /3,
                    child: InkWell(
                      child: Image.asset('assets/play_video.png'),
                      onTap: (){
                        /*setState(() {
                    play = true;
                  });*/
                        launch('https://www.youtube.com/embed/${matchVideo.youtube_video}');
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future addVideo() async{
    ProgressDialog progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: localization['loading'],
    );
    progressDialog.show();
    await this.matchVideo.addVideo(context, youtubeVideoId).then((success) {
      progressDialog.hide();
      if(success) {
        _controller.clear();
        youtubeVideoId = '';
        setState(() {
          this.matchVideo.youtube_video = youtubeVideoId;
        });
        Navigator.pop(context);
      }
      else {
        Toast.show(localization['error_occured'], context, duration: Toast.LENGTH_LONG);
      }
    });
  }

}