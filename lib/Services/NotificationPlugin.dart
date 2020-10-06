import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;

import 'package:rxdart/subjects.dart';

class NotificationPlugin {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  InitializationSettings initializationSettings;

  NotificationPlugin._() {
    initialize();
  }

  initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if(Platform.isIOS){
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics(){
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      }
    );

    initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
  }

  _requestIOSPermission(){
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: false,
      badge: true,
      sound: true
    );
  }

  setListenerForLowerVersions(Function onNotificationLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        onNotificationClick(payload);
      }
    );
  }

  Future<void> showNotification(String title, String description) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Channel_ID',
      'Channel_Name',
      'Channel_Description',
        priority: Priority.High,
        importance: Importance.Max,
      playSound: true,
//      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true)
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        description,
        notificationDetails,
        payload: 'New Payload'
    );
  }

  Future<void> scheduleNotification(String title, String description, DateTime scheduleTime) async {
//    DateTime scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 10));
    DateTime scheduleNotificationDateTime = scheduleTime;
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Channel_ID 1',
      'Channel_Name 1',
      'Channel_Description 1',
      icon: 'app_icon',
      enableLights: true,
      color: Color.fromRGBO(35, 67, 125, 1),
      ledColor: Color.fromRGBO(35, 67, 125, 1),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
//      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    await flutterLocalNotificationsPlugin.schedule(0, title, description, scheduleNotificationDateTime, notificationDetails);
  }

  Future<void> showDailyAtTime() async {
    Time time = Time(8, 0, 0);
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Channel_ID 4',
      'Channel_Name 4',
      'Channel_Description 4',
      priority: Priority.High,
      importance: Importance.Max,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
//      'Test Title at ${time.hour}:${time.minute}.${time.second}',
      'Good Morning!',
      'Are you ready for the day observation?', //null
      time,
      notificationDetails,
      payload: 'Test Payload',
    );
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
