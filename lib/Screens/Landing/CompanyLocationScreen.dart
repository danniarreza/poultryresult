import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Services/NotificationPlugin.dart';
import 'package:sqflite/sqflite.dart';

class CompanyLocationScreen extends StatefulWidget {
  @override
  _CompanyLocationScreenState createState() => _CompanyLocationScreenState();
}

class _CompanyLocationScreenState extends State<CompanyLocationScreen> {

  String farmSiteSelected;
  String user_name;
  String user_fullname;
  bool warningRaised = false;
  List<Map> companyLocationsJSON = [];
  bool companyLocationsLoaded = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return NotificationScreen(
//        payload: payload,
//      );
//    }));
  }

  @override
  void initState() {
    // TODO: implement setState
    super.initState();

//    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
//    notificationPlugin.setOnNotificationClick(onNotificationClick);

    notificationPlugin.showDailyAtTime();

    _getUserSession();
    _getFarmSites();
  }

  _getUserSession() async {
    String tableName = 'user';
    List<Map<String, dynamic>> rows = await DatabaseHelper.instance.getById(tableName, 1);
//    print(rows);
    setState(() {
      user_name = rows[0]['user_name'];
      user_fullname = rows[0]['user_fullname'];
    });
  }

  _getFarmSites() async {

    _getLocations();
    _getRounds();
    _getManagementLocations();
    _getObservedAnimalCounts();
    _getMortalities();
    _getWaterUses();
    _getWeights();
    _getInputTypes();
    _getInputUses();
    _getEggProduction();
    _getObservedClimate();

    List<Map<String, dynamic>> rows = await DatabaseHelper.instance.get('farm_sites');

    if(rows.length > 0){
      await DatabaseHelper.instance.delete('farm_sites');
    }

    String url = "farmsite/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('farm_sites', {
        DatabaseHelper.farm_sites_id : row['farm_sites_id'],
        DatabaseHelper.farm_sites_fst_type : row['fst_type'],
        DatabaseHelper.farm_sites_name : row['name'],
        DatabaseHelper.farm_sites_date_start : row['date_start'],
        DatabaseHelper.farm_sites_date_end : row['date_end'],
        DatabaseHelper.farm_sites_timezone : row['timezone']
      });
    });

    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.get('farm_sites');
    setState(() {
      companyLocationsJSON = farm_sites;
      companyLocationsLoaded = true;
    });

//    notificationPlugin.showNotification('Welcome to PoultryResult!', 'Please select the farm site');
  }


  _getLocations() async {
    List<Map<String, dynamic>> locations = await DatabaseHelper.instance.get('animal_location');

    if(locations.length > 0){
      await DatabaseHelper.instance.delete('animal_location');
    }

    String url = "animallocation/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('animal_location', {
        DatabaseHelper.animal_location_id: row['location_id'],
        DatabaseHelper.animal_location_code: row['code'],
        DatabaseHelper.animal_location_fst_id: row['farm_site']['farm_sites_id'],
        DatabaseHelper.animal_location_lcn_type: row['farm_site']['fst_type'],
        DatabaseHelper.animal_location_date_start : row['date_start'],
        DatabaseHelper.animal_location_date_end : row['date_end']
      });
    });

    locations = await DatabaseHelper.instance.get('animal_location');

//    print(locations);
  }

  _getRounds() async {
    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.get('round');

    if(rounds.length > 0){
      await DatabaseHelper.instance.delete('round');
    }

    String url = "round/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('round', {
        DatabaseHelper.round_id: row['round_id'],
        DatabaseHelper.round_fst_id: row['farm_site']['farm_sites_id'],
        DatabaseHelper.round_nr: row['nr'],
        DatabaseHelper.round_date_start : row['date_start'],
        DatabaseHelper.round_date_end : row['date_end']
      });
    });

    rounds = await DatabaseHelper.instance.get('round');

//    print(rounds);
  }

  _getManagementLocations() async {
    List<Map<String, dynamic>> management_locations = await DatabaseHelper.instance.get('management_location');

    if(management_locations.length > 0){
      await DatabaseHelper.instance.delete('management_location');
    }

    String url = "managementlocation/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

//    print(responseJSON);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('management_location', {
        DatabaseHelper.management_location_id: row['management_location_id'],
        DatabaseHelper.management_location_animal_location_id: row['location']['location_id'],
        DatabaseHelper.management_location_round_id: row['round']['round_id'],
        DatabaseHelper.management_location_code : row['code'],
        DatabaseHelper.management_location_date_start : row['date_start'],
        DatabaseHelper.management_location_date_end : row['date_end']
      });
    });

