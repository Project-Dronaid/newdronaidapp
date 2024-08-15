import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/screens/fetched_emergency.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/tracking.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RequestConfirmedPage extends StatelessWidget {
  const RequestConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.green,
                  BlendMode.srcIn,
                ),
                child: ImageIcon(
                  AssetImage("assets/check.png"),
                  size: 90,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Request Confirmed!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Your request has been placed successfully. ",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Request History",
                      style: TextStyle(color: kPrimaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Request page navigation
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  text: 'Your request will be delivered ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'as soon as possible.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
               TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderTrackingPage()));
                },
                child: Text(
                  'Track My Order',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.6, // Increased width
                height: 50, // Increased height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded edges
                    ),
                  ),
                  child: const Text(
                    'Go back to Home Page',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void TrackOrder() {}

void GoToHomePage() {
  // Home Page
}