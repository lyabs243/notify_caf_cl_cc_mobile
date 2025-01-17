import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/screens/settings/settings.dart';
import 'package:flutter_cafclcc/screens/user_profile/components/user_badge.dart';
import '../../../models/user.dart';
import '../../../components/profil_avatar.dart';
import '../../../models/drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../screens/login/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'add_appeal.dart';
import '../../../models/constants.dart' as constants;
import '../../../components/alert_dialog.dart' as alert;
import '../../../components/empty_data.dart';

class Body extends StatefulWidget{

  User _user;
  User _currentUser;

  Body(this._currentUser,this._user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BodyState();
  }

}

class _BodyState extends State<Body>{

  List<DrawerItem> _drawerItems;
  BuildContext _context;
  bool isPageLoading = true;
  bool isLoading = false, showAdmobBanner = false, isFacebookBannerLoaded = false;

  bool isCurrentUser = false;

  AdmobBanner admobBanner;
  FacebookBannerAd facebookBannerAd;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    Admob.initialize(constants.ADMOB_APP_ID);
    admobBanner = AdmobBanner(
      adUnitId: constants.getAdmobBannerId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      },
    );
    facebookBannerAd = FacebookBannerAd(
      placementId: constants.FACEBOOK_AD_BANNER_ID,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            setState(() {
              showAdmobBanner = true;
            });
            break;
          case BannerAdResult.LOADED:
            setState(() {
              isFacebookBannerLoaded = true;
            });
            break;
          case BannerAdResult.CLICKED:
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            break;
        }
      },
    );
    initData();

    //check if facebook ad is loaded, else it will show admob
    Future.delayed(const Duration(milliseconds: 3500), () {
      if(!isFacebookBannerLoaded) {
        setState(() {
          showAdmobBanner = true;
        });
      }
    });
  }

  initData() async {
    await Future.delayed(Duration.zero);
    _context = context;
    initSubscriber();
    _drawerItems = new List<DrawerItem>();
  }

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      child:  (isPageLoading)?
      Center(
        child: CircularProgressIndicator(),
      ):
      (widget._user.full_name == null)?
      EmptyData():
      ListView.builder(
        itemBuilder: ((context,i){
          if(i == 0){
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      ProfilAvatar(this.widget._user,width: 80.0,height: 80.0),
                      new Text(
                        this.widget._user.full_name,
                        textScaleFactor: 1.8,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      (isCurrentUser)?
                      new Text(
                        (this.widget._user.id_accout_type == User.FACEBOOK_ACCOUNT_ID)?
                        MyLocalizations.instanceLocalization['connected_with_facebook']:
                        MyLocalizations.instanceLocalization['connected_with_google'],
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic
                        ),
                      ):
                      Container()
                    ],
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: new DecorationImage(
                      image: new AssetImage('assets/bg_cat.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                (this.widget._user.active == 1 || !isCurrentUser)?
                Center():
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Text(
                          MyLocalizations.instanceLocalization['account_been_blocked'],
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        width: MediaQuery.of(context).size.width/1.4,
                      ),
                      OutlineButton(
                        child: Container(
                          width: MediaQuery.of(context).size.width/6,
                          child: Text(
                            MyLocalizations.instanceLocalization['appeal'],
                            style: TextStyle(
                                color: Colors.white
                            ),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context){
                                return Appeal();
                              },
                          fullscreenDialog: true
                          ));
                        },
                        borderSide: BorderSide(
                          color: Colors.white, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 0.8, //width of the border
                        ),
                      )
                    ],
                  ),
                ),
                UserBadge(this.widget._user, this.widget._currentUser, deleteBadge),
                (constants.canShowAds)?
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: (showAdmobBanner)? admobBanner : facebookBannerAd,
                ): Container()
              ],
            );
          }
          else if(!_drawerItems[i].visible){
            return Container();
          }
          else{
            return new ListTile(
              title: Text(
                _drawerItems[i].title,
                textScaleFactor: 1.2,
                style: TextStyle(
                    color: Theme.of(context).textTheme.body1.color
                ),
              ),
              onTap: (){
                onDrawerItemSelected(i);
              },
              leading: (_drawerItems[i].iconPath != null) ?
              ImageIcon(AssetImage(_drawerItems[i].iconPath),color: Theme.of(context).primaryColor) :
              null,
            );
          }
        }),
        itemCount: _drawerItems.length,
      ),
      inAsyncCall: isLoading,
      dismissible: false,
      color: Colors.black,
      opacity: 0.5,
    );
  }

  initSubscriber() async{
    await Future.delayed(Duration.zero);
    this.widget._user.getSubscriber(_context).then((success){
      setState(() {
        isPageLoading = false;
      });
      initDrawerItems();
      if(success){
          this.widget._currentUser.getFieldsFromServer(_context).then((value) {
            setState(() {
              isCurrentUser = (this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber);
              isPageLoading = false;
            });
          });
      }
    });
    if(this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber) {
      this.widget._currentUser.getFieldsFromServer(_context).then((value) {
        setState(() {
          widget._user = null;
          widget._user = widget._currentUser;
          isCurrentUser = true;
          isPageLoading = false;
        });
      });
    }
  }

  initDrawerItems(){
    _drawerItems.clear();
    DrawerItem header = new DrawerItem(0, this.widget._user.full_name, DrawerType.header);
    DrawerItem privacy = new DrawerItem(1, MyLocalizations.instanceLocalization['term_use'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem blockUser = new DrawerItem(2, MyLocalizations.instanceLocalization['block_user'], DrawerType.item, iconPath: 'assets/icons/block_user.png');
    DrawerItem unblockUser = new DrawerItem(3, MyLocalizations.instanceLocalization['unblock_user'], DrawerType.item, iconPath: 'assets/icons/unblock_user.png');
    DrawerItem settings = new DrawerItem(4, MyLocalizations.instanceLocalization['settings'], DrawerType.item, iconPath: 'assets/icons/setting.png');
    DrawerItem logout = new DrawerItem(5, MyLocalizations.instanceLocalization['logout'], DrawerType.item, iconPath: 'assets/icons/logout.png');

    //set visibility of block/unblock item
    if(this.widget._currentUser.type == User.USER_TYPE_ADMIN) {
      if (this.widget._user.active == 1) {
        unblockUser.visible = false;
      }
      else {
        blockUser.visible = false;
      }
    }
    else{
      unblockUser.visible = false;
      blockUser.visible = false;
    }
    if(this.widget._user.id_subscriber != this.widget._currentUser.id_subscriber) {
      logout.visible = false;
    }

    _drawerItems.add(header);
    _drawerItems.add(privacy);
    _drawerItems.add(blockUser);
    _drawerItems.add(unblockUser);
    _drawerItems.add(settings);
    _drawerItems.add(logout);

  }

  onDrawerItemSelected(int id){
    switch(id){
      case 1: //click on terms of use
        launch(constants.LINK_TERMS_USE);
        break;
      case 2: //click on block user
        alert.showAlertDialog
        (
            _context,
            MyLocalizations.instanceLocalization['warning'],
            MyLocalizations.instanceLocalization['want_block_user'],
            (){
              blockSubscriber();
            }
        );
        break;
      case 3: //click on unblock user
        alert.showAlertDialog
        (
            _context,
            MyLocalizations.instanceLocalization['warning'],
            MyLocalizations.instanceLocalization['want_unblock_user'],
            (){
              unblockSubscriber();
            }
        );
        break;
      case 4: //click on settings
        Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (BuildContext context){
                  return Settings();
                }
            ));
        break;
      case 5: //click on logout
        Navigator.pushReplacement(
            _context,
            MaterialPageRoute(
                builder: (BuildContext context){
                  this.widget._user.logout();
                  return Login();
                }
            ));
        break;
    }
  }

  deleteBadge() {
    setState(() {
      this.widget._currentUser.fanBadge = null;
      this.widget._currentUser.toMap();
    });
  }

  void setBlockingState(bool isLoading){
    setState(() {
      initDrawerItems();
      this.isLoading = isLoading;
    });
  }

  blockSubscriber() async{
    bool isBlock = await this.widget._currentUser.block(this.widget._user, setBlockingState,context);
    if(isBlock){
      Toast.show(MyLocalizations.instanceLocalization['user_blocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(MyLocalizations.instanceLocalization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  unblockSubscriber() async{
    bool isUnblock = await this.widget._currentUser.unblock(this.widget._user, setBlockingState,context);
    if(isUnblock){
      Toast.show(MyLocalizations.instanceLocalization['user_unblocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(MyLocalizations.instanceLocalization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

}