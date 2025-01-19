import 'package:flutter/material.dart';
import 'package:women_safety_app/DatabaseHelper.dart';
import 'package:women_safety_app/landingpage.dart';
import 'package:women_safety_app/locationsafety.dart';
import 'package:women_safety_app/selfdefence.dart';
import 'package:women_safety_app/relation.dart';
import 'package:women_safety_app/firstaid.dart';
import 'package:women_safety_app/geofence_screen.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onPageChanged;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
  }

  void _handleNavigation(int index) async {
    await _databaseHelper.setCurrentPage(index);
    widget.onPageChanged(index);

    if (!mounted) return;

    // Handle page navigation
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmergencyPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LocationSafetyPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GeofenceScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FirstAid()),
        ); 
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelfDefence()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _handleNavigation,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield_outlined),
          label: 'Geofence',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services_rounded),
          label: 'First Aid',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Self Defense',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_emergency_sharp),
          label: 'Contacts',
        ),
      ],
    );
  }
}
