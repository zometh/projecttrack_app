import 'dart:convert';

import 'package:diop_mouhamed_l3gl_examen/controllers/bottom_nav_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/full_project_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifService{
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;


  //INITIALIZE
  Future<void> initNotifications() async{
    if(_isInitialized) return; //prevent re-initialization
    //android init settings
    const initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    //ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    // initialize the plugin
      await notificationsPlugin.initialize(
      initSettings,

          onDidReceiveNotificationResponse: (response){
        BottomNavBarController.to.updateIndex(2);

        //Get.to(() => FullProjectView(projectId: projectId,));
          }
    );

  }

  //NOTIFICATIONS DETAILS SETUP
  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
      'daily_channel_id',
      "Daily Notifications",
        channelDescription: "Daily Notification Channel",
        importance: Importance.max,
        priority: Priority.high,

      ),
      iOS: DarwinNotificationDetails(

      )
    );
  }
  //SHOW NOTIFICATIONS
  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  })async{
    return notificationsPlugin.show(id, title, body, notificationDetails(),payload: payload ?? "");
  }
  //on ontif clicked




}
