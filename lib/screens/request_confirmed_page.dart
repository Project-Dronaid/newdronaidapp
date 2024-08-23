import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/screens/confirm_details.dart';
import 'package:dronaid_app/screens/fetched_emergency.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/info_page.dart';
import 'package:dronaid_app/screens/tracking.dart';
import 'package:dronaid_app/utils/colors.dart';

class RequestConfirmedPage extends StatelessWidget {
  const RequestConfirmedPage({Key? key}) : super(key: key);

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
                  size: 75,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Request Confirmed!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                    child: Text(
                      "Your request has been accepted successfully.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 0), // Add vertical space here
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                    child: Text.rich(
                      TextSpan(
                        text: "Check your Request History.",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to request history page
                          },
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text:
                        'Please place the requested supplies inside the drone and move to a safe distance.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ConfirmDetails()));
                },
                child: Text(
                  'Track My Order',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go back to Home Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
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

void trackOrder() {
  // Track order functionality
}

void goToHomePage() {
  // Go to home page functionality
}
