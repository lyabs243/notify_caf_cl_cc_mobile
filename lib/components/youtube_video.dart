import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:youtube_player/youtube_player.dart';
import '../models/match_item.dart';
import '../models/match_video.dart';
import 'empty_data.dart';
import '../models/constants.dart' as constants;

class YoutubeVideo extends StatefulWidget{

  MatchItem matchItem;

  YoutubeVideo(this.matchItem);

  @override
  _YoutubeVideoState createState() {
    return _YoutubeVideoState(this.matchItem);
  }

}

class _YoutubeVideoState extends State<YoutubeVideo>{

  bool play = false;
  MatchItem matchItem;
  MatchVideo matchVideo;
  User currentUser;
  TextEditingController _controller;
  ProgressDialog progressDialog;

  AdmobReward rewardAd;

  String videoPreview = '', youtubeVideoId = '';

  _YoutubeVideoState(this.matchItem);

  @override
  void initState() {
    super.initState();

    rewardAd = AdmobReward(
        adUnitId: constants.getAdmobRewardId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          progressDialog.hide();
          if (event == AdmobAdEvent.loaded) {
             rewardAd.show();
          }
          else if (event == AdmobAdEvent.closed || event == AdmobAdEvent.failedToLoad) {
            launch('https://www.youtube.com/embed/${matchVideo.youtube_video}');
          }
        });
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
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            (currentUser != null && currentUser.type == User.USER_TYPE_ADMIN)?
            RaisedButton(
              child: Text(
                MyLocalizations.instanceLocalization['add_match_video'],
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
                                      hintText: MyLocalizations.instanceLocalization['add_youtube_video_id'],
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
                                        MyLocalizations.instanceLocalization['add'],
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
                                        MyLocalizations.instanceLocalization['cancel'],
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
            EmptyData() :
            (
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
                      onTap: () async {
                        if(constants.canShowAds) {
                          progressDialog.show();
                          await rewardAd.load();
                        }
                        else {
                          launch('https://www.youtube.com/embed/${matchVideo
                              .youtube_video}');
                        }
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
      message: MyLocalizations.instanceLocalization['loading'],
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
        Toast.show(MyLocalizations.instanceLocalization['error_occured'], context, duration: Toast.LENGTH_LONG);
      }
    });
  }

}