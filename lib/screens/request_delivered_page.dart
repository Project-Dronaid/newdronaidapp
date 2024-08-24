import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/info_page.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';

class RequestDeliveredPage extends StatelessWidget {
  const RequestDeliveredPage({super.key});

  servoOpen()  {
    FirebaseFirestore.instance
        .collection('drone')
        .doc('drone1')
        .update({'servoFlag': 1});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  text: const TextSpan(
                    text: "The request has been delivered successfully ",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: [],
                  ),
                ),
                Column(children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'You can collect the request supplies now ',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Press the button below to collect your supplies:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    servoOpen();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Drone chamber opened')));
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Collect supplies',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // const TextButton(
                //   onPressed: TrackOrder,
                //   child: Text(
                //     'Request History',
                //     style: TextStyle(color: kPrimaryColor),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // SizedBox(
                //   width: 200, // Increased width
                //   height: 50, // Increased height
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //           MaterialPageRoute(builder: (context) => HomePage()));
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: kPrimaryColor,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8), // Rounded edges
                //       ),
                //     ),
                //     child: const Text(
                //       'Go to Home Page',
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 17,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ],
            ),
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
