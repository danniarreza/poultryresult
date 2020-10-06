import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poultryresult/Services/database_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void redirectScreen() {
    Future.delayed(Duration(seconds: 2), () async {

      String tableName = 'user';
      List<Map<String, dynamic>> rows = await DatabaseHelper.instance.get(tableName);
//      print(rows);

      if(rows.length == 1){
        Navigator.pushReplacementNamed(context, '/companylocation');
      } else {
        Navigator.pushReplacementNamed(context, '/loginscreen');
      }
    });
  }

  @override
  void initState(){
    super.initState();

    redirectScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}
