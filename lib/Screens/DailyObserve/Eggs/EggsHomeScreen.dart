import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/observationscreenheader.dart';

class EggsHomeScreen extends StatefulWidget {
  @override
  _EggsHomeScreenState createState() => _EggsHomeScreenState();
}

class _EggsHomeScreenState extends State<EggsHomeScreen> {
  List<Map> eggsInspectionList = [
    {
      "egg_quality": "1st Quality",
      "egg_amount": 5,
      "egg_weight": 60,
      "egg_weight_measurement": "grams/egg"
    },
    {
      "egg_quality": "2nd Quality",
      "egg_amount": 10,
      "egg_weight": 60,
      "egg_weight_measurement": "grams/egg"
    },
    {
      "egg_quality": "Ground Eggs",
      "egg_amount": 5,
      "egg_weight": 60,
      "egg_weight_measurement": "grams/egg"
    },
  ];

  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;

  bool farmSiteLoaded = false;
  bool eggsLoaded = false;

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

    _getEggsSelectedDate();

  }

  _getEggsSelectedDate() async {
    setState(() {
      eggsLoaded = false;
    });

    print(management_location['_management_location_id']);
    print(DateFormat('yyyy-MM-dd').format(selectedDateTime));

    List<Map<String, dynamic>> eggsFromDB = await DatabaseHelper.instance.getWhere(
        'observed_egg_production',
        [
          'observed_egg_production_mln_id',
          'observed_egg_production_measurement_date'
        ],
        [
          management_location['_management_location_id'],
          DateFormat('yyyy-MM-dd').format(selectedDateTime)
        ]
    );

    List<Map<String, dynamic>> eggsDate = List<Map<String, dynamic>>();

    eggsDate.addAll(eggsFromDB);

    Future.delayed(Duration(milliseconds: 250), (){
      setState(() {
        setState(() {
          eggsInspectionList = eggsDate;
          eggsLoaded = true;
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

  _buildEggsDateSelector(){
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
                      _getEggsSelectedDate();
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
                                _getEggsSelectedDate();
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
                    _getEggsSelectedDate();
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

  _buildEggProductionCards(){
    if(eggsLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    } else if(eggsLoaded == true){
      if(eggsInspectionList.length == 0){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 25),
                child: Text("No data found")),
          ],
        );
      } else if(eggsInspectionList.length > 0){
        return Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: eggsInspectionList.length,
              itemBuilder: (BuildContext context, int index){
                Map dailyObserve = eggsInspectionList[index];
                return Dismissible(
                  key: Key(dailyObserve['_observed_egg_production_id']),
                  onDismissed: (direction) async {

                    String url = "eggproduction/delete";

                    Map<String, dynamic> params = {
                      "observed_egg_production_id": dailyObserve['_observed_egg_production_id'],
                      "user_name" : user['user_name']
                    };

                    dynamic responseJSON = await postData(params, url);
                    int deletedCount = await DatabaseHelper.instance.deleteWhere('observed_egg_production', ['_observed_egg_production_id'], [dailyObserve['_observed_egg_production_id']]);
                    print(deletedCount);

                    setState(() {
                      eggsInspectionList.removeAt(index);
                    });
                  },
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
                          Navigator.pushNamed(context, "/dailyobserveeggsneweditscreen", arguments: {
                            'observationId': dailyObserve['_observed_egg_production_id'],
                            'amountFirstQuality': dailyObserve['observed_egg_production_first_quality'],
                            'amountSecondQuality' : dailyObserve['observed_egg_production_second_quality'],
                            'amountGroundEggs': dailyObserve['observed_egg_production_ground_eggs'],
                            'eggWeight': dailyObserve['observed_egg_production_egg_weight'],
                            'weightUnit': dailyObserve['observed_egg_production_weight_unit'],
                            'selectedDateTime' : DateTime.parse(dailyObserve['observed_egg_production_measurement_date'])
                          }).then((reload) => _getFarmSiteInformation());
                        },
                        title: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/dailyobserveeggsneweditscreen", arguments: {
                              'observationId': dailyObserve['_observed_egg_production_id'],
                              'amountFirstQuality': dailyObserve['observed_egg_production_first_quality'],
                              'amountSecondQuality' : dailyObserve['observed_egg_production_second_quality'],
                              'amountGroundEggs': dailyObserve['observed_egg_production_ground_eggs'],
                              'eggWeight': dailyObserve['observed_egg_production_egg_weight'],
                              'weightUnit': dailyObserve['observed_egg_production_weight_unit'],
                              'selectedDateTime' : DateTime.parse(dailyObserve['observed_egg_production_measurement_date'])
                            }).then((reload) => _getFarmSiteInformation());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Egg Production : ",
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
                              Text(
                                  "First Quality : " + dailyObserve['observed_egg_production_first_quality'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              Container(
                                height: 0.25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey[400],
                              ),
                              Text(
                                  "Second Quality : " + dailyObserve['observed_egg_production_second_quality'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              Container(
                                height: 0.25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey[400],
                              ),
                              Text(
                                  "Ground Eggs : " + dailyObserve['observed_egg_production_ground_eggs'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              Container(
                                height: 0.25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey[400],
                              ),
                              Text(
                                  "Egg Weight : " + dailyObserve['observed_egg_production_egg_weight'].toString() + ' ' + dailyObserve['observed_egg_production_weight_unit'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  )
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
                                _buildEggsDateSelector(),
                                _buildEggProductionCards(),
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
      floatingActionButton: eggsLoaded == true && eggsInspectionList.length < 1 ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(253, 184, 19, 1),
        focusColor: Colors.white,
        onPressed: () async {
          if(eggsInspectionList.length < 1){
            Navigator.pushNamed(context, "/dailyobserveeggsneweditscreen", arguments: {
              'inspectionRound': eggsInspectionList.length + 1,
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
