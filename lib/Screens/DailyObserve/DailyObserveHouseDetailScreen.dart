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

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _getFarmSiteInformation();

//    Future.delayed(Duration(seconds: 1), (){
      _generateData();
//    });
  }

  _generateData(){
    List<MortalitySeries> lineMortalityData = List<MortalitySeries>(39);

    Random random = Random();

    for(int i = 0; i < 39; i++){
      lineMortalityData[i] = MortalitySeries(i, (i + random.nextInt(5)).toDouble());
    }

    _seriesMortalityData.add(
        charts.Series(
            domainFn: (MortalitySeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (MortalitySeries mS, _) {
              return mS.mortalityPercentage;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.red);
            },
            id: "MortalityKPI",
            data: lineMortalityData
        )
    );
    //    ------------------------------------------------------------------------

    List<WeightSeries> lineWeightData = List<WeightSeries>(39);

    int weight = 0;
//    int currentWeight = 0;

    for(int i = 0; i < 39; i++){
      weight = (weight + (random.nextInt(20) + 40));
      lineWeightData[i] = WeightSeries(i, weight.toDouble());
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
            id: "WeightKPI",
            data: lineWeightData
        )
    );

    //    ------------------------------------------------------------------------

    List<FeedSeries> lineFeedData1 = List<FeedSeries>(39);
    List<FeedSeries> lineFeedData2 = List<FeedSeries>(39);

    int feed1 = 0;
    int feed2 = 0;

    for(int i = 0; i < 39; i++){
      feed1 = (feed1 + (random.nextInt(4) + 1));
      feed2 = (feed2 + (random.nextInt(6) + 1));
      lineFeedData1[i] = FeedSeries(i, feed1.toDouble(), "Feed 1");
      lineFeedData2[i] = FeedSeries(i, feed2.toDouble(), "Feed 2");
    }

    _seriesFeedData.add(
        charts.Series(
            domainFn: (FeedSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (FeedSeries mS, _) {
              return mS.feedValue;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.amber);
            },
            id: lineFeedData1[0].feedArticle,
            data: lineFeedData1
        )
    );
    _seriesFeedData.add(
        charts.Series(
            domainFn: (FeedSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (FeedSeries mS, _) {
              return mS.feedValue;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.brown);
            },
            id: lineFeedData2[0].feedArticle,
            data: lineFeedData2
        )
    );

    //    ------------------------------------------------------------------------

    List<WaterAnimalSeries> lineWaterAnimalData = List<WaterAnimalSeries>(39);

    int waterAnimal = 0;

    for(int i = 0; i < 39; i++){
      waterAnimal = (waterAnimal + (random.nextInt(10) + 5));
      lineWaterAnimalData[i] = WaterAnimalSeries(i, waterAnimal.toDouble());
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
            id: "Water/AnimalKPI",
            data: lineWaterAnimalData
        )
    );

    //    ------------------------------------------------------------------------

    List<AdditiveSeries> lineAdditivesData1 = List<AdditiveSeries>(39);
    List<AdditiveSeries> lineAdditivesData2 = List<AdditiveSeries>(39);

    int additivesIntake1 = 0;
    int additivesIntake2 = 0;

    for(int i = 0; i < 39; i++){
      additivesIntake1 = additivesIntake1 + random.nextInt(4);
      additivesIntake2 = additivesIntake2 + random.nextInt(2);
      lineAdditivesData1[i] = AdditiveSeries(i, additivesIntake1.toDouble(), "Vitamin C");
      lineAdditivesData2[i] = AdditiveSeries(i, additivesIntake2.toDouble(), "Vitamin D");
    }

    _seriesAdditivesData.add(
        charts.Series(
            domainFn: (AdditiveSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (AdditiveSeries mS, _) {
              return mS.additiveIntake;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.green);
            },
            id: lineAdditivesData1[0].additiveArticle,
            data: lineAdditivesData1
        )
    );
    _seriesAdditivesData.add(
        charts.Series(
            domainFn: (AdditiveSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (AdditiveSeries mS, _) {
              return mS.additiveIntake;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.greenAccent);
            },
            id: lineAdditivesData2[0].additiveArticle,
            data: lineAdditivesData2
        )
    );

    //    ------------------------------------------------------------------------

    List<VaccinesSeries> lineVaccinesData1 = List<VaccinesSeries>(39);
    List<VaccinesSeries> lineVaccinesData2 = List<VaccinesSeries>(39);
    List<VaccinesSeries> lineVaccinesData3 = List<VaccinesSeries>(39);

    int vaccinesIntake1 = 0;
    int vaccinesIntake2 = 0;
    int vaccinesIntake3 = 0;

    for(int i = 0; i < 39; i++){
      vaccinesIntake1 = vaccinesIntake1 + random.nextInt(3);
      vaccinesIntake2 = vaccinesIntake2 + random.nextInt(4);
      vaccinesIntake3 = vaccinesIntake3 + random.nextInt(5);
      lineVaccinesData1[i] = VaccinesSeries(i, vaccinesIntake1.toDouble(), "Aviax");
      lineVaccinesData2[i] = VaccinesSeries(i, vaccinesIntake2.toDouble(), "Baycox");
      lineVaccinesData3[i] = VaccinesSeries(i, vaccinesIntake3.toDouble(), "Poulvac");
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
              return charts.ColorUtil.fromDartColor(Colors.cyan);
            },
            id: lineVaccinesData1[0].vaccineArticle,
            data: lineVaccinesData1
        )
    );
    _seriesVaccinesData.add(
        charts.Series(
            domainFn: (VaccinesSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (VaccinesSeries mS, _) {
              return mS.vaccineIntake;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.cyanAccent);
            },
            id: lineVaccinesData2[0].vaccineArticle,
            data: lineVaccinesData2
        )
    );
    _seriesVaccinesData.add(
        charts.Series(
            domainFn: (VaccinesSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (VaccinesSeries mS, _) {
              return mS.vaccineIntake;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.tealAccent);
            },
            id: lineVaccinesData3[0].vaccineArticle,
            data: lineVaccinesData3
        )
    );
  }

