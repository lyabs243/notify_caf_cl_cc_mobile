import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../components/profil_avatar.dart';
import '../../../models/drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../screens/login/login.dart';
import '../../../models/constants.dart' as constants;

class Body extends StatelessWidget{

  User _user;
  Map _localization;

  List<DrawerItem> _drawerItems;
  BuildContext _context;

  Body(this._user,this._localization);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _drawerItems = new List<DrawerItem>();
    initDrawerItems();
    return ListView.builder(
      itemBuilder: ((context,i){
        if(i == 0){
          return Container(
            child: Column(
              children: <Widget>[
                ProfilAvatar(_user,width: 80.0,height: 80.0),
                new Text(
                  _user.full_name,
                  textScaleFactor: 1.8,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                new Text(
                  (_user.id_accout_type == User.FACEBOOK_ACCOUNT_ID)?
                  _localization['connected_with_facebook']:
                  _localization['connected_with_google'],
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
    );
  }

  initDrawerItems(){

    DrawerItem header = new DrawerItem(0, _user.full_name, DrawerType.header);
    DrawerItem privacy = new DrawerItem(1, _localization['term_use'], DrawerType.item, iconPath: 'assets/icons/privacy.png');
    DrawerItem logout = new DrawerItem(2, _localization['logout'], DrawerType.item, iconPath: 'assets/icons/logout.png');

    _drawerItems.add(header);
    _drawerItems.add(privacy);
    _drawerItems.add(logout);

  }

  onDrawerItemSelected(int id){
    switch(id){
      case 1: //click on terms of use
        launch(constants.LINK_TERMS_USE);
        break;
      case 2: //click on logout
        Navigator.pushReplacement(
            _context,
            MaterialPageRoute(
                builder: (BuildContext context){
                  _user.logout();
                  return Login();
                }
            ));
        break;
    }
  }

}