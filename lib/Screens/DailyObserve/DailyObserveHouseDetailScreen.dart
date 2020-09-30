import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';
import 'package:poultryresult/Widgets/Sidebar_Main.dart';

class DailyObserveHouseDetailScreen extends StatefulWidget {
  @override
  _DailyObserveHouseDetailScreenState createState() => _DailyObserveHouseDetailScreenState();
}

class _DailyObserveHouseDetailScreenState extends State<DailyObserveHouseDetailScreen> {

  List<Map> dailyObservationsList = [
    {
      "house_nr": 1,
      "round_nr": 3,
      "distribution_date": "7-10-2019",
      "day_count": 293,
      "chicken_count": 21821
    },
    {
      "house_nr": 2,
      "round_nr": 3,
      "distribution_date": "7-10-2019",
      "day_count": 293,
      "chicken_count": 24143
    }
  ];

  List<charts.Series<MortalitySeries, int>> _seriesMortalityData = List<charts.Series<MortalitySeries, int>>();
  List<charts.Series<WeightSeries, int>> _seriesWeightData = List<charts.Series<WeightSeries, int>>();
  List<charts.Series<FeedSeries, int>> _seriesFeedData = List<charts.Series<FeedSeries, int>>();
  List<charts.Series<WaterAnimalSeries, int>> _seriesWaterAnimalData = List<charts.Series<WaterAnimalSeries, int>>();
  List<charts.Series<AdditiveSeries, int>> _seriesAdditivesData = List<charts.Series<AdditiveSeries, int>>();
  List<charts.Series<VaccinesSeries, int>> _seriesVaccinesData = List<charts.Series<VaccinesSeries, int>>();
  List<charts.Series<EggsSeries, int>> _seriesEggsData = List<charts.Series<EggsSeries, int>>();

  bool includePrevRoundMortality = false;
  bool includePrevRoundWeight = false;
  bool includePrevRoundFeed = false;
  bool includePrevRoundWaterAnimal = false;
  bool includePrevRoundAdditives = false;
  bool includePrevRoundVaccines = false;

  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;

