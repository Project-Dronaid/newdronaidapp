import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';

class RequestDeliveredPage extends StatelessWidget {
  const RequestDeliveredPage({super.key});

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
                "Request Delivered!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 10),
              RichText(
                text:const  TextSpan(
                  text: "The request has been delivered successfully. ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              const TextButton(
                onPressed: TrackOrder,
                child: Text(
                  'Request History',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200, // Increased width
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
                    'Go to Home Page',
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

void TrackOrder() {
  // Tanishq Track Order Page
}

void GoToHomePage() {
  // Home Page
}