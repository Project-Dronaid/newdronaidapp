import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';

String emailr = 'abc@gmail.com';

class EmailDialogBox extends StatelessWidget {
  const EmailDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.white,
      title: Column(
        children: [
          const Center(
              child: Text(
            'Send Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'Please send the request results to ',
              ),
              TextSpan(
                text: '$emailr',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.05,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  'Ok',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}