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

class FeedHomeScreen extends StatefulWidget {
  @override
  _FeedHomeScreenState createState() => _FeedHomeScreenState();
}

class _FeedHomeScreenState extends State<FeedHomeScreen> {

  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;
  List<Map<String, dynamic>> inputUsesInspectionList;

  bool farmSiteLoaded = false;
  bool inputUsesLoaded = false;

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


    _getFeedSelectedDate();
  }

  _getFeedSelectedDate() async {
    setState(() {
      inputUsesLoaded = false;
    });

    List<Map<String, dynamic>> observedInputUses = List<Map<String, dynamic>>();

    List<Map<String, dynamic>> observedInputUsesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_input_uses',
        [
          'observed_input_uses_mln_id',
          'observed_input_uses_measurement_date',
          'observed_input_uses_oue_type'
        ],
        [
          management_location['_management_location_id'],
          DateFormat('yyyy-MM-dd').format(selectedDateTime),
          'Feed'
        ]
    );

    observedInputUsesFromDB.forEach((oiu) async {
      Map<String, dynamic> observedInputUse = Map<String, dynamic>();
      List<Map<String, dynamic>> observedInputTypes = List<Map<String, dynamic>>();
      List<Map<String, dynamic>> observedInputTypesFromDB = await DatabaseHelper.instance.getWhere(
          'observed_input_types', ['observed_input_types_oue_id'], [oiu['_observed_input_uses_id']]
      );

      observedInputTypesFromDB.forEach((oit) async {
        Map<String, dynamic> observedInputType = Map<String, dynamic>();
        Map<String, dynamic> inputType = Map<String, dynamic>();
        List<Map<String, dynamic>> inputTypesFromDB = await DatabaseHelper.instance.getById('input_types', oit['observed_input_types_ite_id']);

        inputType = inputTypesFromDB[0];

        observedInputType = {
          ...oit,
          'input_type' : inputType
        };

        observedInputTypes.add(observedInputType);

        observedInputUse = {
          ...oiu,
          'observed_input_types' : observedInputTypes
        };

        observedInputUses.add(observedInputUse);

//        print(observedInputUses);

      });
    });

    Future.delayed(Duration(milliseconds: 250), (){
      setState(() {
        inputUsesInspectionList = observedInputUses;
        inputUsesLoaded = true;
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

  _buildFeedDateSelector(){
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
                      _getFeedSelectedDate();
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
                                _getFeedSelectedDate();
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
                    _getFeedSelectedDate();
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

  _buildFeedCopyPrevious(){
    if(inputUsesLoaded == true && inputUsesInspectionList.length < 1){
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

  _buildFeedInspectionCards(){
    if(inputUsesLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    } else if(inputUsesLoaded == true){
      if(inputUsesInspectionList.length == 0){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 25),
                child: Text("No data found")),
          ],
        );
      } else if(inputUsesInspectionList.length > 0){
        return Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: inputUsesInspectionList.length,
              itemBuilder: (BuildContext context, int index){
                Map dailyObserve = inputUsesInspectionList[index];
                return Dismissible(
                  key: Key(dailyObserve['_observed_input_uses_id']),
                  onDismissed: (direction) async {

                    String url = "observedinputuses/delete";

                    Map<String, dynamic> params = {
                      "observed_input_use_id": dailyObserve['_observed_input_uses_id'],
                      "user_name" : user['user_name']
                    };

                    dynamic responseJSON = await postData(params, url);

                    dailyObserve['observed_input_types'].forEach((element) async {
                      await DatabaseHelper.instance.deleteWhere('observed_input_types', ['_observed_input_types_id'], [element['_observed_input_types_id']]);
                    });

                    int deletedCount = await DatabaseHelper.instance.deleteWhere('observed_input_uses', ['_observed_input_uses_id'], [dailyObserve['_observed_input_uses_id']]);
                    print(deletedCount);

                    setState(() {
                      inputUsesInspectionList.removeAt(index);
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
                          Navigator.pushNamed(context, "/dailyobservefeedneweditscreen", arguments: {
                            'observedInputUsesId' : dailyObserve['_observed_input_uses_id'],
                            'observedInputTypesId' : dailyObserve['observed_input_types'][0]['_observed_input_types_id'],
                            'inspectionRound': dailyObserve['observed_input_uses_treatment_nr'],
                            'selectedDateTime' : selectedDateTime,
                            'feedAmount' : dailyObserve['observed_input_uses_total_amount'],
                            'selectedInputType': dailyObserve['observed_input_types'][0]['input_type']
                          }).then((reload) => _getFarmSiteInformation());
                        },
                        title: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/dailyobservefeedneweditscreen", arguments: {
                              'observedInputUsesId' : dailyObserve['_observed_input_uses_id'],
                              'observedInputTypesId' : dailyObserve['observed_input_types'][0]['_observed_input_types_id'],
                              'inspectionRound': dailyObserve['observed_input_uses_treatment_nr'],
                              'selectedDateTime' : selectedDateTime,
                              'feedAmount' : dailyObserve['observed_input_uses_total_amount'],
                              'selectedInputType': dailyObserve['observed_input_types'][0]['input_type']
                            }).then((reload) => _getFarmSiteInformation());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Treatment : " + dailyObserve['observed_input_uses_treatment_nr'].toString(),
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
                                            dailyObserve['observed_input_types'].length > 0 ?
                                            "Feed : " + dailyObserve['observed_input_types'][0]['input_type']['input_types_code'] :
                                            "Feed : empty",
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
                                            "Amount : " + dailyObserve['observed_input_uses_total_amount'].toString(),
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
                                            "Measurement :",
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
                                            dailyObserve['observed_input_uses_unit'] != null ?
                                            dailyObserve['observed_input_uses_unit'] :
                                            dailyObserve['observed_input_types'][0]['input_type']['input_types_uom'],
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

    Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);

    int treatment_nr = 0;
    List<Map<String, dynamic>> observedInputUses = List<Map<String, dynamic>>();

    List<Map<String, dynamic>> observedInputUsesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_input_uses',
        [
          'observed_input_uses_mln_id',
          'observed_input_uses_measurement_date',
          'observed_input_uses_oue_type'
        ],
        [
          management_location['_management_location_id'],
          DateFormat('yyyy-MM-dd').format(selectedDateTime.add(Duration(days: -1))),
          'Feed'
        ]
    );

//    List<Map<String, dynamic>> observed_input_uses = await DatabaseHelper.instance.get('observed_input_uses');
//    int new_observed_input_uses_id = observed_input_uses[observed_input_uses.length - 1]['_observed_input_uses_id'];

//    List<Map<String, dynamic>> observed_input_types = await DatabaseHelper.instance.get('observed_input_types');
//    int new_observed_input_types_id = observed_input_types[observed_input_types.length - 1]['_observed_input_types_id'];


//    print(observedInputUsesFromDB);

    observedInputUsesFromDB.forEach((oiu) async {
      Map<String, dynamic> observedInputUse = Map<String, dynamic>();
      List<Map<String, dynamic>> observedInputTypes = List<Map<String, dynamic>>();

      List<Map<String, dynamic>> observedInputTypesFromDB = await DatabaseHelper.instance.getWhere(
          'observed_input_types', ['observed_input_types_oue_id'], [oiu['_observed_input_uses_id']]
      );

      observedInputTypesFromDB.forEach((oit) async {
        Map<String, dynamic> observedInputType = Map<String, dynamic>();
        Map<String, dynamic> inputType = Map<String, dynamic>();
        List<Map<String, dynamic>> inputTypesFromDB = await DatabaseHelper.instance.getById('input_types', oit['observed_input_types_ite_id']);

        inputType = inputTypesFromDB[0];

        observedInputType = {
          ...oit,
          'input_type' : inputType
        };

        observedInputTypes.add(observedInputType);

        observedInputUse = {
          ...oiu,
          'observed_input_types' : observedInputTypes
        };

        // ----------------------------------------------------------------------

        String management_location_id = management_location['_management_location_id'];
        String measurement_date = DateFormat('yyyy-MM-dd').format(selectedDateTime);
        String creation_date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        treatment_nr = treatment_nr + 1;
        int feed_amount = oit['observed_input_types_amount'];
        String oue_type = "Feed";
        String input_types_id = inputType['_input_types_id'].toString();
        String unit_of_measurement = inputType['input_types_uom'];
        String user_name =  user['user_name'];

//        observedInputUses.add(observedInputUse);

//        print("management_location_id "+ management_location_id.toString());
//        print("measurement_date "+ measurement_date);
//        print("creation_date "+creation_date);
//        print("treatment_nr "+ treatment_nr.toString());
//        print("feed_amount "+ feed_amount.toString());
//        print("oue_type "+ oue_type);
//        print("input_types_id "+ input_types_id.toString());
//        print("unit_of_measurement "+unit_of_measurement);
//        print("user_name "+ user_name);
//        print("----------------------------------------------------------------------");

        String new_observed_input_uses_id = generate_GlobalIdentifier();
        String new_observed_input_types_id = generate_GlobalIdentifier();

        int inserted_observed_input_uses_id = await DatabaseHelper.instance.insert('observed_input_uses', {
          DatabaseHelper.observed_input_uses_id: new_observed_input_uses_id,
          DatabaseHelper.observed_input_uses_mln_id: management_location_id,
          DatabaseHelper.observed_input_uses_oue_type : oue_type,
          DatabaseHelper.observed_input_uses_measurement_date: measurement_date,
          DatabaseHelper.observed_input_uses_treatment_nr : treatment_nr,
          DatabaseHelper.observed_input_uses_total_amount : feed_amount,
          DatabaseHelper.observed_input_uses_unit : unit_of_measurement,
          DatabaseHelper.observed_input_uses_creation_date: creation_date,
          DatabaseHelper.observed_input_uses_mutation_date : creation_date,
          DatabaseHelper.observed_input_uses_observed_by : user_name,
        });

        await DatabaseHelper.instance.insert('observed_input_types', {
          DatabaseHelper.observed_input_types_id: new_observed_input_types_id,
          DatabaseHelper.observed_input_types_ite_id: input_types_id,
          DatabaseHelper.observed_input_types_oue_id : new_observed_input_uses_id,
          DatabaseHelper.observed_input_types_amount: feed_amount,
          DatabaseHelper.observed_input_types_creation_date : creation_date,
          DatabaseHelper.observed_input_types_mutation_date : creation_date
        });

        String url = "observedinputuses/insert";

        Map<String, dynamic> params = {
          "observed_input_use_id": new_observed_input_uses_id,
          "management_location_id": management_location_id,
          "oue_type" : oue_type,
          "measurement_date" : measurement_date,
          "total_amount": feed_amount,
          "unit": unit_of_measurement,
          "user_name": user_name
        };

        dynamic responseJSON = await postData(params, url);

        if(responseJSON['status'] == 'Success') {
          String url = "observedinputtypes/insert";

          Map<String, dynamic> params = {
            "observed_input_type_id": new_observed_input_types_id,
            "amount": feed_amount,
            "observed_input_uses_id": new_observed_input_uses_id,
            "input_type_id": input_types_id,
          };

          dynamic responseJSON = await postData(params, url);
        };


      });

    });

    Future.delayed(Duration(seconds: 2), (){
      Navigator.pop(context);
      _getFeedSelectedDate();
    });
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
                                _buildFeedDateSelector(),
                                _buildFeedCopyPrevious(),
                                _buildFeedInspectionCards(),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(253, 184, 19, 1),
        focusColor: Colors.white,
        onPressed: ()async{
          Navigator.pushNamed(context, "/dailyobservefeedneweditscreen", arguments: {
            'inspectionRound': inputUsesInspectionList.length + 1,
            'selectedDateTime' : selectedDateTime,
          }).then((reload) => _getFarmSiteInformation());
        },
      ),
    );
  }
}