//    management_locations = await DatabaseHelper.instance.get('management_location');

//    print(management_locations);
  }

  _getObservedAnimalCounts() async {
    List<Map<String, dynamic>> observed_animal_counts = await DatabaseHelper.instance.get('observed_animal_count');

    if(observed_animal_counts.length > 0){
      await DatabaseHelper.instance.delete('observed_animal_count');
    }

    String url = "observedanimalcount/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_animal_count', {
        DatabaseHelper.observed_animal_counts_id: row['animal_count_id'],
        DatabaseHelper.observed_animal_counts_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_animal_counts_measurement_date: row['measurement_date'],
        DatabaseHelper.observed_animal_counts_animals_in : row['animals_in'],
        DatabaseHelper.observed_animal_counts_animals_out : row['animals_out'],
        DatabaseHelper.observed_animal_counts_creation_date : row['measurement_date']
      });
    });

//    observed_animal_counts = await DatabaseHelper.instance.get('observed_animal_count');

//    print(management_locations);
  }

  _getMortalities() async {
    List<Map<String, dynamic>> observed_mortalities = await DatabaseHelper.instance.get('observed_mortality');

    if(observed_mortalities.length > 0){
      await DatabaseHelper.instance.delete('observed_mortality');
    }

    String url = "mortality/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_mortality', {
        DatabaseHelper.observed_mortality_id: row['mortality_id'],
        DatabaseHelper.observed_mortality_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_mortality_observation_nr: row['observation_nr'],
        DatabaseHelper.observed_mortality_measurement_date : row['measurement_date'],
        DatabaseHelper.observed_mortality_animals_dead : row['animals_dead'],
        DatabaseHelper.observed_mortality_animals_selection : row['animals_culling'],
        DatabaseHelper.observed_mortality_remark : row['remark'],
        DatabaseHelper.observed_mortality_observed_by : row['user']['user_name']
      });
    });

//    observed_mortalities = await DatabaseHelper.instance.get('observed_mortality');