//  _getUserLocation() async {
//
//    String tableName = 'user';
//    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get(tableName);
//
//    setState(() {
//      user_location = users[0]['_location_id'];
//    });
//
//    _getFarmSiteInformation();
//    print(users);
//  }

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
    
//    print(new_management_location);

    setState(() {
      user = users[0];
      farm_site = farm_sites[0];
      management_location = new_management_location;
      farmSiteLoaded = true;
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
                      "House : " + user['_location_id'].toString(),
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
                              Navigator.pushNamed(context, "/dailyobservemortalityhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservefeedhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservewaterhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobserveweightshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservevaccineshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobserveeggshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservepictureshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservemortalityhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservefeedhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservewaterhomescreen");
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
                              Navigator.pushNamed(context, "/dailyobserveweightshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobserveadditiveshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservevaccineshomescreen");
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
                              Navigator.pushNamed(context, "/dailyobservepictureshomescreen");
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
    if (farmSiteLoaded == false){
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: SpinKitThreeBounce(
            color: Color.fromRGBO(253, 184, 19, 1),
            size: 30
        ),
      );
    } else if(farmSiteLoaded == true){
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
                            "Mortality [%]",
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
                            "Feed/Type",
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
                            "Additive/Type",
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
                            "Vaccines/Type",
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
  String feedArticle;

  FeedSeries(this.dayObservation, this.feedValue, this.feedArticle);
}

class WaterAnimalSeries{
  double waterValue;
  int dayObservation;

  WaterAnimalSeries(this.dayObservation, this.waterValue);
}

class AdditiveSeries{
  double additiveIntake;
  int dayObservation;
  String additiveArticle;

  AdditiveSeries(this.dayObservation, this.additiveIntake, this.additiveArticle);
}

class VaccinesSeries{
  double vaccineIntake;
  int dayObservation;
  String vaccineArticle;

  VaccinesSeries(this.dayObservation, this.vaccineIntake, this.vaccineArticle);
}