import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/fan_badge.dart';
import 'package:flutter_cafclcc/models/user.dart';
import 'package:flutter_cafclcc/screens/fan_badge/fan_badge_countries.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import '../../../models/constants.dart' as constants;
import '../user_profile.dart';
import '.././../../components/alert_dialog.dart' as alert;

class UserBadge extends StatefulWidget {

  Map localization;
  User _user, _currentUser;
  Function onBadgeDeleted;

  UserBadge(this.localization, this._user, this._currentUser, this.onBadgeDeleted);

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
    progressDialog.style(message: this.widget.localization['loading']);
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
          Text(
            this.widget._user.fanBadge.title,
            textScaleFactor: 1.8,
            style: TextStyle(
                color: Colors.white
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
                      return FanBadgeCountries(this.widget.localization, MaterialPageRoute(
                          builder: (context) {
                            return UserProfile(this.widget._currentUser, this.widget._currentUser,
                                this.widget.localization);
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
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              (this.widget._currentUser.id_subscriber == this.widget._user.id_subscriber)?
              this.widget.localization['you_dont_have_badge']:
              this.widget.localization['user_dont_have_badge'],
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
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
                      return FanBadgeCountries(this.widget.localization, MaterialPageRoute(
                          builder: (context) {
                            return UserProfile(this.widget._currentUser, this.widget._currentUser,
                                this.widget.localization);
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
    alert.showAlertDialog(context, this.widget.localization['warning'], this.widget.localization['want_delete_badge'],
        this.widget.localization, (){
          progressDialog.show();
        this.widget._user.fanBadge.delete(context).then((result){
          progressDialog.hide();
          Toast.show(this.widget.localization['badge_deleted'], context, gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG);
          this.widget.onBadgeDeleted();
        });
    });
  }

}