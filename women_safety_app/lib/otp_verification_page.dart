import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:women_safety_app/landingpage.dart';
import 'package:women_safety_app/constants.dart';
import 'package:women_safety_app/DatabaseHelper.dart';

class UserData {
  final String name;
  final String fullAddress;
  final String gender;
  final String dateOfBirth;

  UserData({
    required this.name,
    required this.fullAddress,
    required this.gender,
    required this.dateOfBirth,
  });
}

class OtpVerificationPage extends StatefulWidget {
  final String referenceId;
  final String aadhaarNumber;

  const OtpVerificationPage({
    super.key, 
    required this.referenceId,
    required this.aadhaarNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  UserData? userData;

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

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.generateOtpEndpoint),
        headers: ApiConstants.headers,
        body: jsonEncode({
          "@entity": ApiConstants.generateOtpEntity,
          "aadhaar_number": widget.aadhaarNumber,
          "consent": "Y",
          "reason": ""
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['data']['message'] == 'OTP sent successfully') {
        _showSnackBar('OTP resent successfully! Check your registered mobile.', false);
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to resend OTP. Please try again.';
        _showSnackBar(errorMessage, true);
      }
    } catch (e) {
      _showSnackBar('Network error! Please check your internet connection.', true);
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (!mounted) return;
    
    if (_otpController.text.isEmpty || _otpController.text.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP', true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    debugPrint('Using Reference ID for verification: ${widget.referenceId}');

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyOtpEndpoint),
        headers: ApiConstants.headers,
        body: jsonEncode(ApiConstants.verifyOtpBody(widget.referenceId, _otpController.text)),
      );

      if (!mounted) return;

      final responseData = json.decode(response.body);
      debugPrint('API Response: $responseData');

      if (response.statusCode == 200) {
        final data = responseData['data'];
        
        if (data != null && 
            data['status']?.toString().toUpperCase() == 'VALID' && 
            data['message'] == 'Aadhaar Card Exists') {
          try {
            userData = UserData(
              name: data['name'] ?? 'Unknown',
              fullAddress: data['full_address'] ?? 'Address not available',
              gender: data['gender'] ?? 'Not specified',
              dateOfBirth: data['date_of_birth'] ?? 'Not available',
            );
            
            await _saveUserData(userData!);
            
            if (!mounted) return;
            
            _showSnackBar('Verification successful!', false);
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const EmergencyPage(),
                ),
                (route) => false,
              );
            });
          } catch (e) {
            debugPrint('Error saving user data: $e');
            if (!mounted) return;
            _showSnackBar('Error saving user data. Please try again.', true);
          }
        } else {
          String errorMessage = 'Verification failed. Please try again.';
          
          if (data != null && data['message'] != null) {
            switch(data['message']) {
              case 'Invalid OTP':
                errorMessage = 'Invalid OTP. Please try again.';
                break;
              case 'Invalid Reference Id':
                errorMessage = 'Invalid reference ID. Please try again.';
                break;
              case 'OTP Expired':
                errorMessage = 'OTP has expired. Please request a new OTP.';
                break;
              case 'Request under process':
                errorMessage = 'Request is being processed. Please wait.';
                break;
              default:
                errorMessage = data['message'] ?? errorMessage;
            }
          }
          
          if (!mounted) return;
          _showSnackBar(errorMessage, true);
        }
      } else {
        String errorMessage = responseData['message'] ?? 'Server error. Please try again later.';
        if (!mounted) return;
        _showSnackBar(errorMessage, true);
      }
    } catch (e) {
      debugPrint('Error during verification: $e');
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

  Future<void> _saveUserData(UserData userData) async {
    try {
      await DatabaseHelper.instance.saveUserData(
        name: userData.name,
        gender: userData.gender,
        dateOfBirth: userData.dateOfBirth,
        address: userData.fullAddress,
        aadhaarNumber: widget.aadhaarNumber,
      );
    } catch (e) {
      debugPrint('Error saving user data to database: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the OTP sent to your registered mobile number',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter 6-digit OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'OTP must contain only digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _verifyOtp();
                              } else {
                                _showSnackBar('Please fix the errors in the form', true);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Verify OTP'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isResending ? null : _resendOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                    ),
                    child: _isResending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Resend'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
} 