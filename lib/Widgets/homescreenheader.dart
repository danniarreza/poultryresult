import 'package:flutter/material.dart';
import 'package:poultryresult/Services/database_helper.dart';

class HomeScreenHeader extends StatefulWidget {
  @override
  _HomeScreenHeaderState createState() => _HomeScreenHeaderState();
}

class _HomeScreenHeaderState extends State<HomeScreenHeader> {
  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;

  bool farmSiteLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getFarmSiteInformation();
  }

  _getFarmSiteInformation() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');
    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getById('farm_sites', users[0]['_farm_sites_id']);

    setState(() {
      user = users[0];
      farm_site = farm_sites[0];
      farmSiteLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: farmSiteLoaded == true ?
          Text(
            farm_site['farm_sites_fst_type'] + " Farm",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
          ) :
          Container(),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: farmSiteLoaded == true ?
          Text(
            "Farm Identification : " + farm_site['_farm_sites_id'].toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ) :
          Container()
          ,
        ),
        SizedBox(
          height: 27.5,
        ),
      ],
    );
  }
}
