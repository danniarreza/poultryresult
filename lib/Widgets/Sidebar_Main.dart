import 'package:flutter/material.dart';
import 'package:poultryresult/Screens/DailyObserve/DailyObserveHomeScreen.dart';
import 'package:poultryresult/Screens/Dashboard/DashboardDetailScreen.dart';
import 'package:poultryresult/Screens/Dashboard/DashboardHomeScreen.dart';
import 'package:poultryresult/Services/database_helper.dart';

class SidebarMenu extends StatefulWidget {
  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class ExpansionMenuItem {
  ExpansionMenuItem({this.isExpanded, this.header, this.body});

  bool isExpanded;
  final String header;
  final List<String> body;
}

class _SidebarMenuState extends State<SidebarMenu> {

  List<ExpansionMenuItem> expansionMenuItems = <ExpansionMenuItem>[
    ExpansionMenuItem(isExpanded: false, header: "Daily Observations", body: ["Mortality","Feed","Water","Weights","Vaccinations","Additives",]),
  ];


  bool user_loaded = false;
  String user_name;
  String user_fullname;

  @override
  void initState() {
    // TODO: implement setState
    super.initState();

    _getUserSession();
  }

  _getUserSession() async {
    String tableName = 'user';
    List<Map<String, dynamic>> rows = await DatabaseHelper.instance.getById(tableName, 1);
//    print(rows);
    setState(() {
      user_name = rows[0]['user_name'];
      user_fullname = rows[0]['user_fullname'];
      user_loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: user_loaded == true ? Text(user_fullname) : Container(),
            accountEmail: user_loaded == true ? Text(user_name) : Container(),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://png.pngtree.com/png-clipart/20190520/original/pngtree-vector-users-icon-png-image_4144740.jpg"),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text(
              "Monitoring",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat"
              ),
            ),
          ),
          Container(
            height: 0.25,
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey,
          ),
          ListTile(
            title: Text("Dashboard"),
            onTap: (){
              Navigator.of(context).pop();
//              Navigator.pushReplacementNamed(context, "/chickensinhomescreen");
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (context, animation1, animation2){
                  return DashboardDetailScreen();
                },
                transitionDuration: Duration(seconds: 0),
              )
              );
            },
          ),
//          ListTile(
//            title: Text("Messages"),
//            onTap: (){
//              Navigator.of(context).pop();
////              Navigator.pushReplacementNamed(context, "/dailyobservehomescreen");
//              Navigator.pushReplacement(context, PageRouteBuilder(
//                pageBuilder: (context, animation1, animation2){
//                  return DailyObserveHomeScreen();
//                },
//                transitionDuration: Duration(seconds: 0),
//              )
//              );
//            },
//          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text(
              "Rounds",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat"
              ),
            ),
          ),
          Container(
            height: 0.25,
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey,
          ),
//          ListTile(
//            title: Text("Chickens In"),
//            onTap: (){
//              Navigator.of(context).pop();
////              Navigator.pushReplacementNamed(context, "/chickensinhomescreen");
//              Navigator.pushReplacement(context, PageRouteBuilder(
//                pageBuilder: (context, animation1, animation2){
//                  return ChickensInHomeScreen();
//                },
//                transitionDuration: Duration(seconds: 0),
//              )
//              );
//            },
//          ),

          ListTile(
            title: Text("Daily Observations"),
            onTap: (){
              Navigator.of(context).pop();
//              Navigator.pushReplacementNamed(context, "/dailyobservehomescreen");
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (context, animation1, animation2){
                  return DailyObserveHomeScreen();
                },
                transitionDuration: Duration(seconds: 0),
                )
              );
            },
          ),

//          ExpansionTile(
//            title: Text("Daily Observations"),
//            children: <Widget>[
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Mortality"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveMortalityHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Feed"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveFeedHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Weights"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveWeightsHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Vaccinations"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveVaccinationsHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Additives"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveAdditivesHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//              ListTile(
//                title: Container(
//                  padding: EdgeInsets.only(left: 15),
//                  child: Text("Water"),
//                ),
//                onTap: (){
//                  Navigator.of(context).pop();
//                  Navigator.pushReplacement(context, PageRouteBuilder(
//                    pageBuilder: (context, animation1, animation2){
//                      return DailyObserveWaterHomeScreen();
//                    },
//                    transitionDuration: Duration(seconds: 0),
//                  )
//                  );
//                },
//              ),
//            ],
//          ),

//          ListTile(
//            title: Text("Chickens Out"),
//            onTap: (){
//              Navigator.of(context).pop();
////              Navigator.pushReplacementNamed(context, "/chickensouthomescreen");
//              Navigator.pushReplacement(context, PageRouteBuilder(
//                pageBuilder: (context, animation1, animation2){
//                  return ChickensOutHomeScreen();
//                },
//                transitionDuration: Duration(seconds: 0),
//              )
//              );
//            },
//          ),
        ],
      ),
    );
  }
}
