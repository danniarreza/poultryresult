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

class WeightsNewEditScreen extends StatefulWidget {
  @override
  _WeightsNewEditScreenState createState() => _WeightsNewEditScreenState();
}

class _WeightsNewEditScreenState extends State<WeightsNewEditScreen> {

  bool isNew;
  
  DateTime selectedDateTime = DateTime.now();
  String observationId;
  int amountWeight;

  Map<String, dynamic> routeData = {};
  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;

  bool farmSiteLoaded = false;

  Map<dynamic, bool> warningList = {
    "amountWeightWarning" : false,
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
                _buildWeightsForm(),
                SizedBox(height: 10,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildWeightsForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Weights [gr]",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.number,
            initialValue: amountWeight != null ? amountWeight.toString() : null,
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
                  warningList["amountWeightWarning"] = true;
                });
                return null;
              } else {
                setState(() {
                  warningList["amountWeightWarning"] = false;
                });
                return null;
              }
            },
            onSaved: (String value){
              setState(() {
                amountWeight = int.parse(value);
              });
            },
          ),
          warningList["amountWeightWarning"] == true ? Container(
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
    String uu_id = "fiwnefwnf";
    String measurement_date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    String creation_date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    int weight_amount = amountWeight;
    String weight_unit = 'kg';
    String user_name =  user['user_name'];

    if(isNew == true){
//      List<Map<String, dynamic>> weights = await DatabaseHelper.instance.get('observed_weight');
//      int weight_id = weights.length > 0 ? weights[weights.length - 1]['_observed_weight_id'] + 1 : 1;

      String weight_id = generate_GlobalIdentifier();
      print(weight_id);

      int id = await DatabaseHelper.instance.insert('observed_weight', {
        DatabaseHelper.observed_weight_id: weight_id,
        DatabaseHelper.observed_weight_mln_id: management_location_id,
        DatabaseHelper.observed_weight_measurement_date : measurement_date,
        DatabaseHelper.observed_weight_creation_date : creation_date,
        DatabaseHelper.observed_weight_weights : weight_amount,
        DatabaseHelper.observed_weight_unit : weight_unit,
        DatabaseHelper.observed_weight_observed_by : user_name
      });

      String url = "weight/insert";

      Map<String, dynamic> params = {
        "weight_id": weight_id,
        "management_location_id" : management_location_id,
        "measurement_date" : measurement_date,
        "creation_date" : creation_date,
        "weight": weight_amount,
        "unit": weight_unit,
        "user_name": user_name
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == 'Success'){
        Navigator.pop(context);
        Navigator.pop(context);
      }


    } else if(isNew == false){
      String weight_id = observationId;
      await DatabaseHelper.instance.update('observed_weight', {
        DatabaseHelper.observed_weight_id: weight_id,
        DatabaseHelper.observed_weight_mln_id: management_location_id,
        DatabaseHelper.observed_weight_measurement_date : measurement_date,
        DatabaseHelper.observed_weight_weights : weight_amount,
        DatabaseHelper.observed_weight_unit : weight_unit,
        DatabaseHelper.observed_weight_observed_by : user_name
      });

      String url = "weight/update";

      Map<String, dynamic> params = {
        "weight_id": weight_id,
        "uu_id" : uu_id,
        "measurement_date" : measurement_date,
        "weight": weight_amount,
        "unit": weight_unit,
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
      routeData['amountWeight'] != null ? amountWeight = routeData['amountWeight'] : null;
      selectedDateTime = routeData['selectedDateTime'];
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
                                  "Weights",
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
