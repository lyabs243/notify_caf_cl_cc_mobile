import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../components/profil_avatar.dart';
import '../../../models/drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../screens/login/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import '../../../models/constants.dart' as constants;
import '../../../components/alert_dialog.dart' as alert;

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _drawerItems = new List<DrawerItem>();
    initDrawerItems();
    return ModalProgressHUD(
      child:  ListView.builder(
        itemBuilder: ((context,i){
          if(i == 0){
            return Container(
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
                  new Text(
                    (this.widget._user.id_accout_type == User.FACEBOOK_ACCOUNT_ID)?
                    this.widget._localization['connected_with_facebook']:
                    this.widget._localization['connected_with_google'],
                    textScaleFactor: 1.2,
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic
                    ),
                  )
                ],
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: new DecorationImage(
                  image: new AssetImage('assets/bg_cat.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
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
      opacity: 0.5,
    );
  }

  initDrawerItems(){

    DrawerItem header = new DrawerItem(0, this.widget._user.full_name, DrawerType.header);
    DrawerItem privacy = new DrawerItem(1, this.widget._localization['term_use'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem blockUser = new DrawerItem(2, this.widget._localization['block_user'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem unblockUser = new DrawerItem(3, this.widget._localization['unblock_user'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem logout = new DrawerItem(4, this.widget._localization['logout'], DrawerType.item, iconPath: 'assets/icons/logout.png');

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

    _drawerItems.add(header);
    _drawerItems.add(privacy);
    _drawerItems.add(blockUser);
    _drawerItems.add(unblockUser);
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
      case 4: //click on logout
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

  void setBlockingState(bool isLoading){
    setState(() {
      this.isLoading = isLoading;
    });
  }

  blockSubscriber() async{
    bool isBlock = await this.widget._currentUser.block(this.widget._user.id_subscriber, setBlockingState);
    if(isBlock){
      Toast.show(this.widget._localization['user_blocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(this.widget._localization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  unblockSubscriber() async{
    bool isUnblock = await this.widget._currentUser.unblock(this.widget._user.id_subscriber, setBlockingState);
    if(isUnblock){
      Toast.show(this.widget._localization['user_unblocked'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else{
      Toast.show(this.widget._localization['error_occured'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

}