import 'package:flutter/material.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {

  List<Map> housesList = [
    {
      "house_nr": 1,
      "round_nr": 3,
      "distribution_date": "7-10-2019",
      "day_count": 293,
      "chicken_count": 21821
    },
    {
      "house_nr": 2,
      "round_nr": 3,
      "distribution_date": "7-10-2019",
      "day_count": 293,
      "chicken_count": 24143
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: HomeScreenAppBar(),
      drawer: SidebarMenu(),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HomeScreenHeader(),
            Expanded(
              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                            child: Text(
                              "Dashboard",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: housesList.length,
                            itemBuilder: (BuildContext context, int index){
                              Map dailyObserve = housesList[index];
                              return Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                    onTap: (){
                                      print("Dashboard Card from House ${dailyObserve['house_nr']} tapped!");
                                      Navigator.pushNamed(context, "/dashboarddetailscreen");
                                    },
                                    title: GestureDetector(
                                      onTap: (){
                                        print("Dashboard Card from House ${dailyObserve['house_nr']} tapped!");
                                        Navigator.pushNamed(context, "/dashboarddetailscreen");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "House Nr : ${dailyObserve['house_nr']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Container(
                                                  height: 0.25,
                                                  width: MediaQuery.of(context).size.width / 1.325,
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 1.325,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                              "Round Nr. : ${dailyObserve['round_nr']}",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "Dist. Date : ${dailyObserve['distribution_date']}",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 30,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                              "Number : ${dailyObserve['chicken_count']}",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "Day : ${dailyObserve['day_count']}",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}