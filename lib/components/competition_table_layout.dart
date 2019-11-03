import 'package:flutter/material.dart';

class CompetitionTableLayout extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: getTableRows(context),
      ),
    );
  }

  List<Widget> getTableRows(BuildContext context){
    List<Widget> tableRows = [];
    //add header
    tableRows.add(Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(4.0),
      height: 45,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                '#',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 12/100,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                'P',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                'W',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                'D',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 8/100,
            child: Center(
              child: Text(
                'L',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                'GS',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                'GC',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                'GD',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 9/100,
            child: Center(
              child: Text(
                'Pts',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ));

    //add rows
    for(int i = 1;i<= 4;i++){
      tableRows.add(Container(
        color: (i % 2 == 0)?Colors.grey[400] : Colors.white,
        //padding: EdgeInsets.all(4.0),
        height: 45,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  '$i',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: new Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 9.0,bottom: 9.0, right: 5.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: Image.network(
                        'https://pbs.twimg.com/profile_images/939161800037355520/lvGNqhFT_400x400.jpg',
                      ),
                    ),
                    backgroundImage: AssetImage('assets/icons/profile.png'),
                    backgroundColor: Colors.transparent,
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 12/100,
              child: Center(
                child: Text(
                  'DRC',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  '42',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  '10',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  '23',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 8/100,
              child: Center(
                child: Text(
                  '12',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  '19',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  '15',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  '10',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 9/100,
              child: Center(
                child: Text(
                  '102',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return tableRows;
  }

}