import 'package:dronaid_app/main.dart';
import 'package:dronaid_app/screens/emergency_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => ()),
    // );
    //navigate to emergency screen...
  }

@override
void dispose(){
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 100,),
           Image.asset(
            width: 400,
            height: 200,
            'assets/logo-2.jpg'),
            Container(
              width: 220,
              height: 220,
              child: Lottie.asset('assets/animation.json'),
            )
          ],
        ),
      ),
    );
  }
}