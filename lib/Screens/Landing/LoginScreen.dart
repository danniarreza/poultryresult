import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:poultryresult/Services/database_helper.dart';
import 'package:poultryresult/Services/rest_api.dart';
import 'package:poultryresult/Widgets/dialogs.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String username;
  String password;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _buildWelcomeLogo(){
    return Image(
      image: AssetImage('assets/images/farmresult-logo.png'),
    );
  }

  _buildUsernameField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "USERNAME",
        labelStyle: TextStyle(
          fontFamily: 'MontSerrat',
          fontWeight: FontWeight.w500
        ),
        icon: Icon(Icons.person),
      ),
      validator: (String value){
        String errMsg;
        if(value.isEmpty) {
          errMsg = "Name is required";
        }

        return errMsg;
      },
      onSaved: (String value) {
        username = value;
      },
    );

  }

  _buildPasswordField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "PASSWORD",
        labelStyle: TextStyle(
          fontFamily: 'MontSerrat',
          fontWeight: FontWeight.w500
        ),
        icon: Icon(Icons.lock),
      ),
      validator: (String value){
        String errMsg;
        if(value.isEmpty){
          errMsg = "Password is required";
        }
        return errMsg;
      },
      obscureText: true,
      onSaved: (String value){
        password = value;
      },
    );
  }

  _buildForgotPasswordButton(){
    return Container(
      alignment: Alignment(1.0, 0.0),
      child: GestureDetector(
        onTap: () async{
          String tableName = 'user';
          List<Map<String, dynamic>> rows = await DatabaseHelper.instance.get(tableName);
          print(rows);
//          print("hi");
        },
        child: Text(
          "Forgot Password",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600
          ),
        ),
      )
    );
  }

  _buildLoginButton(){
    return GestureDetector(
      onTap: (){
        if(!formKey.currentState.validate()){
          return;
        }

        formKey.currentState.save();
//        print(username);
//        print(password);
        _deleteUserSession();
        userLogin();
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.blueAccent,
          color: Theme.of(context).primaryColor,
//          color: Colors.lightBlue[800],
          elevation: 2.0,
          child: Center(
            child: Text(
              "LOGIN",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildLoginButton2(){
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      )
    );
  }

  _buildContactAdminButton(){
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Do not have a username and password?",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Contact Administrator",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }

  _buildCopyrightText(){
    return Container(
      child: Text(
        "Copyright \u00A9 2020 FarmResult, The Netherlands.",
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  userLogin() async {
    Dialogs.waitingDialog(context, "Signing In...", "Please Wait", false);
    var result = await Connectivity().checkConnectivity();

    if(result == ConnectivityResult.none){
      Navigator.pop(context);
      final dialogAction = await Dialogs.errorRetryDialog(context, "You are offline", "Retry", true);

      if(dialogAction == DialogAction.yes){
        Future.delayed(Duration(seconds: 1), (){
          userLogin();
        });
      }

    } else {

      String url = "user/login";

      Map<String, dynamic> params = {
        "user_name" : username,
        "user_password" : password
      };

      dynamic responseJSON = await postData(params, url);

      if(responseJSON['status'] == "Success"){

        print(responseJSON['message']);

        String tableName = 'user';
        int id = await DatabaseHelper.instance.insert(tableName, {
          DatabaseHelper.user_name : username,
          DatabaseHelper.user_password : password,
        });

        print('The inserted ID : $id');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/companylocation');
      } else {
        print(responseJSON['message']);
        Navigator.pop(context);
        await Dialogs.errorRetryDialog(context, responseJSON['message'], "Retry", true);
      }

    }
  }

  _deleteUserSession() async {
    String tableName = 'user';
    int rowsAffected = await DatabaseHelper.instance.delete(tableName);
    return rowsAffected;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 4.5,
                horizontal: 50
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//              Text("Welcome!"),
//            SizedBox(height: 150),
                _buildWelcomeLogo(),
                SizedBox(height: MediaQuery.of(context).size.height / 7),
                _buildUsernameField(),
                _buildPasswordField(),
                SizedBox(height: 25),
                _buildForgotPasswordButton(),
                SizedBox(height: 25),
                _buildLoginButton(),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                _buildContactAdminButton(),
//            SizedBox(height: 150),
//            _buildCopyrightText()
                ],
              ),
            ),
          ),
        ),
      ),
    );;
  }
}
