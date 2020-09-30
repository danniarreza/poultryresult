import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class DashboardDetailScreen extends StatefulWidget {
  @override
  _DashboardDetailScreenState createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {

  List<charts.Series<TemperatureSeries, int>> _seriesTemperatureData = List<charts.Series<TemperatureSeries, int>>();
  List<charts.Series<HumiditySeries, int>> _seriesHumidityData = List<charts.Series<HumiditySeries, int>>();
  List<charts.Series<CO2Series, int>> _seriesCO2Data = List<charts.Series<CO2Series, int>>();
  bool includePrevRoundTemperature = false;
  bool includePrevRoundHumidity = false;

  double mortalityRatio = 0;
  double waterFeedRatio = 0;
  double feedChickenRatio = 0;

  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> selected_management_location;
//  Map<String, dynamic> temp_management_location;
  List<Map<String, dynamic>> management_locations;

  bool farmSiteLoaded = false;
  bool mortalityLoaded = false;
  bool chartsLoaded = false;

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _getManagementLocations();
  }

  _populateChart(Map<String, dynamic> new_management_location) async {

    _seriesTemperatureData = List<charts.Series<TemperatureSeries, int>>();
    _seriesHumidityData = List<charts.Series<HumiditySeries, int>>();
    _seriesCO2Data = List<charts.Series<CO2Series, int>>();

//   ------------------------------ Get Climates ------------------------------

    List<Map<String, dynamic>> climatesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_climate',
        [
          'observed_climate_mln_id'
        ],
        [
          new_management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> climatesData = List<Map<String, dynamic>>();

    climatesData.addAll(climatesFromDB);
    climatesData.sort((a, b) => a['observed_climate_measurement_date'].toString().compareTo(b['observed_climate_measurement_date'].toString()));

//    ----------------------------- Prepare Climates --------------------------

    List<TemperatureSeries> lineTemperatureData = List<TemperatureSeries>();
    List<HumiditySeries> lineHumidityData = List<HumiditySeries>();
    List<CO2Series> lineCO2Data = List<CO2Series>();

    int daysCount = DateTime.now().difference(DateTime.parse(new_management_location['management_location_date_start'])).inDays + 1;

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(new_management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      climatesData.forEach((element) {
        if(measurementDate.contains(element['observed_climate_measurement_date'])){
          matchingData.add(element);
        }
      });

      //    ---------------------- Populate Temperature ----------------------

      double totalTempReading = 0;
      double avgTempReading = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          totalTempReading = totalTempReading + element['observed_climate_temperature'];
        });

        avgTempReading = totalTempReading / matchingData.length;
      }

      lineTemperatureData.add(TemperatureSeries(i, avgTempReading, measurementDate));

      //    ----------------------- Populate Humidity -----------------------

      double totalHumidityReading = 0;
      double avgHumidityReading = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          totalHumidityReading = totalHumidityReading + element['observed_climate_rh'];
        });

        avgHumidityReading = totalHumidityReading / matchingData.length;
      }

      lineHumidityData.add(HumiditySeries(i, avgHumidityReading, measurementDate));

      //    ----------------------- Populate CO2 -----------------------

      double totalCO2Reading = 0;
      double avgHCO2Reading = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          totalCO2Reading = totalCO2Reading + element['observed_climate_co2'];
        });

        avgHCO2Reading = totalCO2Reading / matchingData.length;
      }

      lineCO2Data.add(CO2Series(i, avgHCO2Reading, measurementDate));
    }

    _seriesTemperatureData.add(
        charts.Series(
            domainFn: (TemperatureSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (TemperatureSeries mS, _) {
              return mS.temperatureReading;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.orange);
            },
            id: "Inside",
            data: lineTemperatureData
        )
    );

    _seriesHumidityData.add(
        charts.Series(
            domainFn: (HumiditySeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (HumiditySeries mS, _) {
              return mS.humidityReading;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.lightBlue);
            },
            id: "HumidityKPI",
            data: lineHumidityData
        )
    );

    _seriesCO2Data.add(
        charts.Series(
            domainFn: (CO2Series mS, _) {
              return mS.dayObservation;
            },
            measureFn: (CO2Series mS, _) {
              return mS.co2Reading;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.brown);
            },
            id: "CO2 KPI",
            data: lineCO2Data
        )
    );

    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        chartsLoaded = true;
      });
    });

  }


  _getManagementLocations() async {
    setState(() {
      chartsLoaded = false;
    });

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

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          user = users[0];
          farm_site = farm_sites[0];
          management_locations = new_management_locations;
//          selected_management_location = new_management_locations[0];
        });

        _getManagementLocationInformation(new_management_locations[0]);
      });

    });

  }


  _getManagementLocationInformation(Map<String, dynamic> management_location) async {

    Map<String, dynamic> new_management_location = management_location;

    List<Map<String, dynamic>> animal_locations = await DatabaseHelper.instance.getWhere(
        'animal_location',
        ['_animal_location_id'],
        [new_management_location['management_location_animal_location_id']]
    );

    Map<String, dynamic> animal_location = animal_locations[0];

    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getWhere(
        'round',
        ['_round_id'],
        [new_management_location['management_location_round_id']]
    );

    Map<String, dynamic> round = rounds[0];

//    ------------------------------------------------------------------------------------------------

    List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getWhere(
        'observed_animal_count', ['observed_animal_counts_mln_id'], [management_location['_management_location_id']]
    );

    int animal_count = 0;

    observedanimalcounts.forEach((observedanimalcount) {
      animal_count = animal_count + observedanimalcount['observed_animal_counts_animals_in'] - observedanimalcount['observed_animal_counts_animals_out'];
    });

    new_management_location = {
      ...new_management_location,
      'animal_count' : animal_count,
      'animal_location' : animal_location,
      'round' : round,
    };

//    ------------------------------------------------------------------------------------------------

    int mortalities_sum = await _getMortalitiesSelectedManagementLocation(new_management_location);
    double mortalities_ratio = mortalities_sum / animal_count;

//    ------------------------------------------------------------------------------------------------

    int water_sum = await _getWaterSelectedManagementLocation(new_management_location);
    int feed_sum = await _getFeedSelectedManagementLocation(new_management_location);

    double water_feed_ratio = water_sum / feed_sum;

//    ------------------------------------------------------------------------------------------------

    double feed_chicken_ratio = feed_sum / (animal_count - mortalities_sum);

//    ------------------------------------------------------------------------------------------------

    int selectedIndex = management_locations.indexOf(management_location);

    setState(() {
      selected_management_location = management_locations[selectedIndex];
      mortalityRatio = mortalities_ratio;
      waterFeedRatio = water_feed_ratio;
      feedChickenRatio = feed_chicken_ratio;
      farmSiteLoaded = true;

      _populateChart(management_locations[selectedIndex]);
    });

  }

  Future _getMortalitiesSelectedManagementLocation(Map<String, dynamic> management_location) async {

    List<Map<String, dynamic>> mortalitiesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_mortality',
        [
          'observed_mortality_mln_id'
        ],
        [
          management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> mortalitiesDate = List<Map<String, dynamic>>();

    mortalitiesDate.addAll(mortalitiesFromDB);

    int sum = 0;

    mortalitiesDate.forEach((element) {
      sum = sum + element['observed_mortality_animals_dead'] + element['observed_mortality_animals_selection'];
    });

    return sum;

  }

  Future _getWaterSelectedManagementLocation(Map<String, dynamic> management_location) async {

    List<Map<String, dynamic>> waterUsesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_water_uses',
        [
          'observed_water_uses_mln_id'
        ],
        [
          management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> waterUsesDate = List<Map<String, dynamic>>();

    waterUsesDate.addAll(waterUsesFromDB);

    int sum = 0;

    waterUsesDate.forEach((element) {
      sum = sum + element['observed_water_uses_amount'];
    });

    return sum;

  }

  Future _getFeedSelectedManagementLocation(Map<String, dynamic> management_location) async {

    List<Map<String, dynamic>> observedInputUsesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_input_uses',
        [
          'observed_input_uses_mln_id',
          'observed_input_uses_oue_type'
        ],
        [
          management_location['_management_location_id'],
          'Feed'
        ]
    );

    List<Map<String, dynamic>> observedInputUses = List<Map<String, dynamic>>();

    observedInputUses.addAll(observedInputUsesFromDB);

    int sum = 0;

    observedInputUses.forEach((element) {
      sum = sum + element['observed_input_uses_total_amount'];
    });

    return sum;

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
                      "House : " + selected_management_location['animal_location']['_animal_location_id'].toString(),
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
                                  "Round Nr. : " + selected_management_location['round']['round_nr'].toString(),
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
                                  "Dist. Date : " + selected_management_location['management_location_date_start'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  )
                              ),

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
                                  "Number : " + selected_management_location['animal_count'].toString(),
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
                                  "Day : " + ((DateTime.now().difference(DateTime.parse(selected_management_location['management_location_date_start']))).inDays + 1).toString(),
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
              SizedBox(height: 20,),
              Text(
                "KPI Measurements : ",
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
                            !mortalityRatio.isNaN ?
                            "Mortality % : " + mortalityRatio.toStringAsFixed(5) :
                            "Mortality % : 0",
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
                            !waterFeedRatio.isNaN ?
                            "Water/Feed : " + waterFeedRatio.toStringAsFixed(5) :
                            "Water/Feed : 0",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Feed/Chicken : ",
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
                            !feedChickenRatio.isNaN ?
                            feedChickenRatio.toStringAsFixed(5) :
                            "0",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
//              Text(
//                "Manual Observations",
//                style: TextStyle(
//                    color: Colors.black,
//                    fontFamily: "Montserrat",
//                    fontSize: 16,
//                    fontWeight: FontWeight.w600
//                ),
//              ),
//              Container(
//                height: 0.25,
//                margin: EdgeInsets.symmetric(vertical: 10),
//                color: Colors.grey,
//              ),
//              _buildMenuButtons(),
            ],
          ),
        ),
      ),
    );
  }

  _buildMenuButtons(){
    if (farmSiteLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    }
    else if(farmSiteLoaded == true){
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3)
                            )
                          ]
                      ),
                      child: IconButton(
                          color: Colors.white,
                          iconSize: 40,
                          icon: Icon(Icons.ac_unit),
                          onPressed: (){
                            DatabaseHelper.instance.update('user', {
                              DatabaseHelper.user_id : 1,
                              DatabaseHelper.user_location_id: selected_management_location['animal_location']['_animal_location_id'],
                              DatabaseHelper.user_management_location_id: selected_management_location['_management_location_id']
                            });

                            Navigator.pushNamed(context, "/climatehomescreen").then((reload) => _getManagementLocationInformation(selected_management_location));
                          }
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Climate",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      );
    }
  }

  _buildHouseClimateDashboard(){
    if (chartsLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    } else if(chartsLoaded == true){
      return Column(
        children: <Widget>[
          Container(
            height: 350,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "House Temperature",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Flexible(
                          flex: 5,
                          child: charts.LineChart(
                            _seriesTemperatureData,
                            defaultRenderer: charts.LineRendererConfig(
//                                                          includeArea: true,
//                                                          includePoints: true,
//                                                          stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                  <charts.TickSpec<int>>[
                                    charts.TickSpec(0),
                                    charts.TickSpec(25),
                                    charts.TickSpec(50),
                                    charts.TickSpec(75),
                                    charts.TickSpec(100),
                                  ]
                              ),
//                                            tickProviderSpec: charts.BasicNumericTickProviderSpec(
//                                              dataIsInWholeNumbers: true,
//                                              desiredTickCount: 3
//                                            ),
                            ),
                            behaviors: [
                              charts.SeriesLegend(),
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "\u00B0 Celcius",
                                  behaviorPosition: charts.BehaviorPosition.start,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Include previous round ?"),
                                Switch(
                                  activeColor: Color.fromRGBO(253, 184, 19, 1),
                                  inactiveTrackColor: Colors.grey,
                                  value: includePrevRoundTemperature,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundTemperature = true;
                                      } else {
                                        includePrevRoundTemperature = false;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 300,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Humidity",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Flexible(
                          flex: 5,
                          child: charts.LineChart(
                            _seriesHumidityData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
//                                                          includePoints: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                  <charts.TickSpec<int>>[
                                    charts.TickSpec(25),
                                    charts.TickSpec(50),
                                    charts.TickSpec(75),
                                    charts.TickSpec(100),
                                  ]
                              ),
//                                            tickProviderSpec: charts.BasicNumericTickProviderSpec(
//                                              dataIsInWholeNumbers: true,
//                                              desiredTickCount: 3
//                                            ),
                            ),
                            behaviors: [
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "%",
                                  behaviorPosition: charts.BehaviorPosition.start,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Include previous round ?"),
                                Switch(
                                  activeColor: Color.fromRGBO(253, 184, 19, 1),
                                  inactiveTrackColor: Colors.grey,
                                  value: includePrevRoundHumidity,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundHumidity = true;
                                      } else {
                                        includePrevRoundHumidity = false;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 300,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "CO2",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Flexible(
                          flex: 5,
                          child: charts.LineChart(
                            _seriesCO2Data,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
//                                                          includePoints: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                  <charts.TickSpec<int>>[
                                    charts.TickSpec(25),
                                    charts.TickSpec(50),
                                    charts.TickSpec(75),
                                    charts.TickSpec(100),
                                  ]
                              ),
//                                            tickProviderSpec: charts.BasicNumericTickProviderSpec(
//                                              dataIsInWholeNumbers: true,
//                                              desiredTickCount: 3
//                                            ),
                            ),
                            behaviors: [
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "%",
                                  behaviorPosition: charts.BehaviorPosition.start,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Include previous round ?"),
                                Switch(
                                  activeColor: Color.fromRGBO(253, 184, 19, 1),
                                  inactiveTrackColor: Colors.grey,
                                  value: includePrevRoundHumidity,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundHumidity = true;
                                      } else {
                                        includePrevRoundHumidity = false;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

//  _buildCurrentHouseSelector(){
//    return Container(
//      height: 57.5,
//      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Flexible(
//              flex: 1,
//              child: Container(
//                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 100),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(15),
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                          color: Colors.grey.withOpacity(0.5),
//                          spreadRadius: 0.25,
//                          blurRadius: 1,
//                          offset: Offset(0, 1.5)
//                      )
//                    ]
//                ),
//                child: IconButton(
//                  icon: Icon(Icons.chevron_left),
//                  iconSize: 30,
//                  onPressed: () async {
//                    Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);
//
////                    setState(() {
////                      selectedDateTime = selectedDateTime.add(Duration(days: -1));
////                      _getClimateSelectedDate();
////                    });
//
//                    Navigator.pop(context);
//                  },
//                ),
//              )
//          ),
//          Flexible(
//              flex: 4,
//              child: Container(
//                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 100, vertical: MediaQuery.of(context).size.width / 75),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(15),
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                          color: Colors.grey.withOpacity(0.5),
//                          spreadRadius: 0.25,
//                          blurRadius: 1,
//                          offset: Offset(0, 1.5)
//                      )
//                    ]
//                ),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        farmSiteLoaded ? Text(
//                          "House " + user['_animal_location_id'].toString(),
//                          style: TextStyle(
//                              color: Colors.black,
//                              fontFamily: "Montserrat",
//                              fontSize: 14,
//                              fontWeight: FontWeight.w500
//                          )
//                        ) : Container(),
//                      ],
//                    ),
//                  ],
//                ),
//              )
//          ),
//          Flexible(
//            flex: 1,
//            child: Container(
//              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 100),
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(15),
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                        color: Colors.grey.withOpacity(0.5),
//                        spreadRadius: 0.25,
//                        blurRadius: 1,
//                        offset: Offset(0, 1.5)
//                    )
//                  ]
//              ),
//              child: IconButton(
//                icon: Icon(Icons.chevron_right),
//                iconSize: 30,
//                onPressed: (){
//                  Dialogs.waitingDialog(context, "Fetching...", "Please Wait", false);
//
////                  setState(() {
////                    selectedDateTime = selectedDateTime.add(Duration(days: 1));
////                    _getClimateSelectedDate();
////                  });
//
//                  Navigator.pop(context);
//                },
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  _buildCurrentHouseSelector(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              child: farmSiteLoaded == true && management_locations.length > 0 ? DropdownButtonFormField<Map>(
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
                value: selected_management_location,
                isDense: true,
                onChanged: (Map newValue) {
                  _getManagementLocationInformation(newValue);
//                  setState(() {
//                    selected_management_location = newValue;
//                  });
                },
                items: management_locations.map((Map valueMap) {
                  return DropdownMenuItem<Map>(
                    value: valueMap,
                    child: Text(
                        valueMap['animal_location']['animal_location_code']
//                  valueMap['feed_batch'].toString() + ", " + valueMap['feed_kind'] + ", Storage " + valueMap['feed_storage'].toString(),
                    ),
                  );
                }).toList(),
              ) : SpinKitThreeBounce(
                  color: Color.fromRGBO(253, 184, 19, 1),
                  size: 30
              ),
            ),
          ),
        ],
      ),
    );
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
                                  padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                                  child: Text(
                                    "Dashboard",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _buildCurrentHouseSelector(),
                            _buildHouseInformationCard(),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                  child: Text(
                                    "House Climate",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _buildHouseClimateDashboard(),
                          ],
                        ),
                      ),
                    )
                )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.tune),
        backgroundColor: Theme.of(context).primaryColor,
        focusColor: Colors.white,
        onPressed: () async {
          DatabaseHelper.instance.update('user', {
            DatabaseHelper.user_id : 1,
            DatabaseHelper.user_location_id: selected_management_location['animal_location']['_animal_location_id'],
            DatabaseHelper.user_management_location_id: selected_management_location['_management_location_id']
          });

          Navigator.pushNamed(context, "/climatehomescreen").then((reload) => _getManagementLocationInformation(selected_management_location));
        },
      ),
    );
  }
}

class MortalitySeries{
  double mortalityPercentage;
  int dayObservation;

  MortalitySeries(this.dayObservation, this.mortalityPercentage);
}

class WeightSeries{
  double weightValue;
  int dayObservation;

  WeightSeries(this.dayObservation, this.weightValue);
}

class FeedSeries{
  double feedValue;
  int dayObservation;

  FeedSeries(this.dayObservation, this.feedValue);
}

class WaterAnimalSeries{
  double waterValue;
  int dayObservation;

  WaterAnimalSeries(this.dayObservation, this.waterValue);
}

class TemperatureSeries{

  int dayObservation;
  double temperatureReading;
  String measurementDate;

  TemperatureSeries(this.dayObservation, this.temperatureReading, this.measurementDate);
}

class HumiditySeries{
  double humidityReading;
  int dayObservation;
  String measurementDate;

  HumiditySeries(this.dayObservation, this.humidityReading, this.measurementDate);
}

class CO2Series{
  double co2Reading;
  int dayObservation;
  String measurementDate;

  CO2Series(this.dayObservation, this.co2Reading, this.measurementDate);
}