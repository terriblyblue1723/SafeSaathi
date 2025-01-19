import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety_app/bottonNavBar.dart';
import 'package:women_safety_app/api_service.dart';
import 'package:women_safety_app/DatabaseHelper.dart';
import 'dart:io' show Platform;

class EmergencyContactsPage extends StatefulWidget {
  final String aadhaarNumber;

  const EmergencyContactsPage({
    Key? key,
    required this.aadhaarNumber,
  }) : super(key: key);

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _contacts = [];
  int _selectedIndex = 0;

  final List<Map<String, String>> emergencyNumbers = [
    {
      'name': 'Police',
      'number': '100',
      'description': 'National Emergency Police Number',
    },
    {
      'name': 'Women Helpline',
      'number': '1091',
      'description': 'Women Helpline (All India)',
    },
    {
      'name': 'Ambulance',
      'number': '102',
      'description': 'Ambulance Emergency',
    },
    {
      'name': 'Women Helpline Domestic Abuse',
      'number': '181',
      'description': 'Women Helpline Domestic Abuse',
    },
    {
      'name': 'National Emergency Number',
      'number': '112',
      'description': 'For any emergency assistance',
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(
          launchUri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_self',
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch phone dialer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _launchSMS(String phoneNumber) async {
    try {
      final Location location = Location();
      
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final LocationData locationData = await location.getLocation();
      final double? latitude = locationData.latitude;
      final double? longitude = locationData.longitude;

      if (latitude == null || longitude == null) {
        throw Exception('Could not get location coordinates');
      }

      // Create the message with location URL
      final String mapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
      final String message = 'I am in danger! This is my current location: $mapsUrl';

      if (Platform.isAndroid) {
        final uri = Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } else {
        // For iOS
        final uri = Uri.parse('sms:$phoneNumber&body=${Uri.encodeComponent(message)}');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      }
    } catch (e) {
      print('Error preparing SMS: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final backendContacts = await _apiService.getEmergencyContacts(widget.aadhaarNumber);

      for (var contact in backendContacts) {
        await _databaseHelper.insertOrUpdateContact({
          'name': contact['name'],
          'phone': contact['phone_number'],
          'relation': contact['relation'] ?? '',
        });
      }

      final contacts = await _databaseHelper.getContacts();
      setState(() {
        _contacts = contacts;
      });
    } catch (e) {
      print('Error loading contacts: $e');
      final contacts = await _databaseHelper.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  Widget _buildEmergencyNumberCard(Map<String, String> contact) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 249, 68, 70),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          final number = contact['number']!;
          _makePhoneCall(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emergency,
                  color: Color.fromARGB(255, 249, 68, 70),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact['description']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  contact['number']!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 249, 68, 70),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustedContactCard(Map<String, dynamic> contact) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: () {
          final number = contact['phone'];
          _makePhoneCall(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text(
                  contact['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      contact['relation'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      _makePhoneCall(contact['phone']);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.blue),
                    onPressed: () {
                      _launchSMS(contact['phone']);
                    },
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Emergency\nContacts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadContacts,
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Emergency Numbers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ...emergencyNumbers.map(_buildEmergencyNumberCard),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Trusted Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (_contacts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No trusted contacts added yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ..._contacts.map(_buildTrustedContactCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
