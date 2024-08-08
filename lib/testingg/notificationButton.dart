import 'dart:convert';

import 'package:dronaid_app/firebase/notification_service.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NotificationButton extends StatelessWidget {

  NotificationService notificationService=NotificationService();

  Future<void> sendNotification() async{
    final String serverURl='http://localhost:3000/send-notification';


    final response= await http.post(
      Uri.parse(serverURl),
      headers: <String,String>{
        'Content-Type':'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'targetToken': await notificationService.getDeviceToken(),
        'title': 'Helloooo from another world',
        'body': 'This is notification from another world',
      })
    );


    if(response.statusCode== 200){
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: sendNotification,
          child: Container(
            height: 100,
                margin: EdgeInsets.only(left: 18, right: 18, bottom: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10)),
                    child:const Center(
                    child: Text(
                  'Submit Request',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
        ),
      ),
    );
  }
}