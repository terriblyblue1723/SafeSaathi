import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:women_safety_app/otp_verification_page.dart';
import 'package:women_safety_app/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarController = TextEditingController();
  bool _isLoading = false;
  bool _consent = false;

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _sendOtpRequest() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Sending OTP request for Aadhaar: ${_aadhaarController.text}');
      
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.generateOtpEndpoint),
        headers: ApiConstants.headers,
        body: jsonEncode({
          "@entity": ApiConstants.generateOtpEntity,
          "aadhaar_number": _aadhaarController.text,
          "consent": "Y",
          "reason": ""
        }),
      );

      if (!mounted) return;

      final responseData = json.decode(response.body);
      debugPrint('API Response: $responseData');

      if (response.statusCode == 200) {
        final data = responseData['data'];
        debugPrint('Checking data: $data');
        if (data != null && data['message'] == 'OTP sent successfully' && data['reference_id'] != null) {
          final String referenceId = data['reference_id'].toString();
          debugPrint('Navigation triggered with referenceId: $referenceId');
          
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                referenceId: referenceId,
                aadhaarNumber: _aadhaarController.text,
              ),
            ),
          );
        } else {
          debugPrint('Failed validation. Data: $data');
          _showSnackBar('Failed to send OTP. Please try again.', true);
        }
      } else {
        _showSnackBar('Server error! Please try again.', true);
      }
    } catch (e) {
      debugPrint('Error during OTP request: $e');
      if (!mounted) return;
      _showSnackBar('Network error! Please check your internet connection.', true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      appBar: AppBar(
        title: const Text('Login with Aadhaar'),
        backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _aadhaarController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: const InputDecoration(
                  labelText: 'Aadhaar Number',
                  hintText: 'Enter your 12-digit Aadhaar number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Aadhaar number';
                  }
                  if (value.length != 12) {
                    return 'Aadhaar number must be 12 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Aadhaar number must contain only digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _consent,
                onChanged: (value) {
                  setState(() {
                    _consent = value ?? false;
                  });
                },
                title: const Text('I consent to KYC verification'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (!_consent || _isLoading)
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _sendOtpRequest();
                        } else {
                          _showSnackBar('Please fix the errors in the form', true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    super.dispose();
  }
} 