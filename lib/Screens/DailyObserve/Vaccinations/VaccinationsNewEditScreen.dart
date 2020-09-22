import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/globalidentifier_generator.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/observationscreenheader.dart';

class VaccinationsNewEditScreen extends StatefulWidget {
  @override
  _VaccinationsNewEditScreenState createState() => _VaccinationsNewEditScreenState();
}

class _VaccinationsNewEditScreenState extends State<VaccinationsNewEditScreen> {
  bool isNew;

  String observedInputUsesId;
  String observedInputTypesId;
  int inspectionRound;
  int vaccinationAmount;

  DateTime selectedDateTime;
  String vaccinationArticle;

  Map<String, dynamic> routeData = {};
  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;
  Map<String, dynamic> selectedInputType;
  Map<String, dynamic> tempInputType;

  bool farmSiteLoaded = false;

  List<Map<String, dynamic>> inputTypes = List<Map<String, dynamic>>();


  Map<dynamic, bool> warningList = {
    "selectedInputTypeWarning" : false,
    "vaccinationAmountWarning" : false,
  };

//  String _currentSelectedMedicalConditions;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _getFarmSiteInformation();

  }

  _getFarmSiteInformation() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');
    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getWhere('farm_sites', ['_farm_sites_id'], [users[0]['_farm_sites_id']]);

    List<Map<String, dynamic>> management_locations = await DatabaseHelper.instance.getWhere('management_location', ['_management_location_id'], [users[0]['_management_location_id']]);

    List<Map<String, dynamic>> animal_locations = await DatabaseHelper.instance.getWhere('animal_location', ['_animal_location_id'], [management_locations[0]['management_location_animal_location_id']]);
    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getById('round', management_locations[0]['management_location_round_id']);

    List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getWhere(
        'observed_animal_count', ['observed_animal_counts_mln_id'], [management_locations[0]['_management_location_id']]
    );

    int animal_count = 0;

    observedanimalcounts.forEach((observedanimalcount) {
      animal_count = animal_count + observedanimalcount['observed_animal_counts_animals_in'] - observedanimalcount['observed_animal_counts_animals_out'];
    });

    Map<String, dynamic> new_management_location = Map<String, dynamic>();

    new_management_location = {
      ...management_locations[0],
      'animal_count' : animal_count,
      'location' : animal_locations[0],
      'round' : rounds[0],

    };

    List<Map<String, dynamic>> inputTypesFromDB = await DatabaseHelper.instance.getWhere('input_types', ['input_types_ite_type'], ['Medication']);

    List<Map<String, dynamic>> newInputTypes = List<Map<String, dynamic>>();

    Map<String, dynamic> initialInputType;

    inputTypesFromDB.forEach((element) {
      newInputTypes.add(element);

      tempInputType != null && element['_input_types_id'] == tempInputType['_input_types_id'] ? initialInputType = element : null;
    });