  bool farmSiteLoaded = false;
  bool chartsLoaded = false;

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _getFarmSiteInformation();

  }

  _getFarmSiteInformation() async {
    setState(() {
      chartsLoaded = false;
    });

    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');
    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getWhere('farm_sites', ['_farm_sites_id'], [users[0]['_farm_sites_id']]);

    List<Map<String, dynamic>> management_locations = await DatabaseHelper.instance.getWhere('management_location', ['_management_location_id'], [users[0]['_management_location_id']]);

    List<Map<String, dynamic>> animal_locations = await DatabaseHelper.instance.getWhere('animal_location', ['_animal_location_id'], [management_locations[0]['management_location_animal_location_id']]);
    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getWhere('round', ['_round_id'], [management_locations[0]['management_location_round_id']]);

    List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getWhere(
        'observed_animal_count', ['observed_animal_counts_mln_id'], [management_locations[0]['_management_location_id']]
    );

    int animal_count = 0;

    observedanimalcounts.forEach((observedanimalcount) {
      animal_count = animal_count + observedanimalcount['observed_animal_counts_animals_in'] - observedanimalcount['observed_animal_counts_animals_out'];
    });

    print(animal_count);

    Map<String, dynamic> new_management_location = Map<String, dynamic>();

    new_management_location = {
      ...management_locations[0],
      'animal_count' : animal_count,
      'animal_location' : animal_locations[0],
      'round' : rounds[0],

    };
    
//    print(new_management_location);

    setState(() {
      user = users[0];
      farm_site = farm_sites[0];
      management_location = new_management_location;
      farmSiteLoaded = true;
    });

    _populateChart();
  }

  _populateChart() async {
    _seriesMortalityData = List<charts.Series<MortalitySeries, int>>();
    _seriesWeightData = List<charts.Series<WeightSeries, int>>();
    _seriesWaterAnimalData = List<charts.Series<WaterAnimalSeries, int>>();
    _seriesFeedData = List<charts.Series<FeedSeries, int>>();
    _seriesAdditivesData = List<charts.Series<AdditiveSeries, int>>();
    _seriesVaccinesData = List<charts.Series<VaccinesSeries, int>>();
    _seriesEggsData = List<charts.Series<EggsSeries, int>>();

    //   ------------------------------ Get Mortality ------------------------------
    List<Map<String, dynamic>> mortalitiesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_mortality',
        [
          'observed_mortality_mln_id'
        ],
        [
          management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> mortalitiesData = List<Map<String, dynamic>>();

    mortalitiesData.addAll(mortalitiesFromDB);
    mortalitiesData.sort((a, b) => a['observed_mortality_measurement_date'].toString().compareTo(b['observed_mortality_measurement_date'].toString()));

    //    ----------------------------- Prepare Mortality --------------------------

    List<MortalitySeries> lineMortalityData = List<MortalitySeries>();
    int daysCount = DateTime.now().difference(DateTime.parse(management_location['management_location_date_start'])).inDays + 1;
    double totalMortalities = 0;
    double totalPercentage = 0;

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      mortalitiesData.forEach((element) {
        if(measurementDate.contains(element['observed_mortality_measurement_date'])){
          matchingData.add(element);
        }
      });

      double sumMortalities = 0;
      double avgMortalities = 0;


      if(matchingData.length > 0){
        matchingData.forEach((element) {
          sumMortalities = sumMortalities + element['observed_mortality_animals_dead'] + element['observed_mortality_animals_selection'];
          totalMortalities = totalMortalities + sumMortalities;
          totalPercentage = (totalMortalities / management_location['animal_count']) * 100;
          totalPercentage = totalPercentage.isFinite ? totalPercentage : 0;
        });
      }

      lineMortalityData.add(MortalitySeries(i+1, sumMortalities, totalMortalities, totalPercentage, measurementDate));
    }

    _seriesMortalityData.add(
        charts.Series(
            domainFn: (MortalitySeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (MortalitySeries mS, _) {
              return mS.totalPercentage;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.red);
            },
            id: "Mortality Growth",
            data: lineMortalityData
        )
    );

    //   ------------------------------ Get Weight ------------------------------
    List<Map<String, dynamic>> weightsFromDB = await DatabaseHelper.instance.getWhere(
        'observed_weight',
        [
          'observed_weight_mln_id',
        ],
        [
          management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> weightsData = List<Map<String, dynamic>>();

    weightsData.addAll(weightsFromDB);
    weightsData.sort((a, b) => a['observed_weight_measurement_date'].toString().compareTo(b['observed_weight_measurement_date'].toString()));

    //    ----------------------------- Prepare Weight --------------------------

    List<WeightSeries> lineWeightData = List<WeightSeries>();

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      weightsData.forEach((element) {
        if(measurementDate.contains(element['observed_weight_measurement_date'])){
          matchingData.add(element);
        }
      });

      double weightsValue = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          weightsValue = element['observed_weight_weights'].toDouble();
        });
      }

      lineWeightData.add(WeightSeries(i+1, weightsValue, measurementDate));
//      print(lineWeightData.last.weightValue);
    }

    _seriesWeightData.add(
        charts.Series(
            domainFn: (WeightSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (WeightSeries mS, _) {
              return mS.weightValue;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.purple);
            },
            id: "Weight Growth",
            data: lineWeightData
        )
    );

    //   ------------------------------ Get Water ------------------------------
    List<Map<String, dynamic>> waterFromDB = await DatabaseHelper.instance.getWhere(
        'observed_water_uses',
        [
          'observed_water_uses_mln_id',
        ],
        [
          management_location['_management_location_id']
        ]
    );

    List<Map<String, dynamic>> waterData = List<Map<String, dynamic>>();

    waterData.addAll(waterFromDB);
    waterData.sort((a, b) => a['observed_water_uses_measurement_date'].toString().compareTo(b['observed_water_uses_measurement_date'].toString()));

    //    ----------------------------- Prepare Water --------------------------

    List<WaterAnimalSeries> lineWaterAnimalData = List<WaterAnimalSeries>();

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      waterData.forEach((element) {
        if(measurementDate.contains(element['observed_water_uses_measurement_date'])){
          matchingData.add(element);
        }
      });

      double waterValue = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          waterValue = element['observed_water_uses_amount'] / management_location['animal_count'];
        });
      }

      lineWaterAnimalData.add(WaterAnimalSeries(i+1, waterValue, measurementDate));
