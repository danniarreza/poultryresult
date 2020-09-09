import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class PicturesNewEditScreen extends StatefulWidget {
  @override
  _PicturesNewEditScreenState createState() => _PicturesNewEditScreenState();
}

class _PicturesNewEditScreenState extends State<PicturesNewEditScreen> {

  DateTime _selectedDateTime = DateTime.now();
  File imageFile;
  String imageBase64;
  
  double pictureBoxHeight = 250.0;

  Map<dynamic, bool> warningList = {
    "amountPicturesWarning" : false,
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
                _buildPicturesForm(),
                SizedBox(height: 10,),
                Center(child: imageBase64 != null && imageBase64 != "" ?
                  Text(imageBase64) :
                  GestureDetector(
                    onTap: () async {
                      print(base64Encode(imageFile.readAsBytesSync()));
//                      String base64 = await base64Encode(imageFile.readAsBytesSync());
//                      setState(() {
//                        imageBase64 = base64;
//                      });
                    },
                    child: Text("No Image")
                  )
                ),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPicturesForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Picture",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              _showPicturesDialog(context);
            },
            child: imageFile != null ? Container(
              height: pictureBoxHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.grey[600],
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Image.file(imageFile, width: 400, height: 400,),
              ),
            ) : Container(
              height: pictureBoxHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.grey[600],
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
          warningList["amountPicturesWarning"] == true ? Container(
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

  Future<void> _showPicturesDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: (){
                      _openGallery();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: (){
                      _openCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _openGallery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      Navigator.of(context).pop();
    });
  }

  _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
//      print(imageFile);
      Navigator.of(context).pop();
    });
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
                                  "Pictures",
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
