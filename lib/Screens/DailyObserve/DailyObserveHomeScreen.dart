import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poultryresult/Services/NotificationPlugin.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';

class DailyObserveHomeScreen extends StatefulWidget {
  @override
  _DailyObserveHomeScreenState createState() => _DailyObserveHomeScreenState();
}

class _DailyObserveHomeScreenState extends State<DailyObserveHomeScreen> {

  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;

//  List<dynamic> management_locations;
  List<Map<String, dynamic>> management_locations;

  bool management_locationsLoaded = false;
  bool farm_siteLoaded = false;

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
    // TODO: implement initState
    super.initState();

    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    _getFarmSiteLocations();
  }

  _getFarmSiteLocations() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');

    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getWhere('farm_sites', ['_farm_sites_id'], [users[0]['_farm_sites_id']]);

    List<Map<String, dynamic>> rounds_from_db = await DatabaseHelper.instance.getWhere(
        'round', ['round_fst_id'], [users[0]['_farm_sites_id']]
    );

    List<Map<String, dynamic>> new_management_locations = List<Map<String, dynamic>>();

    rounds_from_db.forEach((round) async {
      List<Map<String, dynamic>> management_locations_from_db = await DatabaseHelper.instance.getWhere(
          'management_location', ['management_location_round_id'], [round['_round_id']]
      );

      management_locations_from_db.forEach((management_location_from_db) async {
        List<Map<String, dynamic>> animal_locations = await DatabaseHelper.instance.getWhere('animal_location', ['_animal_location_id'], [management_location_from_db['management_location_animal_location_id']]);

        List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getWhere('round', ['_round_id'], [management_location_from_db['management_location_round_id']]);

        List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getWhere(
            'observed_animal_count', ['observed_animal_counts_mln_id'], [management_location_from_db['_management_location_id']]
        );


        int animal_count = 0;

        observedanimalcounts.forEach((observedanimalcount) {
          animal_count = animal_count + observedanimalcount['observed_animal_counts_animals_in'] - observedanimalcount['observed_animal_counts_animals_out'];
        });

        Map<String, dynamic> new_management_location = {
          ...management_location_from_db,
          'animal_count' : animal_count,
          'animal_location' : animal_locations[0],
          'round' : rounds[0],

        };

        new_management_locations.add(new_management_location);
//        print(new_management_locations);
      });

    });

    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        user = users[0];
        farm_site = farm_sites[0];
//      management_locations = responseJSON;
        management_locations = new_management_locations;
        farm_siteLoaded = true;
        management_locationsLoaded = true;
      });

//      notificationPlugin.showNotification('Welcome to ${farm_sites[0]['farm_sites_name']}!', 'Please select the farm house');
    });

  }

  _buildManagementLocationList(){
    if(management_locationsLoaded == false){
      return SpinKitThreeBounce(
          color: Color.fromRGBO(253, 184, 19, 1),
          size: 30
      );
    } else if (management_locationsLoaded == true){
      if(management_locations.length == 0){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No data found"),
          ],
        );
      } else {
        return ListView.builder(
          itemCount: management_locations.length,
          itemBuilder: (BuildContext context, int index){
            Map management_location = management_locations[index];
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  onTap: (){

                    DatabaseHelper.instance.update('user', {
                      DatabaseHelper.user_id : 1,
                      DatabaseHelper.user_location_id: management_location['animal_location']['_animal_location_id'],
                      DatabaseHelper.user_management_location_id: management_location['_management_location_id']
                    });

//                    print("Daily Observation Card from House ${management_location['animal_location']['_animal_location_id']} tapped!");
                    Navigator.pushNamed(context, "/dailyobservehousedetailscreen");
                  },
                  title: GestureDetector(
                    onTap: (){

                      DatabaseHelper.instance.update('user', {
                        DatabaseHelper.user_id : 1,
                        DatabaseHelper.user_location_id: management_location['animal_location']['_animal_location_id'],
                        DatabaseHelper.user_management_location_id: management_location['_management_location_id']
                      });

//                      print("Daily Observation Card from House ${management_location['animal_location']['_animal_location_id']} tapped!");
                      Navigator.pushNamed(context, "/dailyobservehousedetailscreen");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "House : ${management_location['animal_location']['animal_location_code']}",
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Round Nr. : ${management_location['round']['round_nr']}",
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
                                      "Dist. Date : ${management_location['management_location_date_start']}",
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
                                      "Number : ${management_location['animal_count']}",
//                                    "Number: 00",
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
                  ),
                ),
              ),
            );
          },
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                            child: Text(
                              "Daily Observations",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: _buildManagementLocationList(),
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
    );
  }
}
