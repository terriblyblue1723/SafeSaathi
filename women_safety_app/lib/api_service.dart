import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:women_safety_app/DatabaseHelper.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Base URL for the backend API
  static const String baseUrl = 'http://192.168.0.109:8000';
  static const String apiUrl = '$baseUrl/sos/videos/upload/';
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Get announcements
  Future<List<Post>> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sos/announcements/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      debugPrint('Announcements response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Get announcements failed: $e');
      throw Exception('Get announcements failed: $e');
    }
  }

  // Get announcement by ID
  Future<Post> getAnnouncementById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/sos/announcements/$id/');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load announcement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get announcement failed: $e');
    }
  }

  // Get stored Aadhaar reference
  Future<String?> getStoredAadhaarReference() async {
    try {
      return await _databaseHelper.getAadhaarNumber();
    } catch (e) {
      debugPrint('Error fetching Aadhaar number: $e');
      return null;
    }
  }

  // Add new contact
  Future<void> addEmergencyContact(String aadhaarNumber, String contactPhone, String contactName, {String? relation}) async {
    try {
      final url = Uri.parse('$baseUrl/sos/contacts/add/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'aadhaar_number': aadhaarNumber,
          'contact_phone': contactPhone,
          'contact_name': contactName,
          'relation': relation ?? 'Others',
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to add contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Add contact failed: $e');
    }
  }

  // Update existing contact
  Future<void> updateEmergencyContact(String aadhaarNumber, String contactPhone, String contactName, {String? relation}) async {
    try {
      final url = Uri.parse('$baseUrl/sos/contacts/manage/');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'aadhaar_number': aadhaarNumber,
          'contact_phone': contactPhone,
          'contact_name': contactName,
          'relation': relation ?? 'Others',
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to update contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update contact failed: $e');
    }
  }

  // Delete contact
  Future<void> deleteEmergencyContact(String aadhaarNumber, String contactPhone) async {
    try {
      final url = Uri.parse('$baseUrl/sos/contacts/delete/');

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'aadhaar_number': aadhaarNumber,
          'contact_phone': contactPhone,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to delete contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Delete contact failed: $e');
    }
  }

  // Get all contacts for a user
  Future<List<dynamic>> getEmergencyContacts(String aadhaarNumber) async {
    try {
      final url = Uri.parse('$baseUrl/sos/contacts/$aadhaarNumber/');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get contacts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get contacts failed: $e');
    }
  }

  // Create SOS request
  Future<Map<String, dynamic>> createSOS({
    required String aadhaarNumber,
    String? location,
    String? message,
    double? latitude,
    double? longitude,
    double? accuracy,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/sos/create/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'aadhaar_number': aadhaarNumber,
          'location': location,
          'message': message,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (accuracy != null) 'accuracy': accuracy,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Store the token for future use
        await _databaseHelper.storeSOSToken(responseData['token']);
        return responseData;
      } else {
        throw Exception('Failed to create SOS request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Create SOS request failed: $e');
    }
  }

  // Update SOS location
  Future<Map<String, dynamic>> updateSOSLocation({
    required String token,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/sos/$token/locations/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          if (accuracy != null) 'accuracy': accuracy,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update location failed: $e');
    }
  }

  // Deactivate SOS request
  Future<void> deactivateSOS(String token) async {
    try {
      final url = Uri.parse('$baseUrl/sos/$token/deactivate/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to deactivate SOS: ${response.statusCode}');
      }

      // Clear stored token after successful deactivation
      await _databaseHelper.clearSOSToken();
    } catch (e) {
      throw Exception('Deactivate SOS failed: $e');
    }
  }

  // Get stored SOS token
  Future<String?> getStoredSOSToken() async {
    return await _databaseHelper.getSOSToken();
  }

  // Upload video
  Future<void> uploadVideo(String aadhaar, File videoFile) async {
    try {
      final Uint8List videoBytes = await videoFile.readAsBytes();

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['aadhaar'] = aadhaar;
      request.files.add(
        http.MultipartFile.fromBytes(
          'video',
          videoBytes,
          filename: 'video.mp4',
          contentType: MediaType.parse('video/mp4'),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Video uploaded successfully');
      } else {
        print('Failed to upload video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  // Create announcement
  Future<void> createAnnouncement({
    required String title,
    required String body,
    required String priority,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sos/announcements/create/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'priority': priority,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create announcement: ${response.body}');
    }
  }
}

class Post {
  final String title;
  final String body;
  final String priority;
  final DateTime createdAt;
  final bool isActive;

  Post({
    required this.title,
    required this.body,
    required this.priority,
    required this.createdAt,
    required this.isActive,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      body: json['body'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'],
    );
  }
}
