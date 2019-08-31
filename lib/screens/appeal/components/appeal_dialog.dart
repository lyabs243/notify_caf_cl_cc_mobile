import 'package:flutter/material.dart';

class AppealDialog extends StatefulWidget{

  Map localization;

  AppealDialog(this.localization);

  @override
  _AppealDialogState createState() {
    // TODO: implement createState
    return new _AppealDialogState();
  }

}

class _AppealDialogState extends State<AppealDialog>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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

            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            elevation: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: Text(
                  'Ítem 4',
                  textScaleFactor: 2.0,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
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
                  color: Colors.red,
                  child: Text(
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
                  color: Colors.green,
                  child: Text(
                    this.widget.localization['appeal_promise_not_violated_true'],
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
                  '''Promet de ne plus enfeindre les conditions d'utilisation en cas de reactivation de compte, en plus c vraiment honteux grave honteux car notre pays doit aller de l'avat ce n'est pas de cette maniere qu'o peut evoluer car le congo a besoin de ses enfant!!! Promet de ne plus enfeindre les conditions d'utilisation en cas de reactivation de compte, en plus c vraiment honteux grave honteux car notre pays doit aller de l'avat ce n'est pas de cette maniere qu'o peut evoluer car le congo a besoin de ses enfant!!! Promet de ne plus enfeindre les conditions d'utilisation en cas de reactivation de compte, en plus c vraiment honteux grave honteux car notre pays doit aller de l'avat ce n'est pas de cette maniere qu'o peut evoluer car le congo a besoin de ses enfant!!! Promet de ne plus enfeindre les conditions d'utilisation en cas de reactivation de compte, en plus c vraiment honteux grave honteux car notre pays doit aller de l'avat ce n'est pas de cette maniere qu'o peut evoluer car le congo a b!!! 
                  ''',
                  textScaleFactor: 1.2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}