import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
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
  Map _localization;

  Body(this._currentUser,this._user,this._localization);

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
  bool isLoading = false;

  bool isCurrentUser = false;

  AdmobBanner admobBanner;

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
    initData();
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
      EmptyData(widget._localization):
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
                        this.widget._localization['connected_with_facebook']:
                        this.widget._localization['connected_with_google'],
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
                            this.widget._localization['account_been_blocked'],
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        width: MediaQuery.of(context).size.width/1.4,
                      ),
                      OutlineButton(
                        child: Text(
                            this.widget._localization['appeal'],
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context){
                                return Appeal(this.widget._localization);
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
                UserBadge(this.widget._localization, this.widget._user, this.widget._currentUser, deleteBadge),
                (constants.canShowAds)?
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: admobBanner,
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
    DrawerItem privacy = new DrawerItem(1, this.widget._localization['term_use'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem blockUser = new DrawerItem(2, this.widget._localization['block_user'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem unblockUser = new DrawerItem(3, this.widget._localization['unblock_user'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem settings = new DrawerItem(4, this.widget._localization['settings'], DrawerType.item, iconPath: 'assets/icons/date.png');
    DrawerItem logout = new DrawerItem(5, this.widget._localization['logout'], DrawerType.item, iconPath: 'assets/icons/logout.png');

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
            this.widget._localization['warning'],
            this.widget._localization['want_block_user'],
            this.widget._localization,
            (){
              blockSubscriber();
            }
        );
        break;
      case 3: //click on unblock user
        alert.showAlertDialog
        (
            _context,
            this.widget._localization['warning'],
            this.widget._localization['want_unblock_user'],
            this.widget._localization,
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
                  return Settings(this.widget._localization);
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
      Toast.show(this.widget._localization['user_blocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(this.widget._localization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  unblockSubscriber() async{
    bool isUnblock = await this.widget._currentUser.unblock(this.widget._user, setBlockingState,context);
    if(isUnblock){
      Toast.show(this.widget._localization['user_unblocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(this.widget._localization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

}