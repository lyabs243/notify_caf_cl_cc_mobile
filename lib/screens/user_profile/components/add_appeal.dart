import 'package:flutter/material.dart';
import '../../../models/appeal_item.dart';
import '../../../models/user.dart';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Appeal extends StatefulWidget{

  Map localization;

  Appeal(this.localization);

  @override
  _AppealState createState() {
    // TODO: implement createState
    return new _AppealState();
  }

}

class _AppealState extends State<Appeal>{

  bool isRecongnizeViolated = false;
  bool isViolatedAgain = false;
  String appealDescription;
  User user;

  bool isLoading = false;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User.getInstance().then((u){
      setState(() {
        user = u;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.localization['appeal']),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            onPressed: (){
              setState(() {
                isLoading = true;
              });
              AppealItem appealItem = new AppealItem(null, user.id_subscriber, isRecongnizeViolated,
                  isViolatedAgain, null, appealDescription, null, null, null);
              appealItem.addAppeal(context).then((result){
                setState(() {
                  isLoading = false;
                });
                if(result){
                  Toast.show(this.widget.localization['appeal_sended'], context, duration: Toast.LENGTH_LONG,
                      gravity:  Toast.BOTTOM);
                  Navigator.of(context).pop();
                }
                else{
                  Toast.show(this.widget.localization['error_occured'], context, duration: Toast.LENGTH_LONG,
                      gravity:  Toast.BOTTOM);
                }
              });
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                Center(
                  child: Text(
                    this.widget.localization['answer_questionnaire_appeal'],
                    textScaleFactor: 1.5,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        this.widget.localization['is_recognize_violated_terms'],
                        textScaleFactor: 1.4,
                      ),
                    ),
                    Checkbox(
                        value: isRecongnizeViolated,
                        onChanged: (value){
                          setState(() {
                            isRecongnizeViolated = value;
                          });
                        }
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        this.widget.localization['is_recognize_not_violated_terms_after_activate'],
                        textScaleFactor: 1.4,
                      ),
                    ),
                    Checkbox(
                        value: isViolatedAgain,
                        onChanged: (value){
                          setState(() {
                            isViolatedAgain = value;
                          });
                        }
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0),),
                TextField(
                  decoration: new InputDecoration(
                      labelText: this.widget.localization['appeal_description'],
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      alignLabelWithHint: true
                  ),
                  maxLines: 10,
                  maxLength: 1000,
                  onChanged: (val){
                    appealDescription = val;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}