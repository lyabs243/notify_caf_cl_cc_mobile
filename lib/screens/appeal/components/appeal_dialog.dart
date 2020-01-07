import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/user_post_header_infos.dart';
import '../../../models/appeal_item.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import '../../../models/user.dart';
import '../../user_profile/user_profile.dart';
import '../../../models/constants.dart' as constant;

class AppealDialog extends StatefulWidget{

  Map localization;
  AppealItem appealItem;
  User currentUser;
  User user;

  AppealDialog(this.localization,this.appealItem,this.currentUser, this.user);

  @override
  _AppealDialogState createState() {
    // TODO: implement createState
    return new _AppealDialogState();
  }

}

class _AppealDialogState extends State<AppealDialog>{

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ModalProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.localization['appeal']),
          actions: <Widget>[
            FlatButton(
              child: Text(
                this.widget.localization['approve'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                setState(() {
                  isLoading = true;
                  this.widget.appealItem.approveAppeal(this.widget.currentUser.id_subscriber,context).then((success){
                    setState(() {
                      isLoading = false;
                    });
                    if(success) {
                      Toast.show(this.widget.localization['appeal_approved'], context,duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                      Navigator.pop(context, this.widget.appealItem);
                    }
                    else{
                      Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM);
                    }
                  });
                });
              },
            ),
            FlatButton(
              child: Text(
                this.widget.localization['deactivate'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                setState(() {
                  isLoading = true;
                  this.widget.appealItem.deactivateAppeal(this.widget.currentUser.id_subscriber,context).then((success){
                    setState(() {
                      isLoading = false;
                    });
                    if(success) {
                      Toast.show(this.widget.localization['appeal_deactivated'], context,duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                      Navigator.pop(context, this.widget.appealItem);
                    }
                    else{
                      Toast.show(this.widget.localization['error_occured'], context,duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                    }
                  });
                });
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Card(
                elevation: 15.0,
                child: UserPostHeaderInfos(this.widget.localization, this.widget.user, this.widget.currentUser,
                    this.widget.appealItem.register_date),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  User user = new User();
                  user.id_subscriber = this.widget.appealItem.id_subscriber;
                  return new UserProfile(this.widget.currentUser,user,this.widget.localization);
                }));
              },
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  color: Theme.of(context).primaryColor
              ),
              child: Text(
                constant.convertDateToAbout(this.widget.appealItem.register_date,this.widget.localization),
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white
                ),
              ),
            ),
            Card(
              elevation: 15.0,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    color: (this.widget.appealItem.is_policie_violate)? Colors.green : Colors.red,
                    child: Text(
                      (this.widget.appealItem.is_policie_violate)?
                      this.widget.localization['appeal_recognize_violated_true'] :
                      this.widget.localization['appeal_recognize_violated_false'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    color: (this.widget.appealItem.is_policie_respect_after_activation)? Colors.green : Colors.red,
                    child: Text(
                      (this.widget.appealItem.is_policie_respect_after_activation)?
                      this.widget.localization['appeal_promise_not_violated_true']:
                      this.widget.localization['appeal_promise_not_violated_false'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 15.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Text(
                    this.widget.appealItem.appeal_description,
                    textScaleFactor: 1.2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      opacity: 0.5,
      color: Colors.black,
      inAsyncCall: isLoading,
      dismissible: false,
    );
  }

}