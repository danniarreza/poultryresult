import 'package:flutter/material.dart';
import 'package:poultryresult/Services/database_helper.dart';

class HomeScreenAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _HomeScreenAppBarState createState() => _HomeScreenAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeScreenAppBarState extends State<HomeScreenAppBar> {
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
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
        width: 36,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.5)
        ),
        child: Builder(
            builder: (context){
              return IconButton(
                icon: Icon(Icons.menu),
                iconSize: 20,
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              );
            }
        ),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 20),
        child: farmSiteLoaded == false ?
        Container() :
        Text(
          farm_site['farm_sites_name'],
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
          width: 36,
          height: 30,
          decoration: BoxDecoration(
//                color: Color.fromRGBO(253, 184, 19, 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.5)
          ),
          child: IconButton(
            icon: Icon(Icons.location_on),
            iconSize: 20,
            color: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/companylocation");
            },
          ),
        ),
      ],
    );
  }
}
