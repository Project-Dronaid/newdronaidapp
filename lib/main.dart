import 'package:dronaid_app/screens/confirm_details.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/login/login.dart';
import 'package:dronaid_app/screens/signUp/signUp.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/firestore_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    FirestoreMethods().initializeFlags();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
