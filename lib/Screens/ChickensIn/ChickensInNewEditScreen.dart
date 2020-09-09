import 'package:flutter/material.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';

class ChickensInNewEditScreen extends StatefulWidget {
  @override
  _ChickensInNewEditScreenState createState() => _ChickensInNewEditScreenState();
}

class _ChickensInNewEditScreenState extends State<ChickensInNewEditScreen> {
  String conceptSelected;
  String journalSelected;
  int amountTon;
  int floorTemp;

  List<Map> conceptListJSON = [
    {
      "concept_id": 1,
      "concept_name": "Standard Heavy"
    },
    {
      "concept_id": 2,
      "concept_name": "Goed Nest Kip"
    },
    {
      "concept_id": 3,
      "concept_name": "Free Range"
    },
    {
      "concept_id": 4,
      "concept_name": "Royal Top"
    },
  ];

  List<Map> journalListJSON = [
    {
      "journal_id": 1,
      "journal_name": "Al ain farm"
    },
    {
      "journal_id": 2,
      "journal_name": "Free range Hubbard"
    }
  ];

  _buildMaintainRoundTile(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text(
                    "Maintain Round",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _buildMarketSegmentCard(),
                    _buildPreparationCard(),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(),
      ],
    );
  }

  _buildMarketSegmentCard(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Market Segment",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            )
                        ),
                        Container(
                          height: 0.25,
                          width: MediaQuery.of(context).size.width / 1.275,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          color: Colors.grey,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Concept",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isDense: true,
                                        hint: Text("Select Concept"),
                                        value: conceptSelected,
                                        onChanged: (String newValue){
                                          setState(() {
                                            conceptSelected = newValue;
                                          });
                                          print(conceptSelected);
                                        },
                                        items: conceptListJSON.map((Map concept) {
                                          return DropdownMenuItem<String>(
                                            value: concept["concept_name"].toString(),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: Text(concept["concept_name"]),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Journal",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isDense: true,
                                        hint: Text("Select Journal"),
                                        value: journalSelected,
                                        onChanged: (String newValue){
                                          setState(() {
                                            journalSelected = newValue;
                                          });
                                          print(journalSelected);
                                        },
                                        items: journalListJSON.map((Map concept) {
                                          return DropdownMenuItem<String>(
                                            value: concept["journal_name"].toString(),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: Text(concept["journal_name"]),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildPreparationCard(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Preparation",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            )
                        ),
                        Container(
                          height: 0.25,
                          width: MediaQuery.of(context).size.width / 1.275,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          color: Colors.grey,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Disinfectant",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isDense: true,
                                        hint: Text("Select Concept"),
                                        value: conceptSelected,
                                        onChanged: (String newValue){
                                          setState(() {
                                            conceptSelected = newValue;
                                          });
                                          print(conceptSelected);
                                        },
                                        items: conceptListJSON.map((Map concept) {
                                          return DropdownMenuItem<String>(
                                            value: concept["concept_name"].toString(),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: Text(concept["concept_name"]),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Bedding",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        isDense: true,
                                        hint: Text("Select Journal"),
                                        value: journalSelected,
                                        onChanged: (String newValue){
                                          setState(() {
                                            journalSelected = newValue;
                                          });
                                          print(journalSelected);
                                        },
                                        items: journalListJSON.map((Map concept) {
                                          return DropdownMenuItem<String>(
                                            value: concept["journal_name"].toString(),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                  child: Text(concept["journal_name"]),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Amount[ton]",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Insert Amount",
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white)
                                        ),
                                      ),
//                            validator: (String value) {},
                                      onSaved: (String value){
                                        amountTon = int.parse(value);
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "Floor Temp.",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[100]
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Insert Floor Temp",
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white)
                                        ),
                                      ),
//                            validator: (String value) {},
                                      onSaved: (String value){
                                        floorTemp = int.parse(value);
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

//  ----------------------------------------------------------------------------

  _buildMaintainDeliveryTile(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text(
                    "Maintain Delivery",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _buildMarketSegmentCard(),
                    _buildPreparationCard(),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(),
      ],
    );
  }

  _buildDistributeChickensTile(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text(
                    "Distribute Delivered Chickens",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _buildMarketSegmentCard(),
                    _buildPreparationCard(),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(),
      ],
    );
  }

  _buildSupplyVaccinationTile(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text(
                    "Supply Vaccinations",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _buildMarketSegmentCard(),
                    _buildPreparationCard(),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(),
      ],
    );
  }

  _buildDeliveryInvoicesTile(){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text(
                    "Delivery Invoices",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _buildMarketSegmentCard(),
                    _buildPreparationCard(),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: HomeScreenAppBar(),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Invoice Nr 5566",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    "Distribution Date:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Round 3",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "7-10-2019",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildMaintainRoundTile(),
                    SizedBox(height: 25),
                    _buildMaintainDeliveryTile(),
                    SizedBox(height: 25),
                    _buildDistributeChickensTile(),
                    SizedBox(height: 25),
                    _buildSupplyVaccinationTile(),
                    SizedBox(height: 25),
                    _buildDeliveryInvoicesTile(),
                  ],
                ),
              )
            ),

          ],
        ),
      ),
    );
  }
}
