import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/globalidentifier_generator.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/observationscreenheader.dart';

class WaterHomeScreen extends StatefulWidget {
  @override
  _WaterHomeScreenState createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen> {


  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;
  List<Map<String, dynamic>> waterInspectionList;

  bool farmSiteLoaded = false;
  bool waterLoaded = false;

  DateTime selectedDateTime = DateTime.now();

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

    _getWaterUsesSelectedDate();
  }

  _getWaterUsesSelectedDate() async {
    setState(() {
      waterLoaded = false;
    });

    List<Map<String, dynamic>> waterFromDB = await DatabaseHelper.instance.getWhere(
        'observed_water_uses',
        [
          'observed_water_uses_mln_id',
          'observed_water_uses_measurement_date'
        ],
        [
          management_location['_management_location_id'],
          DateFormat('yyyy-MM-dd').format(selectedDateTime)
        ]
    );

    List<Map<String, dynamic>> waterDate = List<Map<String, dynamic>>();

    waterDate.addAll(waterFromDB);

    Future.delayed(Duration(milliseconds: 250), (){
      setState(() {
        setState(() {
          waterInspectionList = waterDate;
          waterLoaded = true;
        });
      });
    });

  }

  _buildHouseInformationCard(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              farmSiteLoaded == true ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "House : " + user['_animal_location_id'].toString(),
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
//                                  "Round Nr. : 3",
                                  "Round Nr. : " + management_location['round']['round_nr'].toString(),
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
//                                  "Dist. Date : 7-10-2019",
                                  "Dist. Date : " + management_location['management_location_date_start'],
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
//                                  "Number : 21821",
                                  "Number : " + management_location['animal_count'].toString(),
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
//                                  "Day : 293",
                                  "Day : " + ((DateTime.now().difference(DateTime.parse(management_location['management_location_date_start']))).inDays + 1).toString(),
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
            ],
          ),
        ),
      ),
    );
  }

  _buildWaterDateSelector(){
    return Container(
      height: 57.5,
//      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: MediaQuery.of(context).size.height / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 100),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.25,
                          blurRadius: 1,
                          offset: Offset(0, 1.5)
                      )
                    ]
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  iconSize: 30,
                  onPressed: () async {
                    Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);

                    setState(() {
                      selectedDateTime = selectedDateTime.add(Duration(days: -1));
                      _getWaterUsesSelectedDate();
                    });

                    Navigator.pop(context);
                  },
                ),
              )
          ),
          Flexible(
              flex: 4,
              child: Container(
                child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                        onTap: (){
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2030),
                          ).then((date) {
                            print(date);
                            if(date != null){
                              Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);

                              setState((){
                                selectedDateTime = date;
                                _getWaterUsesSelectedDate();
                              });

                              Navigator.pop(context);
                            }
                          });
                        },
                        title: Center(
                          child: Text(
                            DateFormat('dd MMMM yyyy').format(selectedDateTime),
                          ),
                        )
                    )
                ),
              )
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 100),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.25,
                        blurRadius: 1,
                        offset: Offset(0, 1.5)
                    )
                  ]
              ),
              child: IconButton(
                icon: Icon(Icons.chevron_right),
                iconSize: 30,
                onPressed: (){
                  Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);

                  setState(() {
                    selectedDateTime = selectedDateTime.add(Duration(days: 1));
                    _getWaterUsesSelectedDate();
                  });

                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildWaterCopyPrevious(){
    if(waterLoaded == true && waterInspectionList.length < 1){
      return Container(
        height: 57.5,
//      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: MediaQuery.of(context).size.height / 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                flex: 1,
                child: Container(
                  child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                          onTap: (){
                            _getPreviousObservation();
                          },
                          title: Center(
                            child: Text(
                              "Copy Previous",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                      )
                  ),
                )
            ),
          ],
        ),
      );
    } else {
      return Container();
    }

  }

  _buildWaterInspectionCards(){
    if(waterLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    } else if(waterLoaded == true){
      if(waterInspectionList.length == 0){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 25),
                child: Text("No data found")),
          ],
        );
      } else if(waterInspectionList.length > 0){
        return Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: waterInspectionList.length,
              itemBuilder: (BuildContext context, int index){
                Map dailyObserve = waterInspectionList[index];
                return Dismissible(
                  key: Key(dailyObserve['_observed_water_uses_id']),
                  onDismissed: (direction) async {

                    String url = "water/delete";

                    Map<String, dynamic> params = {
                      "water_id": dailyObserve['_observed_water_uses_id'],
                      "user_name" : user['user_name']
                    };

                    dynamic responseJSON = await postData(params, url);

                    int deletedCount = await DatabaseHelper.instance.deleteWhere('observed_water_uses', ['_observed_water_uses_id'], [dailyObserve['_observed_water_uses_id']]);
                    print(deletedCount);

                    setState(() {
                      waterInspectionList.removeAt(index);
                    });
                  },
                  background: Container(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        onTap: (){
                          Navigator.pushNamed(context, "/dailyobservewaterneweditscreen", arguments: {
                            'observationId': dailyObserve['_observed_water_uses_id'],
                            'amountWater': dailyObserve['observed_water_uses_amount'],
                            'selectedDateTime' : DateTime.parse(dailyObserve['observed_water_uses_measurement_date'])
                          }).then((reload) => _getFarmSiteInformation());
                        },
                        title: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/dailyobservewaterneweditscreen", arguments: {
                              'observationId': dailyObserve['_observed_water_uses_id'],
                              'amountWater': dailyObserve['observed_water_uses_amount'],
                              'selectedDateTime' : DateTime.parse(dailyObserve['observed_water_uses_measurement_date'])
                            }).then((reload) => _getFarmSiteInformation());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Amount : ${dailyObserve['observed_water_uses_amount']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  _getPreviousObservation() async {

    if(waterInspectionList.length < 1){
      Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);

      List<Map<String, dynamic>> waterDate = await DatabaseHelper.instance.getWhere(
          'observed_water_uses',
          [
            'observed_water_uses_mln_id',
            'observed_water_uses_measurement_date'
          ],
          [
            management_location['_management_location_id'],
            DateFormat('yyyy-MM-dd').format(selectedDateTime.add(Duration(days: -1)))
          ]
      );

      if(waterDate.length != 0){
        Map<String, dynamic> previousWaterDate = waterDate[0];

        List<Map<String, dynamic>> water_uses = await DatabaseHelper.instance.get('observed_water_uses');

//      int water_id = water_uses.length > 0 ? water_uses[water_uses.length - 1]['_observed_water_uses_id'] + 1 : 1;
        String water_id = generate_GlobalIdentifier();
        String management_location_id = management_location['_management_location_id'];
        String measurement_date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
        String creation_date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        int water_amount = previousWaterDate['observed_water_uses_amount'];
        String water_unit = previousWaterDate['observed_water_uses_unit'];
        String user_name =  user['user_name'];

        int id = await DatabaseHelper.instance.insert('observed_water_uses', {
          DatabaseHelper.observed_water_uses_id: water_id,
          DatabaseHelper.observed_water_uses_mln_id: management_location_id,
          DatabaseHelper.observed_water_uses_measurement_date : measurement_date,
          DatabaseHelper.observed_water_uses_creation_date : creation_date,
          DatabaseHelper.observed_water_uses_amount : water_amount,
          DatabaseHelper.observed_water_uses_unit : water_unit,
          DatabaseHelper.observed_water_uses_creation_date : creation_date,
          DatabaseHelper.observed_water_uses_observed_by : user_name
        });

        String url = "water/insert";

        Map<String, dynamic> params = {
          "water_id": water_id,
          "management_location_id" : management_location_id,
          "measurement_date" : measurement_date,
          "amount": water_amount,
          "unit": water_unit,
          "user_name": user_name
        };

        dynamic responseJSON = await postData(params, url);

        if(responseJSON['status'] == 'Success'){
          Navigator.pop(context);
        }
        _getWaterUsesSelectedDate();
      } else {
        Navigator.pop(context);
        await Dialogs.errorRetryDialog(context, "No previous observation has been found", "Close", true);
      }

    } else {
      await Dialogs.errorRetryDialog(context, "Inspection round has reached the limit", "Close", true);
    }

  }

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
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
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
//                                Row(
//                                  children: <Widget>[
//                                    Container(
//                                      padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
//                                      child: Text(
//                                        "Daily Observations",
//                                        style: TextStyle(
//                                            fontFamily: "Montserrat",
//                                            fontSize: 20,
//                                            fontWeight: FontWeight.bold
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                                _buildHouseInformationCard(),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                                      child: Text(
                                        "Water",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildWaterDateSelector(),
                                _buildWaterCopyPrevious(),
                                _buildWaterInspectionCards(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: waterLoaded == true && waterInspectionList.length < 1 ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(253, 184, 19, 1),
        focusColor: Colors.white,
        onPressed: ()async {
          if(waterInspectionList.length < 1){
            Navigator.pushNamed(context, "/dailyobservewaterneweditscreen", arguments: {
              'inspectionRound': 1,
              'selectedDateTime' : selectedDateTime
            }).then((reload) => _getFarmSiteInformation());
          } else {
            await Dialogs.errorRetryDialog(context, "Inspection round has reached the limit", "Close", true);
          }
        },
      ) : null,
    );
  }
}
