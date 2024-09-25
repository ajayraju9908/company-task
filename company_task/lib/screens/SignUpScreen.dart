import 'package:company_task/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_task/screens/OTPScreen.dart';
import 'package:company_task/screens/reusable_components.dart';
import 'dart:async'; // Import Timer

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Your Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(hintText: 'First Name', controller: firstNameController),
                  CustomTextField(hintText: 'Last Name', controller: lastNameController),
                  CustomTextField(hintText: 'Date of Birth (YYYY-MM-DD)', controller: dobController),
                  CustomTextField(hintText: 'Mobile Number', controller: mobileNoController),
                  CustomTextField(hintText: 'Email', controller: emailController),
                  CustomTextField(hintText: 'Pincode', controller: pincodeController),
                  Row(
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(child: Text('Accept Terms & Conditions')),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Register',
                    onPressed: () async {
                      if (!termsAccepted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please accept the terms and conditions"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        final response = await authProvider.register(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          dob: dobController.text,
                          mobileNo: mobileNoController.text,
                          email: emailController.text,
                          pincode: pincodeController.text,
                        );

                        if (response['status'] == 'Success') {
                          if (response['statuscode'] == 200) {
                            String otp = response['data']['otp'];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("OTP sent for verification: $otp"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Set a timer to navigate after 6 seconds
                            Timer(Duration(seconds: 6), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => OTPScreen(otp: otp)),
                              );
                            });
                          } else if (response['statuscode'] == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("User has been created successfully."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Unexpected response. Statuscode: ${response['statuscode']}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registration failed: ${response['message']}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
