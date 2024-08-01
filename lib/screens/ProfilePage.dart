import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFEEEFF5),
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     //Back Button
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) => ),
        //     // );
        //   },
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        // ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFEEEFF5),
        surfaceTintColor: Color(0xFFEEEFF5),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Material(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            //add image here.
                            // backgroundImage: AssetImage("assets/images/download.png"),
                            radius: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "XYZ Hospital",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person,),
                    title: const Text('Hospital Data'),
                    onTap: () {
                      print('Hospital Data tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Medical History'),
                    onTap: () {
                      print('Medical History tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Request History'),
                    onTap: () {
                      print('Request History tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      print('Settings tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.question_answer),
                    title: const Text('FAQ'),
                    onTap: () {
                      print('FAQ tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Community'),
                    onTap: () {
                      print('Community tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: const Text('License'),
                    onTap: () {
                      print('License tapped');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Feel Free To Ask. We are Ready to Help'),
                    onTap: () {
                      print('Help tapped');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
