import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/firebase/notification_service.dart';
import 'package:dronaid_app/screens/fetched_emergency.dart';
import 'package:dronaid_app/screens/fetched_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../utils/colors.dart';
import 'ProfilePage.dart';
import 'home_page2.dart';
import 'login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  NotificationService notificationService= NotificationService();

  @override
  void initState(){
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    // notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value){
      print('Device Details:');
      print(value);
    });
  }
  


  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    FetchedEmergency(),
    FetchedRequests(),
    HomePage2(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      body: _widgetOptions.elementAt(_selectedIndex),
                      bottomNavigationBar: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home,
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.request_page_outlined,
                            ),
                            label: 'Requests',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.info_outline),
                            label: 'Info',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            label: 'Profile',
                          ),
                        ],
                        unselectedItemColor: Colors.black.withOpacity(0.6),
                        showUnselectedLabels: true,
                        currentIndex: _selectedIndex,
                        selectedItemColor: kPrimaryColor,
                        onTap: _onItemTapped,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                return LoginScreen();
              }),
        ));
  }
}
