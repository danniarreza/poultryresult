import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class EggsNewEditScreen extends StatefulWidget {
  @override
  _EggsNewEditScreenState createState() => _EggsNewEditScreenState();
}

class _EggsNewEditScreenState extends State<EggsNewEditScreen> {
  DateTime _selectedDateTime = DateTime.now();

  List<String> eggQualities = [
    "1st Quality",
    "2nd Quality",
    "Ground Eggs",
  ];

  String _currentSelectedEggsQualities;
  int eggAmount;
  int eggWeight;

  Map<dynamic, bool> warningList = {
    "eggQualitiesWarning" : false,
    "eggAmountWarning": false,
    "eggWeightWarning": false,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _buildInspectionInformationCard(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          title: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Eggs Round : 1",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Container(
                  height: 0.25,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "House : 1",
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
                              "Round Nr. : 3",
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
                              "Date :",
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
                              DateFormat('dd MMMM yyyy').format(_selectedDateTime),
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
                Container(
                  height: 0.25,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  color: Colors.grey,
                ),
                _buildEggsQualitiesForm(),
                SizedBox(height: 15,),
                _buildEggsAmountForm(),
                SizedBox(height: 15,),
                _buildEggsWeightForm(),
                SizedBox(height: 15,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildEggsQualitiesForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Egg Quality",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
                fontWeight: FontWeight.w600
            )
        ),
        SizedBox(height: 10,),
        Container(
          height: 45,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            value: _currentSelectedEggsQualities,
            hint: Text("Select method"),
            onChanged: (String newValue){
              setState(() {
                _currentSelectedEggsQualities = newValue;
              });
            },
            validator: (String value) {
              if(value == null){
                setState(() {
                  warningList["eggQualitiesWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["eggQualitiesWarning"] = false;
                });
                return null;
              }
            },
            items: eggQualities.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        warningList["eggQualitiesWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please select egg quality",
            style: TextStyle(
                fontSize: 14,
                color: Colors.red
            ),
          ),
        ) : SizedBox(height: 0,),
        SizedBox(height: 10,),
      ],
    );
  }

  _buildEggsAmountForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Amount",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Insert Amount",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            validator: (String value) {
              if(value == null || value == ''){
                setState(() {
                  warningList["eggAmountWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["eggAmountWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                eggAmount = int.parse(value);
              });
            },
          ),
          warningList["eggAmountWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please fill in amount",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red
              ),
            ),
          ) : SizedBox(height: 0,),
          SizedBox(height: 10,),
        ]
    );
  }

  _buildEggsWeightForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Weight [grams/egg]",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Insert Weight",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            validator: (String value) {
              if(value == null || value == ''){
                setState(() {
                  warningList["eggWeightWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["eggWeightWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                eggWeight = int.parse(value);
              });
            },
          ),
          warningList["eggWeightWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please fill in weight",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red
              ),
            ),
          ) : SizedBox(height: 0,),
          SizedBox(height: 10,),
        ]
    );
  }

  _buildSubmitButton(){
    return GestureDetector(
      onTap: (){
        bool formClear = true;
        if(!formKey.currentState.validate()){
          print("Fail");
          return;
        }

        warningList.forEach((key, value) {
          if(value == true){
            formClear = false;
            return;
          }
        });

        if(formClear == true){
          formKey.currentState.save();
          print("Saved");
          formSubmit();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.25,
                  blurRadius: 1,
                  offset: Offset(0, 1.5)
              )
            ]
        ),
        child: Center(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }

  formSubmit() async{
    Dialogs.waitingDialog(context, "Submitting...", "Please Wait", false);

    Future.delayed(Duration(seconds: 1), (){
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: HomeScreenAppBar(),
      drawer: SidebarMenu(),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
                                child: Text(
                                  "Eggs",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildInspectionInformationCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
