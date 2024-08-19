import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:dronaid_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ConfirmDetails extends StatefulWidget {
  const ConfirmDetails({super.key});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

Future<void> confirmDetails() async {
  await FirebaseFirestore.instance
      .collection('drone')
      .doc('drone1')
      .update({'orderFlag': 2, 'droneFlag': 1});
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  TextEditingController _weightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 100),
            ),
            Image.asset(
              'assets/warningSymbol.png',
              height: MediaQuery.of(context).size.height * 0.27,
              width: MediaQuery.of(context).size.width * 1,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                  'Before tracking your request please confirm that you have placed the request supplies successfully inside the drone.'),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                  'Also confirm that you are at a safe distance from the drone.'),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Note that once you confirm, the drone will takeoff in a few seconds.',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'Please Enter Weight of Package in Kg',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                double weight = double.tryParse(_weightController.text) ?? 0.0;
                if (weight <= 1.5) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderTrackingPage()));
                  confirmDetails();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("The weight limit is exceeded"),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Center(
                    child: Text(
                  'Confirm Takeoff',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(15)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
