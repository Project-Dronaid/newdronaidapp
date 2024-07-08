import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login/login.dart';
import 'signup_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/colors.dart';

class SignUpScreen extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
          children: [
            SizedBox(height: size.height * 0.05), // Adjusted the top padding
            Center(
              child: SvgPicture.asset(
                'lib/assets/icons/signup.svg',
                height: size.height * 0.5, // Increased the image height
              ),
            ),
            SizedBox(height: size.height * 0.02), // Reduced space between image and form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                children: [
                  Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: deepPurple,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Form(
                    child: Column(
                      children: [
                        _buildTextField(signupController.hospitalNameController, "Hospital Name", Icons.local_hospital),
                        _buildTextField(signupController.emailController, "Email", Icons.email),
                        Obx(() => _buildTextField(
                            signupController.passwordController,
                            "Password",
                            Icons.lock,
                            isPassword: true,
                            obscureText: signupController.obscureText.value,
                            toggleObscureText: () {
                              signupController.obscureText.value = !signupController.obscureText.value;
                            }
                        )),
                        _buildTextField(signupController.addressController, "Address", Icons.location_on),
                        _buildTextField(signupController.phoneController, "Phone Number", Icons.phone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: Obx(() => ElevatedButton(
                onPressed: signupController.isLoading.value ? null : () {
                  signupController.signup();
                },
                child: signupController.isLoading.value
                    ? CircularProgressIndicator(color: buttonTextColor)
                    : Text("SIGN UP", style: TextStyle(fontSize: 18, color: buttonTextColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepPurple,
                  minimumSize: Size(size.width * 0.8, 50),
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => LoginScreen()); // Use GetX to navigate to login screen
                },
                child: Center(
                  child: Text(
                    "Already has an account? LOGIN",
                    style: TextStyle(color: deepPurple, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool isPassword = false, bool obscureText = false, Function? toggleObscureText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: deepPurple),
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              if (toggleObscureText != null) toggleObscureText();
            },
          ) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
