import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/fan_badge.dart';
import 'package:flutter_cafclcc/models/localizations.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/fan_badge/fan_badge_countries.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import '../../../models/constants.dart' as constants;
import '../user_profile.dart';
import '.././../../components/alert_dialog.dart' as alert;

class UserBadge extends StatefulWidget {

  User _user, _currentUser;
  Function onBadgeDeleted;

  UserBadge(this._user, this._currentUser, this.onBadgeDeleted);

  @override
  _UserBadgeState createState() {
    return _UserBadgeState();
  }

}

class _UserBadgeState extends State<UserBadge> {

  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = new ProgressDialog(context, isDismissible: false);
    progressDialog.style(message: MyLocalizations.instanceLocalization['loading']);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (this.widget._user.fanBadge != null)?
      Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            child: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: Image.network(
                  this.widget._user.fanBadge.url_logo,
                  fit: BoxFit.cover,
                ),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              this.widget._user.fanBadge.title,
              overflow: TextOverflow.visible,
              maxLines: 2,
              textAlign: TextAlign.center,
              textScaleFactor: 1.8,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          (this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber)?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                      return FanBadgeCountries(MaterialPageRoute(
                          builder: (context) {
                            return UserProfile(this.widget._currentUser, this.widget._currentUser);
                          }));
                    }));
                  }
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    deleteBadge();
                  }
              )
            ],
          ) : Container()
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
      color: constants.fromHex(this.widget._user.fanBadge.color),
      padding: EdgeInsets.all(8.0),
    ):
    Container(
      height: 80.0,
      padding: EdgeInsets.all(8.0),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              (this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber)?
              MyLocalizations.instanceLocalization['you_dont_have_badge']:
              MyLocalizations.instanceLocalization['user_dont_have_badge'],
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          (this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber)?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                      return FanBadgeCountries(MaterialPageRoute(
                          builder: (context) {
                            return UserProfile(this.widget._currentUser, this.widget._currentUser);
                          }));
                    }));
                  }
              ),
            ],
          ):
          Container()
        ],
      ),
    );
  }

  deleteBadge() async {
    alert.showAlertDialog(context, MyLocalizations.instanceLocalization['warning'], MyLocalizations.instanceLocalization['want_delete_badge'], (){
          progressDialog.show();
        this.widget._user.fanBadge.delete(context).then((result){
          progressDialog.hide();
          Toast.show(MyLocalizations.instanceLocalization['badge_deleted'], context, gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG);
          this.widget.onBadgeDeleted();
        });
    });
  }

}