import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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