//      print(lineWaterAnimalData.last.waterValue);
    }

    _seriesWaterAnimalData.add(
        charts.Series(
            domainFn: (WaterAnimalSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (WaterAnimalSeries mS, _) {
              return mS.waterValue;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor);
            },
            id: "Water / Animal",
            data: lineWaterAnimalData
        )
    );

    //   ------------------------------ Get Feed ------------------------------
    List<Map<String, dynamic>> feedFromDB = await DatabaseHelper.instance.getWhere(
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

    List<Map<String, dynamic>> feedData = List<Map<String, dynamic>>();

    feedData.addAll(feedFromDB);
    feedData.sort((a, b) => a['observed_input_uses_measurement_date'].toString().compareTo(b['observed_input_uses_measurement_date'].toString()));


    //    ----------------------------- Prepare Feed --------------------------

    List<FeedSeries> lineFeedData = List<FeedSeries>();

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      feedData.forEach((element) {
        if(measurementDate.contains(element['observed_input_uses_measurement_date'])){
          matchingData.add(element);
        }
      });

      double feedAmount = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          feedAmount = feedAmount + element['observed_input_uses_total_amount'].toDouble();
        });
      }

      lineFeedData.add(FeedSeries(i+1, feedAmount, measurementDate));
//      print(lineWaterAnimalData.last.waterValue);
    }

    _seriesFeedData.add(
        charts.Series(
            domainFn: (FeedSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (FeedSeries mS, _) {
              return mS.feedAmount;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.amber);
            },
            id: "Feed Amount",
            data: lineFeedData
        )
    );

    //   ------------------------------ Get Additives ------------------------------
    List<Map<String, dynamic>> additivesFromDB = await DatabaseHelper.instance.getWhere(
        'observed_input_uses',
        [
          'observed_input_uses_mln_id',
          'observed_input_uses_oue_type'
        ],
        [
          management_location['_management_location_id'],
          'Additive'
        ]
    );

    List<Map<String, dynamic>> additiveData = List<Map<String, dynamic>>();

    additiveData.addAll(additivesFromDB);
    additiveData.sort((a, b) => a['observed_input_uses_measurement_date'].toString().compareTo(b['observed_input_uses_measurement_date'].toString()));

    //    ----------------------------- Prepare Additives --------------------------

    List<AdditiveSeries> lineAdditiveData = List<AdditiveSeries>();

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      additiveData.forEach((element) {
        if(measurementDate.contains(element['observed_input_uses_measurement_date'])){
          matchingData.add(element);
        }
      });

      double additiveAmount = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          additiveAmount = element['observed_input_uses_total_amount'].toDouble();
        });
      }

      lineAdditiveData.add(AdditiveSeries(i+1, additiveAmount, measurementDate));
