import 'package:flutter/material.dart';
import 'package:poultryresult/Screens/ChickensOut/ChickensOutHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Additives/AdditivesHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Additives/AdditivesNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Eggs/EggsHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Eggs/EggsNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Feed/FeedHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/DailyObserveHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/DailyObserveHouseDetailScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Feed/FeedNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Mortality/MortalityHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Mortality/MortalityNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Pictures/PicturesHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Pictures/PicturesNewEdit.dart';
import 'package:poultryresult/Screens/DailyObserve/Vaccinations/VaccinationsHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Vaccinations/VaccinationsNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Water/WaterHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Water/WaterNewEditScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Weight/WeightsHomeScreen.dart';
import 'package:poultryresult/Screens/DailyObserve/Weight/WeightsNewEditScreen.dart';
import 'package:poultryresult/Screens/Dashboard/DashboardDetailScreen.dart';
import 'package:poultryresult/Screens/Dashboard/DashboardHomeScreen.dart';
import 'package:poultryresult/Screens/Landing/CompanyLocationScreen.dart';
import 'package:poultryresult/Screens/Landing/SplashScreen.dart';
import 'package:poultryresult/Screens/Landing/LoginScreen.dart';
import 'package:poultryresult/Screens/ChickensIn/ChickensInHomeScreen.dart';
import 'package:poultryresult/Screens/ChickensIn/ChickensInNewEditScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PoultryResult",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
//        primaryColor: Colors.lightBlue[800],
        primaryColor: Color.fromRGBO(35, 67, 125, 1),
        accentColor: Colors.black
      ),
      initialRoute: "/splash",
      routes: {
        "/splash" : (context) => SplashScreen(),
        "/loginscreen" : (context) => LoginScreen(),
        "/companylocation": (context) => CompanyLocationScreen(),
        "/dashboardhomescreen": (context) => DashboardHomeScreen(),
        "/dashboarddetailscreen": (context) => DashboardDetailScreen(),
        "/dailyobservehomescreen": (context) => DailyObserveHomeScreen(),
        "/dailyobservehousedetailscreen": (context) => DailyObserveHouseDetailScreen(),
        "/dailyobservemortalityhomescreen": (context) => MortalityHomeScreen(),
        "/dailyobservemortalityneweditscreen": (context) => MortalityNewEditScreen(),
        "/dailyobservefeedhomescreen": (context) => FeedHomeScreen(),
        "/dailyobservefeedneweditscreen": (context) => FeedNewEditScreen(),
        "/dailyobservewaterhomescreen": (context) => WaterHomeScreen(),
        "/dailyobservewaterneweditscreen": (context) => WaterNewEditScreen(),
        "/dailyobserveweightshomescreen": (context) => WeightsHomeScreen(),
        "/dailyobserveweightsneweditscreen": (context) => WeightsNewEditScreen(),
        "/dailyobserveadditiveshomescreen": (context) => AdditivesHomeScreen(),
        "/dailyobserveadditivesneweditscreen": (context) => AdditivesNewEditScreen(),
        "/dailyobservevaccineshomescreen": (context) => VaccinationsHomeScreen(),
        "/dailyobservevaccinesneweditscreen": (context) => VaccinationsNewEditScreen(),
        "/dailyobserveeggshomescreen": (context) => EggsHomeScreen(),
        "/dailyobserveeggsneweditscreen": (context) => EggsNewEditScreen(),
        "/dailyobservepictureshomescreen": (context) => PicturesHomeScreen(),
        "/dailyobservepicturesneweditscreen": (context) => PicturesNewEditScreen(),
        "/chickensouthomescreen": (context) => ChickensOutHomeScreen(),
      },
    );
  }
}
