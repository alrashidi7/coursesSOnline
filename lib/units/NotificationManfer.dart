import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager
{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings initializationSettingsAndroid;
  IOSInitializationSettings initializationSettingsIOS;
  InitializationSettings initializationSettings;

  void initNotificationManager()
  {
    initializationSettingsAndroid = new AndroidInitializationSettings('chat');
    initializationSettingsIOS = new IOSInitializationSettings();
    initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotificationWithDefaultSound(String title, String body)
  async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
  void scheduleNotificationWithDefaultSound(String title, String body,DateTime scheduledDate)
  async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
   await flutterLocalNotificationsPlugin.schedule(0, title, body, scheduledDate, platformChannelSpecifics);
  }
}