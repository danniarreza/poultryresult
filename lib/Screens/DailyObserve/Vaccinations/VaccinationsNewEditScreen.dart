import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class VaccinationsNewEditScreen extends StatefulWidget {
  @override
  _VaccinationsNewEditScreenState createState() => _VaccinationsNewEditScreenState();
}

class _VaccinationsNewEditScreenState extends State<VaccinationsNewEditScreen> {

  DateTime _selectedDateTime = DateTime.now();
  String vaccinationArticle;
  int amountDayFlock;

  List<String> amountUnits = [
    "ml",
    "cl",
    "dl",
    "l",
    "m3"
  ];

  String _currentSelectedamountUnits;

  List<String> applicationMethods = [
    "Drinking Water",
    "Spraying",
    "Atomist",
    "Injection",
    "In Ovo"
  ];

  String _currentSelectedApplicationMethod;

  List<String> medicalConditions = [
    "None",
    "Breathing",
    "Stomach Intestine",
    "Movement",
  ];

  Map<dynamic, bool> warningList = {
    "vaccineArticleWarning" : false,
    "amountDayFlockWarning" : false,
    "amountDayFlockUnitsWarning" : false,
    "applicationMethodWarning" : false,
    "medicalConditionsWarning" : false,
  };

  String _currentSelectedMedicalConditions;
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
                  "Vaccination Round : 1",
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
                _buildArticleForm(),
                _buildAmountForm(),
                _buildApplicationMethodForm(),
                _buildMedicalConditionForm(),
                SizedBox(height: 15,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildArticleForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Article",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Insert Article",
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
              suffixIcon: Icon(Icons.search),
            ),
            validator: (String value) {
              if(value == null || value == ''){
                setState(() {
                  warningList["vaccineArticleWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["vaccineArticleWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                vaccinationArticle = value;
              });
            },
          ),
          warningList["vaccineArticleWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please fill in article",
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

  _buildAmountForm(){
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
        Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: TextFormField(
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
                      warningList["amountDayFlockWarning"] = true;
                    });
                    return null;
                  } else {
                    setState(() {
                      warningList["amountDayFlockWarning"] = false;
                    });
                    return null;
                  }
                },
                onSaved: (String value){
                  setState(() {
                    vaccinationArticle = value;
                  });
                },
              ),
            ),
            SizedBox(width: 10,),
            Flexible(
              flex: 2,
              child: Container(
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
                  value: _currentSelectedamountUnits,
                  hint: Text("Units"),
                  isDense: true,
                  validator: (String value) {
                    if(value == null){
                      setState(() {
                        warningList["amountDayFlockUnitsWarning"] = true;
                      });
                      return null;
                    } else {
                      setState(() {
                        warningList["amountDayFlockUnitsWarning"] = false;
                      });
                      return null;
                    }
                  },
                  onChanged: (String newValue) {
                    setState(() {
                      _currentSelectedamountUnits = newValue;
                    });
                  },
                  items: amountUnits.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
        warningList["amountDayFlockWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please fill in amount",
            style: TextStyle(
                fontSize: 14,
                color: Colors.red
            ),
          ),
        ) : SizedBox(height: 0,),
        warningList["amountDayFlockUnitsWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please select units",
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

  _buildApplicationMethodForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Application Method",
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
            value: _currentSelectedApplicationMethod,
            hint: Text("Select method"),
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                _currentSelectedApplicationMethod = newValue;
              });
            },
            validator: (String value) {
              if(value == null){
                setState(() {
                  warningList["applicationMethodWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["applicationMethodWarning"] = false;
                });
                return null;
              }
            },
            items: applicationMethods.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        warningList["applicationMethodWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please select application method",
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

  _buildMedicalConditionForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Medical Condition",
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
            value: _currentSelectedMedicalConditions,
            isDense: true,
            hint: Text("Select condition"),
            onChanged: (String newValue) {
              setState(() {
                _currentSelectedMedicalConditions = newValue;
              });
            },
            validator: (String value) {
              if(value == null){
                setState(() {
                  warningList["medicalConditionsWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["medicalConditionsWarning"] = false;
                });
                return null;
              }
            },
            items: medicalConditions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        warningList["medicalConditionsWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please select medical conditions",
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
                                  "Vaccinations",
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
