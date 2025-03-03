// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService{

//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//     FlutterLocalNotificationsPlugin();

//    static void initialize() {
//     // initializationSettings  for Android
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//             iOS: IOSInitializationSettings(),

//     );

//     _notificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (String? id) async {
//         print("onSelectNotification");
//         if (id!.isNotEmpty) {
//           print("Router Value1234 $id");

//           // Navigator.of(context).push(
//           //   MaterialPageRoute(
//           //     builder: (context) => DemoScreen(
//           //       id: id,
//           //     ),
//           //   ),
//           // );


//         }
//       },
//     );
//   }

//   static void createanddisplaynotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "theinstallers",
//           "theinstallerschannel",
//           playSound: true,
//           importance: Importance.max,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound('cute'),
                             
          
//         ),
//         iOS: IOSNotificationDetails(sound: 'cute.wav')
//       );

//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['_id'],

//       );


//     } on Exception catch (e) {
//       print(e);
//     }
//   }


//    Future<String> getDeviceTokenToSendNotification() async {
//     		final FirebaseMessaging fcm = FirebaseMessaging.instance;
//     		String? token = await fcm.getToken();
//         return token!;
//     		// deviceTokenToSendPushNotification = token.toString();
//     		// print("Token Value $deviceTokenToSendPushNotification");
//   	}

// }