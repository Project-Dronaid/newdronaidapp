import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:dronaid_app/utils/constants.dart';

import 'OrderPage.dart';
import 'ProfilePage.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  TextEditingController _emergencyController = TextEditingController();
  int selectedPriority = 0;

  void selectPriority(int index) {
    setState(() {
      selectedPriority = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEEFF5),
        leading: const Icon(Icons.menu),
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
      Column(
        children: [
          Container(
            margin: EdgeInsets.all(18),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hospital Location:',
                  style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '1234 NW Bobcat Lane, St. Robert, MO 65584-5678',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Column(
            children: [
              Text(
                'Emergency Help Needed?',
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1D1D)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Enter Emergency details:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(18),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: TextField(
              maxLines: 4,
              controller: _emergencyController,
              decoration: InputDecoration(
                hintText: 'Example: O+ Blood needed',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.photo_library_outlined),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Select Priority Level:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => selectPriority(1),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                      child: Text(
                    '1',
                    style: TextStyle(fontSize: 20),
                  )),
                  decoration: BoxDecoration(
                      color: selectedPriority == 1
                          ? Color(0xFFC3B1E1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: kPrimaryColor, width: 2)),
                ),
              ),
              GestureDetector(
                onTap: () => selectPriority(2),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                      child: Text(
                    '2',
                    style: TextStyle(fontSize: 20),
                  )),
                  decoration: BoxDecoration(
                      color: selectedPriority == 2
                          ? Color(0xFFC3B1E1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: kPrimaryColor, width: 2),),
                ),
              ),
              GestureDetector(
                onTap: () => selectPriority(3),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                      child: Text(
                    '3',
                    style: TextStyle(fontSize: 20),
                  )),
                  decoration: BoxDecoration(
                      color: selectedPriority == 3
                          ? Color(0xFFC3B1E1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: kPrimaryColor, width: 2)),
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(left: 18, right: 18, bottom: 25),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                  child: Text(
                'Submit Request',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}
