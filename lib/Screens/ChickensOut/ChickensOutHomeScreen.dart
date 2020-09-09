import 'package:flutter/material.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';

class ChickensOutHomeScreen extends StatefulWidget {
  @override
  _ChickensOutHomeScreenState createState() => _ChickensOutHomeScreenState();
}

class _ChickensOutHomeScreenState extends State<ChickensOutHomeScreen> {
  List<Map> chickensOutList = [
    {
      "invoice_nr" : 56555,
      "transportation_date" : "26-9-2019",
      "round_nr" : 2,
      "slaughterhouse" : "Poultry Demo",
      "number" : 46100,
      "price" : "63,000.00"
    },
    {
      "invoice_nr" : 156544,
      "transportation_date" : "29-7-2019",
      "round_nr" : 1,
      "slaughterhouse" : "Poultry Demo",
      "number" : 46100,
      "price" : "120,000.00"
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
                              "Chickens Out",
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
                            itemCount: chickensOutList.length,
                            itemBuilder: (BuildContext context, int index){
                              Map chickensOut = chickensOutList[index];
                              return Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                                    onTap: (){
                                      print("ChickensOut Card ${chickensOut['invoice_nr']} tapped!");
//                                      Navigator.pushNamed(context, "/chickensoutneweditscreen");
                                    },
                                    title: GestureDetector(
                                      onTap: (){
                                        print("ChickensOut Card ${chickensOut['invoice_nr']} tapped!");
//                                      Navigator.pushNamed(context, "/chickensoutneweditscreen");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    "Invoice Nr : ${chickensOut['invoice_nr']}",
                                                    style: TextStyle(
                                                        fontFamily: "Montserrat",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                    )
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
                                                              "Round Nr. : ${chickensOut['round_nr']}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "Dist. Date : ${chickensOut['transportation_date']}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "Hatchery : ${chickensOut['slaughterhouse']}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                              "Number : ${chickensOut['number']}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "Price : \$${chickensOut['price']}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
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
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
