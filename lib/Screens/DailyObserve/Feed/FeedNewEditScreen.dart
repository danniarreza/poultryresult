import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class FeedNewEditScreen extends StatefulWidget {
  @override
  _FeedNewEditScreenState createState() => _FeedNewEditScreenState();
}

class _FeedNewEditScreenState extends State<FeedNewEditScreen> {

  DateTime _selectedDateTime = DateTime.now();

  List<Map> feedArticles = [
    {
      "feed_batch": 1,
      "feed_kind": "Feed 1",
      "feed_storage": 1
    },
    {
      "feed_batch": 2,
      "feed_kind": "Feed 2",
      "feed_storage": 1
    },
  ];

  Map _currentSelectedArticle;
  int _currentSelectedBatch;
  int _currentSelectedStorage;
  String _currentSelectedKind;
  int feedAmount;

  Map<dynamic, bool> warningList = {
    "selectedBatchArticle" : false,
    "feedAmountWarning" : false,
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
                  "Addition Round : 1",
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
                _buildApplicationMethodForm(),
                _buildFeedBatchStorageForm(),
                _buildFeedKindForm(),
                _buildFeedAmountForm(),
                SizedBox(height: 10,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildApplicationMethodForm(){
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
        Container(
          height: 45,
          child: DropdownButtonFormField<Map>(
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
            value: _currentSelectedArticle,
            isDense: true,
            onChanged: (Map newValue) {
              setState(() {
                _currentSelectedBatch = newValue['feed_batch'];
                _currentSelectedStorage = newValue['feed_storage'];
                _currentSelectedKind= newValue['feed_kind'];
              });
            },
            validator: (Map newValue){
              if(newValue == null){
                setState(() {
                  warningList["selectedBatchWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["selectedBatchWarning"] = false;
                });
                return null;
              }
            },
            items: feedArticles.map((Map valueMap) {
              return DropdownMenuItem<Map>(
                value: valueMap,
                child: Text(
                  valueMap['feed_batch'].toString() + ", " + valueMap['feed_kind'] + ", Storage " + valueMap['feed_storage'].toString(),
                ),
              );
            }).toList(),
          ),
        ),
        warningList["selectedBatchWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please fill an article",
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
  
  _buildFeedBatchStorageForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Batch",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Storage",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
                        child: Text(_currentSelectedBatch == null ? "" : _currentSelectedBatch.toString()),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Flexible(
                flex: 1,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
                        child: Text(_currentSelectedStorage == null ? "" : _currentSelectedStorage.toString()),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
        ]
    );
  }

  _buildFeedKindForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Kind of Feed",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[100],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 12.5),
                  child: Text(_currentSelectedKind == null ? "" : _currentSelectedKind),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
        ]
    );
  }
  
  _buildFeedAmountForm(){
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
                  warningList["feedAmountWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["feedAmountWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                feedAmount = int.parse(value);
              });
            },
          ),
          warningList["feedAmountWarning"] == true ? Container(
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
                                  "Feed",
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
