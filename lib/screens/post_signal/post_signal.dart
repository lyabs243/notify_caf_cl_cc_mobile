import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/empty_data.dart';
import 'package:flutter_cafclcc/components/post_widget.dart';
import 'package:flutter_cafclcc/components/profil_avatar.dart';
import 'package:flutter_cafclcc/models/constants.dart';
import 'package:flutter_cafclcc/models/post_report.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/user_profile/user_profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostSignalPage extends StatefulWidget{

  Map localization;

  PostSignalPage(this.localization);

  @override
  _PostSignalPageState createState() {
    return new _PostSignalPageState(this.localization);
  }

}

class _PostSignalPageState extends State<PostSignalPage>{

  RefreshController refreshController;
  Map localization;
  bool isPageRefresh = false, isLoadPage = true;
  int page = 1;
  List<PostReport> postsReport = [];
  User currentUser;
  bool showAllText = false;

  _PostSignalPageState(this.localization);

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController(initialRefresh: false);
    User.getInstance().then((user){
      this.currentUser = user;
      if(this.postsReport.length == 0) {
        initItems();
      }
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localization['post_report']),
      ),
      body: SmartRefresher(
          controller: refreshController,
          enablePullUp: (postsReport.length > 0)? true : false,
          enablePullDown: true,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          header: (WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).primaryColor,
          )   ),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.loading){
                body =  CircularProgressIndicator();
              }
              else{
                body = Container();
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          child: (isLoadPage)?
          Center(
            child: CircularProgressIndicator(),
          ):
          (postsReport.length <= 0)?
          EmptyData(this.widget.localization):
          ListView.builder(
              itemCount: postsReport.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, i) {
                User _user = new User();
                _user.id_subscriber = postsReport[i].id_subscriber;
                _user.url_profil_pic = postsReport[i].subscriber.url_profil_pic;
                return Card(
                    elevation: 15.0,
                    child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ProfilAvatar(_user,width: 45.0,height: 45.0, backgroundColor: Theme.of(context).primaryColor,),
                          Column(
                            children: <Widget>[
                              RichText(
                                text: new TextSpan(
                                  text: postsReport[i].subscriber.full_name,
                                  style: new TextStyle(
                                      color: Theme.of(context).textTheme.body1.color,fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return new UserProfile(currentUser,_user,localization);
                                      }));
                                    },
                                ),
                              ),
                              Text(convertDateToAbout(postsReport[i].register_date, localization)),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: (showAllText)?
                                postsReport[i].message :
                                ((postsReport[i].message.length > 150)?
                                postsReport[i].message.substring(0, 150):
                                postsReport[i].message),
                                style: new TextStyle(color: Theme.of(context).textTheme.body1.color),
                              ),
                              (postsReport[i].message.length > 150 && !showAllText)?
                              new TextSpan(
                                text: '...${localization['see_more']}',
                                style: new TextStyle(color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      showAllText = true;
                                    });
                                  },
                              ):
                              TextSpan(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: PostWidget(localization, postsReport[i].post, clickable: false, elevation: 0.0,),
                        margin: EdgeInsets.only(left: 16.0),
                        decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide (
                                color: Colors.grey[400],
                                width: 4.0,
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                )
                );
              }
          )
      ),
    );
  }

  void _onRefresh() async{
    isPageRefresh = true;
    await initItems();
    refreshController.refreshCompleted();
  }

  void _onLoading() async{
    if(mounted)
      addItems();
  }

  initItems(){
    page = 1;
    PostReport.getPostsReported(context, this.currentUser.id_subscriber, page).then((result){
      initData(result);
    });
  }

  initData(List<PostReport> result){
    if (result.length > 0) {
      setState(() {
        page++;
        postsReport.clear();
        postsReport.addAll(result);
      });
    }
    setState(() {
      isLoadPage = false;
    });
  }

  Future addItems() async{
    List<PostReport> postReportItems = [];
    postReportItems = await PostReport.getPostsReported(context, this.currentUser.id_subscriber, page);
    if(postReportItems.length > 0){
      setState(() {
        postsReport.addAll(postReportItems);
        page++;
      });
    }
    refreshController.loadComplete();
  }

}