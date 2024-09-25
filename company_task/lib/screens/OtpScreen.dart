import 'package:company_task/AuthProvider.dart';
import 'package:company_task/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_task/screens/reusable_components.dart';

class OTPScreen extends StatefulWidget {
  final String otp; // OTP received from the registration response

  const OTPScreen({Key? key, required this.otp}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
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
                    'Enter the OTP sent to your mobile number:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'OTP',
                    controller: otpController,
                    isPassword: false,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Verify OTP',
                    onPressed: () async {
                      String enteredOtp = otpController.text.trim();
                      
                      if (enteredOtp.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter the OTP"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        // Verify the OTP
                        bool isValid = await authProvider.verifyOTP(widget.otp, enteredOtp);

                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("OTP verified successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate to another screen after successful verification
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Homescreen()), // Replace HomeScreen with your target screen
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Invalid OTP. Please try again."),
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
