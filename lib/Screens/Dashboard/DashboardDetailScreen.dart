import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:poultryresult/Widgets/Sidebar_Main.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:poultryresult/Widgets/homescreenappbar.dart';
import 'package:poultryresult/Widgets/homescreenheader.dart';

class DashboardDetailScreen extends StatefulWidget {
  @override
  _DashboardDetailScreenState createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {

  List<charts.Series<TemperatureSeries, int>> _seriesTemperatureData;
  List<charts.Series<HumiditySeries, int>> _seriesHumidityData;
  bool includePrevRoundTemperature = false;
  bool includePrevRoundHumidity = false;

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    _seriesTemperatureData = List<charts.Series<TemperatureSeries, int>>();
    _seriesHumidityData = List<charts.Series<HumiditySeries, int>>();
    _generateData();
  }

  _generateData(){

    Random random = Random();

    List<TemperatureSeries> lineInsideTemperatureData = List<TemperatureSeries>(39);
    List<TemperatureSeries> lineOutsideTemperatureData = List<TemperatureSeries>(39);

    for(int i = 0; i < 39; i++){
      lineInsideTemperatureData[i] = TemperatureSeries(i, (random.nextInt(15) + 35).toDouble());
      lineOutsideTemperatureData[i] = TemperatureSeries(i, (random.nextInt(15) + 25).toDouble());
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
            data: lineInsideTemperatureData
        )
    );
    _seriesTemperatureData.add(
        charts.Series(
            domainFn: (TemperatureSeries mS, _) {
              return mS.dayObservation;
            },
            measureFn: (TemperatureSeries mS, _) {
              return mS.temperatureReading;
            },
            colorFn: (__, _) {
              return charts.ColorUtil.fromDartColor(Colors.green);
            },
            id: "Outside",
            data: lineOutsideTemperatureData
        )
    );

    //    ------------------------------------------------------------------------

    List<HumiditySeries> lineHumidityData = List<HumiditySeries>(39);

    for(int i = 0; i < 39; i++){
      lineHumidityData[i] = HumiditySeries(i, (random.nextInt(15) + 50).toDouble());
    }

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
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
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
                          Expanded(
                              child: SingleChildScrollView(
                                child: Column(
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
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    )
                )
            )
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

  FeedSeries(this.dayObservation, this.feedValue);
}

class WaterAnimalSeries{
  double waterValue;
  int dayObservation;

  WaterAnimalSeries(this.dayObservation, this.waterValue);
}

class TemperatureSeries{
  double temperatureReading;
  int dayObservation;

  TemperatureSeries(this.dayObservation, this.temperatureReading);
}

class HumiditySeries{
  double humidityReading;
  int dayObservation;

  HumiditySeries(this.dayObservation, this.humidityReading);
}