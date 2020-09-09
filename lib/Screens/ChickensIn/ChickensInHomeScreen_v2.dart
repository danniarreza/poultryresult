import 'package:flutter/material.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';

class ChickensInHomeScreen extends StatefulWidget {
  @override
  _ChickensInHomeScreenState createState() => _ChickensInHomeScreenState();
}

class _ChickensInHomeScreenState extends State<ChickensInHomeScreen> {

  List<Map> chickensInList = [
    {
      "invoice_nr" : 5666,
      "distribution_date" : "7-10-2019",
      "round_nr" : 3,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "37,000.00",
      "distributed" : "Yes"
    },
    {
      "invoice_nr" : 5656,
      "distribution_date" : "5-8-2019",
      "round_nr" : 2,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "16,250.00",
      "distributed" : "Yes"
    },
    {
      "invoice_nr" : 56541,
      "distribution_date" : "3-6-2019",
      "round_nr" : 1,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "16,000.00",
      "distributed" : "Yes"
    },
    {
      "invoice_nr" : 56541,
      "distribution_date" : "3-6-2019",
      "round_nr" : 1,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "16,000.00",
      "distributed" : "Yes"
    },
    {
      "invoice_nr" : 56541,
      "distribution_date" : "3-6-2019",
      "round_nr" : 1,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "16,000.00",
      "distributed" : "Yes"
    },
    {
      "invoice_nr" : 56541,
      "distribution_date" : "3-6-2019",
      "round_nr" : 1,
      "hatchery" : "Probroed & Sloot",
      "number" : 46100,
      "price" : "16,000.00",
      "distributed" : "Yes"
    },
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
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Text(
                              "Chickens In",
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
                        child: ListView.builder(
                            itemCount: chickensInList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map chickensIn = chickensInList[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom:10),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                    onTap: (){
                                      print("ChickensIn Card ${chickensIn['invoice_nr']} tapped!");
                                      Navigator.pushNamed(context, "/chickensinneweditscreen");
                                    },
                                    title: GestureDetector(
                                      onTap: (){
                                        print("ChickensIn Card ${chickensIn['invoice_nr']} tapped!");
                                        Navigator.pushNamed(context, "/chickensinneweditscreen");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    "Invoice Nr : ${chickensIn['invoice_nr']}",
                                                    style: TextStyle(
                                                        fontFamily: "Montserrat",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                ),
                                                Container(
                                                  height: 0.25,
                                                  width: MediaQuery.of(context).size.width / 1.5,
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 1.5,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                              "Round",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${chickensIn['round_nr']}",
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
                                                              "Distribution Date",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${chickensIn['distribution_date']}",
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
                                                              "Hatchery",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${chickensIn['hatchery']}",
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
                                                              "Number",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${chickensIn['number']}",
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
                                                              "Price",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "\$${chickensIn['price']}",
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
                                                              "Distributed",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${chickensIn['distributed']}",
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
                                            Expanded(
                                              child: Container(
                                                child: IconButton(
                                                  icon: Icon(Icons.chevron_right),
                                                  iconSize: MediaQuery.of(context).size.width / 10,
                                                ),
                                              )
                                            )
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
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(253, 184, 19, 1),
        focusColor: Colors.white,
        onPressed: (){
          print("Go to NewEdit Screen!");
        },
      ),
    );
  }
}
