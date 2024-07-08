import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/colors.dart'; // Import the colors.dart file

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool obscureText = true.obs;

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
                'lib/assets/icons/login.svg',
                height: size.height * 0.5, // Increased the image height
              ),
            ),
            SizedBox(height: size.height * 0.02), // Reduced space between image and text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                children: [
                  Text(
                    "LOGIN",
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
                        _buildTextField(emailController, "Email", Icons.email),
                        Obx(() => _buildTextField(
                            passwordController,
                            "Password",
                            Icons.lock,
                            isPassword: true,
                            obscureText: obscureText.value,
                            toggleObscureText: () {
                              obscureText.value = !obscureText.value;
                            }
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: ElevatedButton(
                onPressed: () {
                  // Add your login logic here
                },
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 18, color: buttonTextColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepPurple,
                  minimumSize: Size(size.width * 0.8, 50),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/signup'); // Use GetX to navigate to signup screen
                },
                child: Center(
                  child: Text(
                    "Not registered? Sign Up",
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
