import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize the FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Configure the initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin with the initialization settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize FirebaseMessaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var token = await messaging.getToken();
  print("user token is : $token ");

  runApp( MyApp(flutterLocalNotificationsPlugin));
}


class MyApp extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const MyApp(this.flutterLocalNotificationsPlugin, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
  }
    void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved******");
      if (message.notification != null) {
        print("*****message recieved");
        _displayNotification(
          widget.flutterLocalNotificationsPlugin,
          message.notification!.title ?? '*****',
          message.notification!.body ?? '#####',
        );
      }
    });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print("message clicked#####");
      if (message.notification != null) {

        print('######Notification clicked!');
        // Handle notification click event
      }
    });
  }
    Future<void> _displayNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
          body: Center(
        child: Text("Firebase Notification Test"),
      )),
    );
  }
}
