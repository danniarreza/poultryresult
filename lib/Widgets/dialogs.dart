import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum DialogAction {yes, abort}

class Dialogs{

  static Future<DialogAction> waitingDialog(BuildContext context, String title, String description, bool dismissable) async {
    return showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(title)
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SpinKitThreeBounce(
                  color: Color.fromRGBO(253, 184, 19, 1),
                  size: 30
                )
              ]
            ),
          )
        );
      }
    );
  }

  static Future<DialogAction> errorDialog(BuildContext context, String title, String description, bool dismissable) async {
    return showDialog(
        context: context,
        barrierDismissible: dismissable,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Center(
                  child: Text(title)
              ),
              content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[
                      Icon(Icons.do_not_disturb, color: Colors.red, size: 50,),
                      SizedBox(height: 15,),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                      ),
                    ]
                ),
              )
          );
        }
    );
  }

  static Future<DialogAction> errorRetryDialog(BuildContext context, String title, String subtitle, bool dismissable) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: dismissable,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Center(
                  child: Icon(Icons.do_not_disturb, color: Colors.red, size: 50,),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[
                      Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop(DialogAction.yes);
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400
                              ),
                            )
                          ),
                        ),
                      ),
                    ]
                ),
              )
          );
        }
    );
    return (action != null) ? action : DialogAction.abort;
  }

  static Future<DialogAction> confirmContinueDialog(BuildContext context, String title, String subtitle, bool dismissable) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: dismissable,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Center(
                child: Icon(Icons.check, color: Color.fromRGBO(253, 184, 19, 1), size: 75,),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[
                      Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop(DialogAction.yes);
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                              child: Text(
                                subtitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400
                                ),
                              )
                          ),
                        ),
                      ),
                    ]
                ),
              )
          );
        }
    );
    return (action != null) ? action : DialogAction.abort;
  }
}