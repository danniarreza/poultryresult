import 'package:flutter/material.dart';
import 'package:poultryresult/Services/database_helper.dart';

class ObservationScreenHeader extends StatefulWidget {
  @override
  _ObservationScreenHeaderState createState() => _ObservationScreenHeaderState();
}

class _ObservationScreenHeaderState extends State<ObservationScreenHeader> {
  Map<String, dynamic> user;
  Map<String, dynamic> farm_site;
  Map<String, dynamic> management_location;

  bool farmSiteLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getFarmSiteInformation();
  }

  _getFarmSiteInformation() async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.get('user');
    List<Map<String, dynamic>> farm_sites = await DatabaseHelper.instance.getWhere('farm_sites', ['_farm_sites_id'], [users[0]['_farm_sites_id']]);

    List<Map<String, dynamic>> management_locations = await DatabaseHelper.instance.getWhere('management_location', ['_management_location_id'], [users[0]['_management_location_id']]);

    List<Map<String, dynamic>> animal_locations = await DatabaseHelper.instance.getWhere('animal_location', ['_animal_location_id'], [management_locations[0]['management_location_animal_location_id']]);
    List<Map<String, dynamic>> rounds = await DatabaseHelper.instance.getById('round', management_locations[0]['management_location_round_id']);

    List<Map<String, dynamic>> observedanimalcounts = await DatabaseHelper.instance.getWhere('observed_animal_count', ['observed_animal_counts_mln_id'], [management_locations[0]['_management_location_id']]);

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
//          height: 25,
          height: MediaQuery.of(context).size.height / 30,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: farmSiteLoaded == true ?
          Text(
            "Day : " + ((DateTime.now().difference(DateTime.parse(management_location['management_location_date_start']))).inDays + 1).toString(),
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
            "House : " + user['_animal_location_id'].toString(),
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
//          height: 27.5,
          height: MediaQuery.of(context).size.height / 30,
        ),
      ],
    );
  }
}