//    print(management_locations);
  }

  _getWaterUses() async {
    List<Map<String, dynamic>> observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

    if(observed_water_uses.length > 0){
      await DatabaseHelper.instance.delete('observed_water_uses');
    }

    String url = "water/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_water_uses', {
        DatabaseHelper.observed_water_uses_id: row['water_id'],
        DatabaseHelper.observed_water_uses_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_water_uses_measurement_date : row['measurement_date'],
        DatabaseHelper.observed_water_uses_amount: row['amount'],
        DatabaseHelper.observed_water_uses_unit : row['unit'],
        DatabaseHelper.observed_water_uses_observed_by : row['user']['user_name'],
      });
    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _getWeights() async {
    List<Map<String, dynamic>> observed_weights = await DatabaseHelper.instance.get('observed_weight');

    if(observed_weights.length > 0){
      await DatabaseHelper.instance.delete('observed_weight');
    }

    String url = "weight/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_weight', {
        DatabaseHelper.observed_weight_id: row['weight_id'],
        DatabaseHelper.observed_weight_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_weight_measurement_date : row['measurement_date'],
        DatabaseHelper.observed_weight_weights: row['weight'],
        DatabaseHelper.observed_weight_unit : row['unit'],
        DatabaseHelper.observed_weight_observed_by : row['user']['user_name'],
      });
    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _getInputTypes() async {
    List<Map<String, dynamic>> input_types = await DatabaseHelper.instance.get('input_types');

    if(input_types.length > 0){
      await DatabaseHelper.instance.delete('input_types');
    }

    String url = "inputtypes/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('input_types', {
        DatabaseHelper.input_types_id: row['input_type_id'],
        DatabaseHelper.input_types_fse_id: row['farm_site']['farm_sites_id'],
        DatabaseHelper.input_types_ite_type: row['ite_type'],
        DatabaseHelper.input_types_code : row['code'],
        DatabaseHelper.input_types_description: row['description'],
        DatabaseHelper.input_types_uom : row['uom'],
        DatabaseHelper.input_types_active : row['active'] ? 1 : 0
      });
    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _getInputUses() async {
    List<Map<String, dynamic>> observed_input_uses = await DatabaseHelper.instance.get('observed_input_uses');

    if(observed_input_uses.length > 0){
      await DatabaseHelper.instance.delete('observed_input_uses');
      await DatabaseHelper.instance.delete('observed_input_types');
    }

    String url = "observedinputuses/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

//    print(responseJSON);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_input_uses', {
        DatabaseHelper.observed_input_uses_id: row['input_use_id'],
        DatabaseHelper.observed_input_uses_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_input_uses_oue_type : row['oue_type'],
        DatabaseHelper.observed_input_uses_measurement_date: row['measurement_date'],
        DatabaseHelper.observed_input_uses_treatment_nr : row['treatment_nr'],
        DatabaseHelper.observed_input_uses_total_amount : row['total_amount'],
        DatabaseHelper.observed_input_uses_unit : row['unit'],
        DatabaseHelper.observed_input_uses_creation_date: row['createdDate'],
        DatabaseHelper.observed_input_uses_mutation_date : row['changedDate'],
        DatabaseHelper.observed_input_uses_observed_by : row['user']['user_name'],
      });

      if(row['observed_input_type'].length > 0){
        row['observed_input_type'].forEach((oit) async {
          await DatabaseHelper.instance.insert('observed_input_types', {
            DatabaseHelper.observed_input_types_id: oit['observed_input_type_id'],
            DatabaseHelper.observed_input_types_ite_id: oit['input_type']['input_type_id'],
            DatabaseHelper.observed_input_types_oue_id : row['input_use_id'],
            DatabaseHelper.observed_input_types_amount: oit['amount'],
            DatabaseHelper.observed_input_types_creation_date : oit['createdDate'],
            DatabaseHelper.observed_input_types_mutation_date : oit['changedDate']
          });
        });
      }
    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _getEggProduction() async {
    List<Map<String, dynamic>> observed_input_uses = await DatabaseHelper.instance.get('observed_egg_production');

    if(observed_input_uses.length > 0){
      await DatabaseHelper.instance.delete('observed_egg_production');
    }

    String url = "eggproduction/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

//    print(responseJSON);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_egg_production', {
        DatabaseHelper.observed_egg_production_id: row['observed_egg_production_id'],
        DatabaseHelper.observed_egg_production_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_egg_production_measurement_date : row['measurement_date'],
        DatabaseHelper.observed_egg_production_first_quality: row['first_quality'],
        DatabaseHelper.observed_egg_production_second_quality : row['second_quality'],
        DatabaseHelper.observed_egg_production_ground_eggs : row['ground_eggs'],
        DatabaseHelper.observed_egg_production_egg_weight : row['egg_weight'],
        DatabaseHelper.observed_egg_production_weight_unit : 'kg',
        DatabaseHelper.observed_egg_production_creation_date: row['createdDate'],
        DatabaseHelper.observed_egg_production_mutation_date : row['changedDate'],
        DatabaseHelper.observed_egg_production_observed_by : row['user']['user_name'],
      });


    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _getObservedClimate() async {
    List<Map<String, dynamic>> observed_climates = await DatabaseHelper.instance.get('observed_climate');

    if(observed_climates.length > 0){
      await DatabaseHelper.instance.delete('observed_climate');
    }

    String url = "observedclimate/get_all";
    Map<String, dynamic> params = {

    };

    List<dynamic> responseJSON = await postData(params, url);

//    print(responseJSON);

    responseJSON.forEach((row) async {
      await DatabaseHelper.instance.insert('observed_climate', {
        DatabaseHelper.observed_climate_id: row['climate_id'],
        DatabaseHelper.observed_climate_mln_id: row['management_location']['management_location_id'],
        DatabaseHelper.observed_climate_measurement_date : row['measurement_date'],
        DatabaseHelper.observed_climate_measurement_nr: row['measurement_nr'],
        DatabaseHelper.observed_climate_temperature : row['temperature'],
        DatabaseHelper.observed_climate_temperature_unit : row['temperature_unit'],
        DatabaseHelper.observed_climate_rh : row['rh'],
        DatabaseHelper.observed_climate_co2 : row['co2'],
        DatabaseHelper.observed_climate_co2_unit : row['co2_unit'],
        DatabaseHelper.observed_climate_creation_date: row['createdDate'],
        DatabaseHelper.observed_climate_mutation_date : row['changedDate'],
        DatabaseHelper.observed_climate_observed_by : row['user']['user_name'],
      });


    });

//    observed_water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//    print(observed_water_uses);
  }

  _deleteUserSession() async {
    String tableName = 'user';
    int rowsAffected = await DatabaseHelper.instance.delete(tableName);

    tableName = 'animal_location';
    rowsAffected = await DatabaseHelper.instance.delete(tableName);
    return rowsAffected;
  }

  _buildWelcomeLogo(){
    return Image(
      image: AssetImage('assets/images/farmresult-logo.png'),
    );
  }

  _buildWelcomeText(){
    return Text(
      "Welcome, \n $user_fullname",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width / 12.5,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold
      ),
    );
  }

  _buildCompanyLocationsLabel(){
    return GestureDetector(
      onTap: (){
//        print(farmSiteSelected);
      },
      child: Text(
        warningRaised == true ? "Please Select Farm Site Location" : "Select Farm Site Location",
        style: warningRaised == true
            ? TextStyle(color: Colors.red, fontFamily: "Montserrat", fontWeight: FontWeight.w500)
            : TextStyle(color: Colors.black, fontFamily: "Montserrat", fontWeight: FontWeight.w500)  ,
      )
    );
  }

  _buildCompanyLocationsDropdown(){
    if(companyLocationsLoaded == true){
      return(
        Column(
          children: <Widget>[
            Text(
              warningRaised == true ? "Please Select Farm Site Location" : "Select Farm Site Location",
              style: warningRaised == true
                  ? TextStyle(color: Colors.red, fontFamily: "Montserrat", fontWeight: FontWeight.w500)
                  : TextStyle(color: Colors.black, fontFamily: "Montserrat", fontWeight: FontWeight.w500)  ,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            isDense: true,
                            hint: Text("Select Location"),
                            value: farmSiteSelected,
                            onChanged: (String newValue){
                              setState(() {
                                farmSiteSelected = newValue;
                              });

//                              print(farmSiteSelected);
                            },
                            items: companyLocationsJSON.map((Map location) {
                              return DropdownMenuItem<String>(
                                value: location["_farm_sites_id"].toString(),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      child: Text(location["_farm_sites_id"].toString()),
                                    ),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                      child: Text(location["farm_sites_name"]),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                      ),
                    )
                ),
              ],
            )
          ],
        )
      );
    } else if(companyLocationsLoaded == false){
      return(
          SpinKitThreeBounce(
              color: Color.fromRGBO(253, 184, 19, 1),
              size: 30
          )
      );
    }
  }

  _buildSelectButton(){
    return GestureDetector(
      onTap: (){
        if(farmSiteSelected != null){
          setState(() {
            warningRaised = false;
            selectLocation();
          });
        } else {
          setState(() {
            warningRaised = true;
          });
        }

      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          shadowColor: Colors.blueAccent,
          color: Theme.of(context).primaryColor,
          elevation: 2.0,
          child: Center(
            child: Text(
              "GO",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectLocation() async {
//    print("Selected: " + farmSiteSelected);
    Dialogs.waitingDialog(context, "Fetching Data...", "Please Wait", false);

    DatabaseHelper.instance.update('user', {
      DatabaseHelper.user_id : 1,
      DatabaseHelper.user_farm_sites_id : farmSiteSelected
    });

    Future.delayed(Duration(seconds: 1), (){
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/dailyobservehomescreen');
    });

  }

  _buildLogOutButton(){
    return GestureDetector(
      onTap: () async {
        _deleteUserSession();
        Navigator.pushReplacementNamed(context, "/loginscreen");

      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
              width: 1.0
            ),
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
          ),
          child: Center(
            child: Text("Log Out"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          color: Colors.white,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//              _buildWelcomeLogo(),
//              SizedBox(height: 125),
                _buildWelcomeText(),
                SizedBox(height: 50),
                _buildCompanyLocationsDropdown(),
                SizedBox(height: 50,),
                _buildSelectButton(),
                SizedBox(height: 25,),
                _buildLogOutButton(),
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
