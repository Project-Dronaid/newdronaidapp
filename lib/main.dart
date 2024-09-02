import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/OrderDetails.dart';

import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/screens/fetched_emergency.dart';
import 'package:dronaid_app/screens/fetched_requests.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/home_page2.dart';
import 'package:dronaid_app/screens/login/login.dart';
import 'package:dronaid_app/screens/map_page.dart';
import 'package:dronaid_app/screens/signUp/signUp.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dronaid_app/screens/tracking.dart';
import '../firebase/firestore_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase/firebase_options.dart';
import 'screens/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print(message.notification!.title.toString());
  await Firebase.initializeApp();
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    FetchedEmergency(),
    FetchedRequests(),
    HomePage2(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    FirestoreMethods().initializeFlags();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DronAid',
      debugShowCheckedModeBanner: false,
      // home: OrderTrackingPage(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData) {
              return HomePage();
            } else if(snapshot.hasError){
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          if(snapshot.connectionState ==  ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }

          return Scaffold(body: LoginScreen());
        },
      ),
    );
  }
}