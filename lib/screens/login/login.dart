import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/colors.dart';

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
                  // Login action
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
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/signup');
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool isPassword = false, bool obscureText = false, Function? toggleObscureText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: kPrimaryColor),
          hintText: hintText,
          hintStyle: TextStyle(color: secondaryColor),
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
