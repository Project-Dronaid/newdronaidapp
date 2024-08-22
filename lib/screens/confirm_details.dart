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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'Please Enter Weight of Package in kgs',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10),
              child: Text('Maximum Weight allowed: 2kgs', style: TextStyle(fontWeight: FontWeight.w400),),
            ),
            GestureDetector(
              onTap: () {
                double weight = double.tryParse(_weightController.text) ?? 0.0;
                if(weight!=0.0){
                  if (weight <= 2) {
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
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Enter the weight"),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 12),
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
