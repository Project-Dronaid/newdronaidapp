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
  final TextEditingController resultController = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;

  void signUp() async {
    if (emailController.text.isEmpty ||
        resultController.text.isEmpty ||
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
      emailresult: resultController.text,
      password: passwordController.text,
      address: addressController.text,
      phone_no: phoneController.text,
      hospital_name: hospitalNameController.text,
      //deliveryAddress: locationController.text, // Uncomment this if needed
    );

    setState(() {
      isLoading = false;
    });

    if (res == 'Success') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showSnackBar(res, context);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon, {
    bool isPassword = false,
    bool readOnly = false,
    VoidCallback? toggleObscureText,
    VoidCallback? onTap,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: kPrimaryColor),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: kPrimaryColor,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
        ),
      ),
    );
  }

  @override
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
                        _buildTextField(resultController,
                            "Email for official communication", Icons.email),
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
                        _buildTextField(
                          locationController,
                          "Delivery Address",
                          Icons.location_on,
                          readOnly: true,
                          onTap: () async {
                            final location = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmDetails()),
                            );
                            if (location != null) {
                              setState(() {
                                locationController.text = location;
                              });
                            }
                          },
                        ),
                        _buildTextField(
                            phoneController, "Phone Number", Icons.phone),
                        SizedBox(height: size.height * 0.02),
                        isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: signUp,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(size.width * 0.8, 50),
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ), // Ensure button is filled with the primary color
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
