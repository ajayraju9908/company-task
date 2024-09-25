import 'dart:convert';
import 'package:company_task/screens/OtpScreen.dart';
import 'package:company_task/screens/SignUpScreen.dart';
import 'package:company_task/screens/reusable_components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();

  Map<String, dynamic> loginResponse = {};

  final String baseUrl = 'http://hovee.in/app/public/api';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 8, // Shadow effect for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      hintText: 'Enter Mobile Number',
                      controller: mobileController,
                      isPassword: false,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'Login',
                      onPressed: () async {
                        loginResponse = await login();
                        if (loginResponse["status"] == "Success") {
                          String otp = loginResponse["data"]["otp"];

                          // Display the OTP in a SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("OTP sent: $otp"),
                              backgroundColor: Colors.green, // Set SnackBar color to green
                            ),
                          );

                          // Navigate to OTPScreen with the received OTP
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(otp: otp),
                            ),
                          );
                        } else {
                          print("User does not exist");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login failed. Please try again."),
                              backgroundColor: Colors.red, // Set SnackBar color to red for error
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Don\'t have an account? Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> login() async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(url, body: {'identifier': mobileController.text});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }
}
