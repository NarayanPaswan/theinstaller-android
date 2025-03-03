import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theinstallers/controller/app_image_provider.dart';
import 'package:theinstallers/controller/booking_controller_provider.dart';
import 'package:theinstallers/controller/homeControllerProvider.dart';
import 'package:theinstallers/splash_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'controller/agent_controller_provider.dart';
import 'controller/authControllerProvider/auth_controller_provider.dart';
import 'controller/database/database_controller_provider.dart';
import 'controller/location_controller_provider.dart';
import 'controller/show_user_details_controller_provider.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
 	print(message.notification!.title);
	}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
   LocalNotificationService.initialize();
    
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    return MultiProvider(
       providers: [
       ChangeNotifierProvider(create: (_)=> AuthenticationControllerProvider()),
       ChangeNotifierProvider(create: (_)=> DatabaseControllerProvider()),
       ChangeNotifierProvider(create: (_)=> HomeControllerProvider()),
       ChangeNotifierProvider(create: (_)=> UserDetailsControllerProvider()),
       ChangeNotifierProvider(create: (_)=> BookingControllerProvider()),
       ChangeNotifierProvider(create: (_)=> AgentControllerProvider()),
       ChangeNotifierProvider(create: (_)=> LocationControllerProvider()),
       ChangeNotifierProvider(create: (_)=> AppImageProvider()),
       
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Installer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        
      ),
    );
  }
}

