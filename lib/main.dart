import 'package:dronaid_app/screens/OrderDelivered.dart';
import 'package:dronaid_app/screens/emergency_page.dart';
import 'package:dronaid_app/screens/home_page2.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/signUp/signUp.dart';
import 'screens/login/login.dart';
import 'utils/colors.dart';
import 'screens/request_page.dart';
import 'screens/ProfilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    EmergencyPage(),
    RequestPage(),
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DronAid App',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: Scaffold(
        body: RequestConfirmedPage(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page_outlined),
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
      ),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
      ],
    );
  }
}
