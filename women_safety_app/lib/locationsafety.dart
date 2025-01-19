import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'DatabaseHelper.dart';
import 'bottonNavBar.dart';

class LocationSafetyPage extends StatefulWidget {
  const LocationSafetyPage({Key? key}) : super(key: key);

  @override
  State<LocationSafetyPage> createState() => _LocationSafetyPageState();
}

class _LocationSafetyPageState extends State<LocationSafetyPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  double? currentLat;
  double? currentLng;
  int _selectedIndex = 1; // Set to 1 for Location tab

  @override
  void initState() {
    super.initState();
    _loadLastLocation();
  }

  Future<void> _loadLastLocation() async {
    final locations = await _dbHelper.getLocationUpdates(limit: 1);
    if (locations.isNotEmpty) {
      setState(() {
        currentLat = locations.first['latitude'];
        currentLng = locations.first['longitude'];
      });
    }
  }

  Future<void> _openMapsWithQuery(String query) async {
    if (currentLat == null || currentLng == null) {
      // If no stored location, try to get current location
      try {
        Position position = await Geolocator.getCurrentPosition();
        currentLat = position.latitude;
        currentLng = position.longitude;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get current location')),
        );
        return;
      }
    }

    final url = Uri.parse(
      'https://www.google.com/maps/search/$query/@$currentLat,$currentLng,15z'
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }

  Widget _buildOptionCard(String title, IconData icon, String searchQuery) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _openMapsWithQuery(searchQuery),
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.black54,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Find Safe\nLocations Nearby',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap any option to find nearby safe locations',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    _buildOptionCard(
                      'Police Stations',
                      Icons.local_police_outlined,
                      'police stations',
                    ),
                    _buildOptionCard(
                      'Hospitals',
                      Icons.local_hospital_outlined,
                      'hospitals',
                    ),
                    _buildOptionCard(
                      'Women\'s Shelters',
                      Icons.home_outlined,
                      'women shelters',
                    ),
                    _buildOptionCard(
                      'Fire Brigade',
                      Icons.shield_outlined,
                      'fire brigade',
                    ),
                    _buildOptionCard(
                      'Metro Stations',
                      Icons.train_outlined,
                      'metro stations',
                    ),
                    _buildOptionCard(
                      'Bus Stations',
                      Icons.directions_bus_outlined,
                      'bus stations',
                    ),
                  ],
                ),
              ),
            ],
          ),
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