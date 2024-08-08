import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/map_page.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_methods.dart';
import '../../utils/utils.dart';
import '../login/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;

  void signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty ||
        hospitalNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all the fields')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      address: addressController.text,
      phone_no: phoneController.text,
      hospital_name: hospitalNameController.text,
      //deliveryAddress: deliveryAddress);
    );

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);
    }
  }
<<<<<<< HEAD
@override
=======

  @override
>>>>>>> upstream/main
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            Center(
              child: SvgPicture.asset(
                'assets/signup.svg',
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
                    "SIGN UP",
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
                        _buildTextField(hospitalNameController, "Hospital Name",
                            Icons.local_hospital),
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
                        _buildTextField(addressController, "Hospital Address",
                            Icons.location_on),
                        GestureDetector(
                          onTap: () => ConfirmDetails,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () => ConfirmDetails(),
                              child: TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_on,
                                      color: kPrimaryColor),
                                  hintText: 'Delivery Address',
                                  hintStyle: TextStyle(color: secondaryColor),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildTextField(
                            phoneController, "Phone Number", Icons.phone),
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
                  setState(() {
                    signUp();
                  });
                },
                child: isLoading
                    ? CircularProgressIndicator(color: primaryColor)
                    : Text("SIGN UP",
                        style: TextStyle(fontSize: 18, color: primaryColor)),
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
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Center(
                  child: Text(
                    "Already have an account? LOGIN",
                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
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
