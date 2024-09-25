import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final String baseUrl = 'http://hovee.in/app/public/api';

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String dob,
    required String mobileNo,
    required String email,
    required String pincode,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "dob": dob,
        "mobile_no": mobileNo,
        "email": email,
        "pincode": pincode,
        "governmentproof": 1,
        "terms_accepted": true,
        "w_verify": true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> login(String mobileNo) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(url, body: {'identifier': mobileNo});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> verifyOTP(String otp, String enteredOtp) async {
    return otp == enteredOtp;
  }
}
