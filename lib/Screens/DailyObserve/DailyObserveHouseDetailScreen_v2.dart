import 'package:flutter/material.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';

class DailyObserveHouseDetailScreen extends StatefulWidget {
  @override
  _DailyObserveHouseDetailScreenState createState() => _DailyObserveHouseDetailScreenState();
}

class _DailyObserveHouseDetailScreenState extends State<DailyObserveHouseDetailScreen> {

  List<Map> dailyObservationsList = [
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

  _buildHouseInformationCard(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          title: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "House Nr : 1",
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
                                  "Round Nr. : 3",
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
                                  "Dist. Date : 7-10-2019",
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
                                  "Number : 21821",
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
                                  "Day : 293",
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
                    SizedBox(height: 15,),
                    Text(
                      "Observations",
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
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 1.325,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.do_not_disturb),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservemortalityhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Mortality",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.spa),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservefeedhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Feed",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.opacity),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservewaterhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Water",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.vertical_align_bottom),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobserveweightshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Weights",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.format_color_fill),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Additives",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.healing),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservevaccineshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Vaccines",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

  _buildMenuButtons(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          title: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Observations",
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
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 1.325,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.do_not_disturb),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservemortalityhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Mortality",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.spa),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservefeedhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Feed",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.opacity),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservewaterhomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Water",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.vertical_align_bottom),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobserveweightshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Weights",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.format_color_fill),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Additives",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: IconButton(
                                        color: Colors.white,
                                        iconSize: 40,
                                        icon: Icon(Icons.healing),
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/dailyobservevaccineshomescreen");
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Vaccines",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                              child: Text(
                                "Daily Observations",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildHouseInformationCard(),
//                        _buildMenuButtons(),
                      ],
                    ),
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
