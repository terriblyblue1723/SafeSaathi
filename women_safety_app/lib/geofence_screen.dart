import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'geofence_flutter.dart';
import 'background_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'bottonNavBar.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({Key? key}) : super(key: key);

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> with WidgetsBindingObserver {
  int _selectedIndex = 2;
  GoogleMapController? _mapController;
  Circle? _geofenceCircle;
  bool _isGeofenceActive = false;
  Position? _currentPosition;
  bool _isLoading = true;
  String? _error;
  static const double _geofenceRadius = 500; // 500 meters radius
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMockLocation = false;
  bool _isSOSActive = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _mapController != null) {
      _mapController!.setMapStyle(null); // Reset map style to refresh rendering
    }
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize background service
      await BackgroundService.initialize();
      await _checkPermissionAndGetLocation();
    } catch (e) {
      setState(() {
        _error = 'Error initializing services: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkPermissionAndGetLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Request permissions through background service
      bool permissionsGranted = await BackgroundService.requestPermissions();
      if (!permissionsGranted) {
        setState(() {
          _isLoading = false;
          _error = 'Location permissions are required for geofencing.';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint('Current Location - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      if (position.isMocked) {
        debugPrint('WARNING: Mock Location Detected!');
      }

      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _isMockLocation = position.isMocked;
      });

      _updateMap(position);
      _setupGeofenceListener();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error getting location: $e';
      });
    }
  }

  void _updateMap(Position position) {
    if (_mapController != null && _mapReady) {
      debugPrint('Updating map to - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );

      setState(() {
        _geofenceCircle = Circle(
          circleId: const CircleId('geofence'),
          center: LatLng(position.latitude, position.longitude),
          radius: _geofenceRadius,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
      });
    }
  }

  void _setupGeofenceListener() {
    Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
      debugPrint('Geofence Event: $event');
      if (event == GeofenceEvent.exit && _isGeofenceActive && !_isSOSActive) {
        debugPrint('Geofence Breach Detected!');
        _handleGeofenceBreached();
      }
    });
  }

  Future<void> _handleGeofenceBreached() async {
    try {
      setState(() {
        _isSOSActive = true;
      });

      // Play alert sound
      await _audioPlayer.play(AssetSource('sounds/alert.mp3'));
      
      await BackgroundService.startSOSTracking(
        message: _isMockLocation 
          ? "Mock Location Detected - Geofence breach simulated"
          : "Geofence boundary breached - SOS activated",
        location: "Outside safe zone",
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isMockLocation 
              ? 'Mock Location Detected! SOS Activated (Simulation)'
              : 'Geofence breached! SOS activated.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'STOP SOS',
              onPressed: () async {
                await BackgroundService.stopSOSTracking();
                setState(() {
                  _isSOSActive = false;
                });
                _audioPlayer.stop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSOSActive = false;
      });
      debugPrint('Error activating SOS: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error activating SOS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleGeofence() async {
    if (!_isGeofenceActive && _currentPosition != null) {
      debugPrint('Starting Geofence at - Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}');
      debugPrint('Geofence Radius: $_geofenceRadius meters');
      
      await Geofence.startGeofenceService(
        pointedLatitude: _currentPosition!.latitude.toString(),
        pointedLongitude: _currentPosition!.longitude.toString(),
        radiusMeter: _geofenceRadius.toString(),
        eventPeriodInSeconds: 5,
      );
      
      setState(() {
        _isGeofenceActive = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isMockLocation 
            ? 'Geofence activated (Mock Location Detected)'
            : 'Geofence activated'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      Geofence.stopGeofenceService();
      if (_isSOSActive) {
        await BackgroundService.stopSOSTracking();
      }
      setState(() {
        _isGeofenceActive = false;
        _isSOSActive = false;
      });
      _audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence Safety'),
        backgroundColor:  const Color.fromARGB(239, 242, 249, 255),
        actions: [
          if (_isSOSActive)
            IconButton(
              icon: const Icon(Icons.stop_circle),
              color: Colors.red,
              onPressed: () async {
                await BackgroundService.stopSOSTracking();
                setState(() {
                  _isSOSActive = false;
                });
                _audioPlayer.stop();
              },
              tooltip: 'Stop SOS',
            ),
        ],
      ),
      body: RepaintBoundary(
        child: Stack(
          children: [
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _checkPermissionAndGetLocation,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_currentPosition != null)
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                    _mapReady = true;
                    _updateMap(_currentPosition!);
                  });
                },
                circles: _geofenceCircle != null ? {_geofenceCircle!} : {},
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
                compassEnabled: true,
                buildingsEnabled: false, // Disable 3D buildings for better performance
                liteModeEnabled: false, // Keep this false for geofence visualization
                tiltGesturesEnabled: false, // Disable tilt for better performance
              ),
            if (_isMockLocation)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Mock Location Detected!\nGeofence will trigger SOS on breach.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_isSOSActive)
              Positioned(
                top: _isMockLocation ? 80 : 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SOS ACTIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _currentPosition != null ? _toggleGeofence : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isGeofenceActive ? Colors.red : Colors.green,
                ),
                child: Text(
                  _isGeofenceActive ? 'Stop Geofence' : 'Start Geofence',
                  style: const TextStyle(fontSize: 18),
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _audioPlayer.dispose();
    if (_isGeofenceActive) {
      Geofence.stopGeofenceService();
    }
    if (_isSOSActive) {
      BackgroundService.stopSOSTracking();
    }
    super.dispose();
  }
} 