//    Map<String, dynamic> initialInputType = newInputTypes.firstWhere((inputType) => inputType['_input_types_id'] == tempInputType['_input_types_id']);
//    print(initialInputType);

    setState(() {
      user = users[0];
      farm_site = farm_sites[0];
      management_location = new_management_location;
      inputTypes = newInputTypes;
      selectedInputType = initialInputType;
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
                        "Addition Round : " + inspectionRound.toString(),
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
                                    "House : " + user['_animal_location_id'].toString(),
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
                _buildVaccinationArticleSelectionForm(),
                _buildVaccinationUnitOfMeasurementForm(),
                _buildVaccinationAmountForm(),
                SizedBox(height: 15,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildVaccinationArticleSelectionForm(){
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
          child: inputTypes.length > 0 ? DropdownButtonFormField<Map>(
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
            value: selectedInputType,
            isDense: true,
            onChanged: (Map newValue) {
              setState(() {
                selectedInputType = newValue;
                warningList["selectedInputTypeWarning"] = false;
              });
            },
            validator: (Map newValue){
              if(newValue == null){
                setState(() {
                  warningList["selectedInputTypeWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["selectedInputTypeWarning"] = false;
                });
                return null;
              }
            },
            items: inputTypes.map((Map valueMap) {
              return DropdownMenuItem<Map>(
                value: valueMap,
                child: Text(
                    valueMap['input_types_code']
                ),
              );
            }).toList(),
          ) : SpinKitThreeBounce(
              color: Color.fromRGBO(253, 184, 19, 1),
              size: 30
          ),
        ),
        warningList["selectedInputTypeWarning"] == true ? Container(
          padding: EdgeInsets.only(left: 5, top: 10),
          child: Text(
            "Please select an article",
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

  _buildVaccinationUnitOfMeasurementForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text(
                    "Unit",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    )
                ),
              ],
            ),
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
                  child: Text(selectedInputType != null ? selectedInputType['input_types_uom'] : ""),
                )
              ],
            ),
          ),
          warningList["selectedInputTypeWarning"] == true ? Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text(
              "Please select an article",
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

  _buildVaccinationAmountForm(){
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
            initialValue: vaccinationAmount != null ? vaccinationAmount.toString() : null,
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
                  warningList["vaccinationAmountWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["vaccinationAmountWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                vaccinationAmount = int.parse(value);
                warningList["vaccinationAmountWarning"] = value == "" || value == null ? true : false;
              });
            },
            onChanged: (String value){
              setState(() {
                vaccinationAmount = int.parse(value);
                warningList["vaccinationAmountWarning"] = value == "" || value == null ? true : false;
              });
            },
          ),
          warningList["vaccinationAmountWarning"] == true ? Container(
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

    String management_location_id = management_location['_management_location_id'];
    String measurement_date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    String creation_date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    int treatment_nr = inspectionRound;
    int vaccination_amount = vaccinationAmount;
    String oue_type = "Medication";
    String input_types_id = selectedInputType['_input_types_id'].toString();
    String unit_of_measurement = selectedInputType['input_types_uom'];
    String user_name =  user['user_name'];

//    print(isNew);

    if(isNew == true){
//      List<Map<String, dynamic>> observed_input_uses = await DatabaseHelper.instance.get('observed_input_uses');
//      int new_observed_input_uses_id = observed_input_uses[observed_input_uses.length - 1]['_observed_input_uses_id'] + 1;

      String new_observed_input_uses_id = generate_GlobalIdentifier();

//      print(selectedInputType);
//      print(vaccinationAmount);

      int inserted_observed_input_uses_id = await DatabaseHelper.instance.insert('observed_input_uses', {
        DatabaseHelper.observed_input_uses_id: new_observed_input_uses_id,
        DatabaseHelper.observed_input_uses_mln_id: management_location_id,
        DatabaseHelper.observed_input_uses_oue_type : oue_type,
        DatabaseHelper.observed_input_uses_measurement_date: measurement_date,
        DatabaseHelper.observed_input_uses_treatment_nr : treatment_nr,
        DatabaseHelper.observed_input_uses_total_amount : vaccination_amount,
        DatabaseHelper.observed_input_uses_unit : unit_of_measurement,
        DatabaseHelper.observed_input_uses_creation_date: creation_date,
        DatabaseHelper.observed_input_uses_mutation_date : creation_date,
        DatabaseHelper.observed_input_uses_observed_by : user_name,
      });

//      List<Map<String, dynamic>> observed_input_types = await DatabaseHelper.instance.get('observed_input_types');
//      int new_observed_input_types_id = observed_input_types[observed_input_types.length - 1]['_observed_input_types_id'] + 1;
      String new_observed_input_types_id = generate_GlobalIdentifier();

      await DatabaseHelper.instance.insert('observed_input_types', {
        DatabaseHelper.observed_input_types_id: new_observed_input_types_id,
        DatabaseHelper.observed_input_types_ite_id: input_types_id,
        DatabaseHelper.observed_input_types_oue_id : new_observed_input_uses_id,
        DatabaseHelper.observed_input_types_amount: vaccination_amount,
        DatabaseHelper.observed_input_types_creation_date : creation_date,
        DatabaseHelper.observed_input_types_mutation_date : creation_date
      });

      String url = "observedinputuses/insert";

      Map<String, dynamic> params = {
        "observed_input_use_id": new_observed_input_uses_id,
        "management_location_id": management_location_id,
        "oue_type" : oue_type,
        "measurement_date" : measurement_date,
        "total_amount": vaccination_amount,
        "unit": unit_of_measurement,
        "user_name": user_name
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == 'Success'){

        String url = "observedinputtypes/insert";

        Map<String, dynamic> params = {
          "observed_input_type_id": new_observed_input_types_id,
          "amount": vaccination_amount,
          "observed_input_uses_id" : new_observed_input_uses_id,
          "input_type_id" : input_types_id,
        };

        dynamic responseJSON = await postData(params, url);

        if(responseJSON['status'] == 'Success'){
          Navigator.pop(context);
          Navigator.pop(context);
        }

      }

    } else if(isNew == false){
      String new_observed_input_uses_id = observedInputUsesId;
      String new_observed_input_types_id = observedInputTypesId;

//      print(new_observed_input_uses_id);
//      print(new_observed_input_types_id);
//      print(vaccinationAmount);
//      print(input_types_id);

      await DatabaseHelper.instance.update('observed_input_uses', {
        DatabaseHelper.observed_input_uses_id: new_observed_input_uses_id,
        DatabaseHelper.observed_input_uses_mln_id: management_location_id,
        DatabaseHelper.observed_input_uses_oue_type : oue_type,
        DatabaseHelper.observed_input_uses_measurement_date: measurement_date,
        DatabaseHelper.observed_input_uses_treatment_nr : treatment_nr,
        DatabaseHelper.observed_input_uses_total_amount : vaccination_amount,
        DatabaseHelper.observed_input_uses_unit : unit_of_measurement,
        DatabaseHelper.observed_input_uses_mutation_date : creation_date,
        DatabaseHelper.observed_input_uses_observed_by : user_name,
      });

      await DatabaseHelper.instance.update('observed_input_types', {
        DatabaseHelper.observed_input_types_id: new_observed_input_types_id,
        DatabaseHelper.observed_input_types_ite_id: input_types_id,
        DatabaseHelper.observed_input_types_oue_id : new_observed_input_uses_id,
        DatabaseHelper.observed_input_types_amount: vaccination_amount,
        DatabaseHelper.observed_input_types_mutation_date : creation_date
      });

      String url = "observedinputuses/update";

      Map<String, dynamic> params = {
        "observed_input_use_id": new_observed_input_uses_id,
        "management_location_id": management_location_id,
        "oue_type" : oue_type,
        "measurement_date" : measurement_date,
        "total_amount": vaccination_amount,
        "unit": unit_of_measurement,
        "user_name": user_name
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == 'Success'){

        url = "observedinputtypes/update";


        Map<String, dynamic> params = {
          "observed_input_type_id": new_observed_input_types_id,
          "amount": vaccination_amount,
          "observed_input_uses_id" : new_observed_input_uses_id,
          "input_type_id" : input_types_id,
        };

        dynamic responseJSON = await postData(params, url);

        if(responseJSON['status'] == 'Success'){
          Navigator.pop(context);
          Navigator.pop(context);
        }

      }

    }

  }


  @override
  Widget build(BuildContext context) {

    routeData = ModalRoute.of(context).settings.arguments;

    setState(() {
      routeData['observedInputUsesId'] != null ? isNew = false : isNew = true;
      routeData['observedInputUsesId'] != null ? observedInputUsesId = routeData['observedInputUsesId'] : null;
      routeData['observedInputTypesId'] != null ? observedInputTypesId = routeData['observedInputTypesId'] : null;
      routeData['vaccinationAmount'] != null ? vaccinationAmount = routeData['vaccinationAmount'] : null;
      routeData['selectedInputType'] != null ? tempInputType = routeData['selectedInputType'] : null;
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
              ObservationScreenHeader(),
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
                                  "Vaccination",
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
