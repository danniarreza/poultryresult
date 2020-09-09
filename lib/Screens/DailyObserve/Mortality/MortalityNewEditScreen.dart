import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:intl/intl.dart';

class MortalityNewEditScreen extends StatefulWidget {
  @override
  _MortalityNewEditScreenState createState() => _MortalityNewEditScreenState();
}

class _MortalityNewEditScreenState extends State<MortalityNewEditScreen> {

  bool isNew;
  
  DateTime selectedDateTime;
  int observationId;
  int inspectionRound;
  int amountCulling;
  int amountDeath;
  String inputRemark = "";

  Map<String, dynamic> routeData = {};
  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;

  bool farmSiteLoaded = false;

  Map<dynamic, bool> warningList = {
    "amountCullingWarning" : false,
    "amountDeathWarning" : false,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _getFarmSiteInformation();

  }

  _getFarmSiteInformation() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');
    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getById('farm_sites', users[0]['_farm_sites_id']);

    List<Map<String, dynamic>> management_locations = await DatabaseHelper.instance.getById('management_location', users[0]['_management_location_id']);
    List<Map<String, dynamic>> locations = await DatabaseHelper.instance.getById('location', management_locations[0]['management_location_location_id']);
    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getById('round', management_locations[0]['management_location_round_id']);

    List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getByReference('observed_animal_count', 'management_location', 'observed_animal_counts_aln_id', management_locations[0]['_management_location_id']);

    int animal_count = 0;

    observedanimalcounts.forEach((observedanimalcount) {
      animal_count = animal_count + observedanimalcount['observed_animal_counts_animals_in'] - observedanimalcount['observed_animal_counts_animals_out'];
    });

    Map<String, dynamic> new_management_location = Map<String, dynamic>();

    new_management_location = {
      ...management_locations[0],
      'animal_count' : animal_count,
      'location' : locations[0],
      'round' : rounds[0],

    };

    setState(() {
      user = users[0];
      farm_site = farm_sites[0];
      management_location = new_management_location;
      farmSiteLoaded = true;
    });
  }

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
                farmSiteLoaded == true ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Inspection Round : " + inspectionRound.toString(),
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
                                    "House : " + user['_location_id'].toString(),
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
                                    "Round Nr. : " + management_location['round']['round_nr'].toString(),
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
                                    DateFormat('dd MMMM yyyy').format(selectedDateTime),
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
                ) : SpinKitThreeBounce(
                    color: Color.fromRGBO(253, 184, 19, 1),
                    size: 30
                ),
                Container(
                  height: 0.25,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  color: Colors.grey,
                ),
                _buildCullingForm(),
                _buildDeathForm(),
                _buildRemarkForm(),
                SizedBox(height: 15,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCullingForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Culling",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.number,
            initialValue: amountCulling != null ? amountCulling.toString() : null,
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
                  warningList["amountCullingWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["amountCullingWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                amountCulling = int.parse(value);
              });
            },
          ),
          warningList["amountCullingWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please fill in amount of culling",
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

  _buildDeathForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Death",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.number,
            initialValue: amountDeath != null ? amountDeath.toString() : null,
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
            onSaved: (String value){
              setState(() {
                amountDeath = int.parse(value);
              });
            },
            validator: (String value) {
              if(value == null || value == ''){
                setState(() {
                  warningList["amountDeathWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["amountDeathWarning"] = false;
                });
                return null;
              }
            },
          ),
          warningList["amountDeathWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please fill in amount of death",
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

  _buildRemarkForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Remark",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            maxLines: 3,
            initialValue: inputRemark != null ? inputRemark : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Insert Remark",
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
            onSaved: (String value){
              setState(() {
                inputRemark = value;
              });
            },
          ),
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

    int management_location_id = management_location['_management_location_id'];
    String uu_id = "fiwnefwnf";
    String measurement_date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    int observationNr = inspectionRound;
    int animals_dead = amountDeath;
    int animals_culling = amountCulling;
    String remark = inputRemark;
    String user_name =  user['user_name'];

    if(isNew == true){
      List<Map<String, dynamic>> mortalities = await DatabaseHelper.instance.get('observed_mortality');
      int mortality_id = mortalities[mortalities.length - 1]['_observed_mortality_id'] + 1;

      print(mortality_id);
      print(animals_dead);
      print(animals_culling);

      int id = await DatabaseHelper.instance.insert('observed_mortality', {
        DatabaseHelper.observed_mortality_id: mortality_id,
        DatabaseHelper.observed_mortality_uu_id: uu_id,
        DatabaseHelper.observed_mortality_aln_id: management_location_id,
        DatabaseHelper.observed_mortality_observation_nr: observationNr,
        DatabaseHelper.observed_mortality_measurement_date : measurement_date,
        DatabaseHelper.observed_mortality_animals_dead : animals_dead,
        DatabaseHelper.observed_mortality_animals_selection : animals_culling,
        DatabaseHelper.observed_mortality_remark : remark,
        DatabaseHelper.observed_mortality_observed_by : user_name
      });

      String url = "mortality/insert";

      Map<String, dynamic> params = {
        "management_location_id" : management_location_id,
        "uu_id" : uu_id,
        "measurement_date" : measurement_date,
        "animals_dead": animals_dead,
        "animals_culling": animals_culling,
        "remark": remark,
        "user_name": user_name
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == 'Success'){
        Navigator.pop(context);
        Navigator.pop(context);
      }


    } else if(isNew == false){
      int mortality_id = observationId;
      await DatabaseHelper.instance.update('observed_mortality', {
        DatabaseHelper.observed_mortality_id: mortality_id,
        DatabaseHelper.observed_mortality_uu_id: uu_id,
        DatabaseHelper.observed_mortality_aln_id: management_location_id,
        DatabaseHelper.observed_mortality_observation_nr: observationNr,
        DatabaseHelper.observed_mortality_measurement_date : measurement_date,
        DatabaseHelper.observed_mortality_animals_dead : animals_dead,
        DatabaseHelper.observed_mortality_animals_selection : animals_culling,
        DatabaseHelper.observed_mortality_remark : remark,
        DatabaseHelper.observed_mortality_observed_by : user_name
      });

      String url = "mortality/update";

      Map<String, dynamic> params = {
        "mortality_id": mortality_id,
        "uu_id" : uu_id,
        "observation_nr" : observationNr,
        "measurement_date" : measurement_date,
        "animals_dead": animals_dead,
        "animals_culling": animals_culling,
        "remark": remark,
        "management_location_id" : management_location_id,
        "user_name": user_name
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == 'Success'){
        Navigator.pop(context);
        Navigator.pop(context);
      }
      
    }



  }

  @override
  Widget build(BuildContext context) {

    routeData = ModalRoute.of(context).settings.arguments;

    setState(() {
      routeData['observationId'] != null ? isNew = false : isNew = true;
      routeData['observationId'] != null ? observationId = routeData['observationId'] : null;
      routeData['amountDeath'] != null ? amountDeath = routeData['amountDeath'] : null;
      routeData['amountCulling'] != null ? amountCulling = routeData['amountCulling'] : null;
      routeData['inputRemark'] != null ? inputRemark = routeData['inputRemark'] : null;
      selectedDateTime = routeData['selectedDateTime'];
      inspectionRound = routeData['inspectionRound'];
    });

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
                                  "Mortality",
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