//      print(lineAdditiveData.last.additiveAmount);
    }

    _seriesAdditivesData.add(
        charts.Series(
            domainFn: (AdditiveSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (AdditiveSeries mS, _) {
              return mS.additiveAmount;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.greenAccent);
            },
            id: "Additive Amount",
            data: lineAdditiveData
        )
    );

    //   ------------------------------ Get Vaccination ------------------------------
    List<Map<String, dynamic>> vaccinationFromDB = await DatabaseHelper.instance.getWhere(
        'observed_input_uses',
        [
          'observed_input_uses_mln_id',
          'observed_input_uses_oue_type'
        ],
        [
          management_location['_management_location_id'],
          'Medication'
        ]
    );

    List<Map<String, dynamic>> vaccinationData = List<Map<String, dynamic>>();

    vaccinationData.addAll(vaccinationFromDB);
    vaccinationData.sort((a, b) => a['observed_input_uses_measurement_date'].toString().compareTo(b['observed_input_uses_measurement_date'].toString()));

    //    ----------------------------- Prepare Vaccination --------------------------

    List<VaccinesSeries> lineVaccinationData = List<VaccinesSeries>();

    for(int i = 0; i < daysCount; i++){
      String measurementDate = DateTime.parse(management_location['management_location_date_start'])
          .add(Duration(days: i))
          .toString();

      List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

      vaccinationData.forEach((element) {
        if(measurementDate.contains(element['observed_input_uses_measurement_date'])){
          matchingData.add(element);
        }
      });

      double vaccinationAmount = 0;

      if(matchingData.length > 0){
        matchingData.forEach((element) {
          vaccinationAmount = element['observed_input_uses_total_amount'].toDouble();
        });
      }

      lineVaccinationData.add(VaccinesSeries(i+1, vaccinationAmount, measurementDate));
//      print(lineVaccinationData.last.vaccinationAmount);
    }

    _seriesVaccinesData.add(
        charts.Series(
            domainFn: (VaccinesSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (VaccinesSeries mS, _) {
              return mS.vaccineIntake;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.teal);
            },
            id: "Vaccine Amount",
            data: lineVaccinationData
        )
    );

    if(farm_site['farm_sites_fst_type'] == 'Layer'){
      //   ------------------------------ Get Eggs ------------------------------
      List<Map<String, dynamic>> eggsFromDB = await DatabaseHelper.instance.getWhere(
          'observed_egg_production',
          [
            'observed_egg_production_mln_id'
          ],
          [
            management_location['_management_location_id']
          ]
      );

      List<Map<String, dynamic>> eggsData = List<Map<String, dynamic>>();

      eggsData.addAll(eggsFromDB);
      eggsData.sort((a, b) => a['observed_egg_production_measurement_date'].toString().compareTo(b['observed_egg_production_measurement_date'].toString()));

      //    ----------------------------- Prepare Eggs --------------------------

      List<EggsSeries> lineEggsData = List<EggsSeries>();

      for(int i = 0; i < daysCount; i++){
        String measurementDate = DateTime.parse(management_location['management_location_date_start'])
            .add(Duration(days: i))
            .toString();

        List<Map<String, dynamic>> matchingData = List<Map<String, dynamic>>();

        eggsData.forEach((element) {
          if(measurementDate.contains(element['observed_egg_production_measurement_date'])){
            matchingData.add(element);
          }
        });

        double eggsProduction = 0;

        if(matchingData.length > 0){
          matchingData.forEach((element) {
            eggsProduction = element['observed_egg_production_first_quality'].toDouble() + element['observed_egg_production_second_quality'].toDouble() + element['observed_egg_production_ground_eggs'].toDouble();
          });
        }

        lineEggsData.add(EggsSeries(i+1, eggsProduction, measurementDate));
      }

      _seriesEggsData.add(
          charts.Series(
              domainFn: (EggsSeries mS, _) {
                return mS.dayObservation;
              },
              measureFn: (EggsSeries mS, _) {
                return mS.eggsProduction;
              },
              colorFn: (__, _) {
                return charts.ColorUtil.fromDartColor(Colors.deepOrangeAccent);
              },
              id: "Eggs Amount",
              data: lineEggsData
          )
      );
    }

    setState(() {
      chartsLoaded = true;
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
              SizedBox(height: 20,),
              Text(
                "Observations",
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
              _buildMenuButtons(),
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
      if(farm_site['farm_sites_fst_type'] == 'Layer'){
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(Icons.do_not_disturb),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservemortalityhomescreen").then((reload) => _getFarmSiteInformation());
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Mortality",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.spa),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservefeedhomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Feed",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.opacity),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservewaterhomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Water",
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(Icons.vertical_align_bottom),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobserveweightshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Weights",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.format_color_fill),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Additives",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.healing),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservevaccineshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Vaccines",
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            iconSize: 50,
                            icon: Icon(Icons.bubble_chart),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobserveeggshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Eggs",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.camera_alt),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservepictureshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Picture",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }
      else if(farm_site['farm_sites_fst_type'] == 'Broiler'){{
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(Icons.do_not_disturb),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservemortalityhomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Mortality",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.spa),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservefeedhomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Feed",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.opacity),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservewaterhomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Water",
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(Icons.vertical_align_bottom),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobserveweightshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Weights",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.format_color_fill),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Additives",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
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
                            icon: Icon(Icons.healing),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservevaccineshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Vaccines",
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            icon: Icon(Icons.camera_alt),
                            onPressed: (){
                              Navigator.pushNamed(context, "/dailyobservepictureshomescreen").then((reload) => _getFarmSiteInformation());;
                            }
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Picture",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }

      }
    }
  }

  _buildOverviewDashboard(){
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
                            "Mortality Growth %",
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
                            _seriesMortalityData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                  <charts.TickSpec<int>>[
                                    charts.TickSpec(10),
//                                    charts.TickSpec(25),
//                                    charts.TickSpec(50),
//                                    charts.TickSpec(75),
//                                    charts.TickSpec(100),
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
                                  value: includePrevRoundMortality,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundMortality = true;
                                      } else {
                                        includePrevRoundMortality = false;
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
                            "Weight Growth",
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
                            _seriesWeightData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "grams",
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
                                  value: includePrevRoundWeight,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundWeight = true;
                                      } else {
                                        includePrevRoundWeight = false;
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
                            "Feed Consumptions",
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
                            _seriesFeedData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.SeriesLegend(),
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "grams",
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
                                  value: includePrevRoundFeed,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundFeed = true;
                                      } else {
                                        includePrevRoundFeed = false;
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
                            "Water/Animal",
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
                            _seriesWaterAnimalData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "ml",
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
                                  value: includePrevRoundWaterAnimal,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundWaterAnimal = true;
                                      } else {
                                        includePrevRoundWaterAnimal = false;
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
                            "Additive Intake",
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
                            _seriesAdditivesData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.SeriesLegend(),
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "ml",
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
                                  value: includePrevRoundAdditives,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundAdditives = true;
                                      } else {
                                        includePrevRoundAdditives = false;
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
                            "Vaccines Intake",
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
                            _seriesVaccinesData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.SeriesLegend(),
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "ml",
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
                                  value: includePrevRoundVaccines,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundVaccines = true;
                                      } else {
                                        includePrevRoundVaccines = false;
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
          farm_site['farm_sites_fst_type'] == 'Layer' ? Container(
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
                            "Eggs Production",
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
                            _seriesEggsData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true,
                                stacked: true
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                                  dataIsInWholeNumbers: true,
                                  desiredTickCount: 4
                              ),
                            ),
                            behaviors: [
                              charts.SeriesLegend(),
                              charts.ChartTitle(
                                  "Days",
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                              ),
                              charts.ChartTitle(
                                  "pcs",
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
                                  value: includePrevRoundVaccines,
                                  onChanged: (newValue) async {
                                    Dialogs.waitingDialog(context, "Loading...", "Please Wait", false);

                                    Future.delayed(Duration(milliseconds: 500), (){
                                      Navigator.pop(context);
                                    });

                                    setState(() {
                                      if(newValue){
                                        includePrevRoundVaccines = true;
                                      } else {
                                        includePrevRoundVaccines = false;
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
          ) : Container(),
        ],
      );
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
                  child: SingleChildScrollView(
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
                        _buildHouseInformationCard(),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                              child: Text(
                                "Performance Overview",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildOverviewDashboard(),

                      ],
                    ),
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


class MortalitySeries{
  double sumMortalities;
  double totalMortalities;
  double totalPercentage;
  int dayObservation;
  String measurementDate;

  MortalitySeries(this.dayObservation, this.sumMortalities, this.totalMortalities, this.totalPercentage, this.measurementDate);
}

class WeightSeries{
  double weightValue;
  int dayObservation;
  String measurementDate;

  WeightSeries(this.dayObservation, this.weightValue, this.measurementDate);
}

class FeedSeries{
  double feedAmount;
  int dayObservation;
  String measurementDate;

  FeedSeries(this.dayObservation, this.feedAmount, this.measurementDate);
}

class WaterAnimalSeries{
  double waterValue;
  int dayObservation;
  String measurementDate;

  WaterAnimalSeries(this.dayObservation, this.waterValue, this.measurementDate);
}

class AdditiveSeries{
  double additiveAmount;
  int dayObservation;
  String measurementDate;

  AdditiveSeries(this.dayObservation, this.additiveAmount, this.measurementDate);
}

class VaccinesSeries{
  double vaccineIntake;
  int dayObservation;
  String measurementDate;

  VaccinesSeries(this.dayObservation, this.vaccineIntake, this.measurementDate);
}

class EggsSeries{
  double eggsProduction;
  int dayObservation;
  String measurementDate;

  EggsSeries(this.dayObservation, this.eggsProduction, this.measurementDate);
}