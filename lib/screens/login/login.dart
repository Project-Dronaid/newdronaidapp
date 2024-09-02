import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../firebase/auth_methods.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../signUp/signUp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);

       
    if (res == 'Success') {
       String? fcmToken = await FirebaseMessaging.instance.getToken();

        print(fcmToken);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Center(
                child: SvgPicture.asset(
                  'assets/login.svg',
                  height: size.height * 0.5,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Form(
                      child: Column(
                        children: [
                          _buildTextField(emailController, "Email", Icons.email),
                          _buildTextField(
                            passwordController,
                            "Password",
                            Icons.lock,
                            isPassword: true,
                            obscureText: obscureText,
                            toggleObscureText: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 18, color: primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: Size(size.width * 0.8, 50),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.02),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: Center(
                    child: Text(
                      "Not registered? Sign Up",
                      style: TextStyle(color: kPrimaryColor, fontSize: 16),
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

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false,
      bool obscureText = false,
      Function? toggleObscureText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: kPrimaryColor),
          hintText: hintText,
          hintStyle: TextStyle(color: secondaryColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    if (toggleObscureText != null) toggleObscureText();
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}