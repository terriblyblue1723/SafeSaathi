import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'DatabaseHelper.dart';
import 'api_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

// Constants
const String BACKGROUND_TASK_NAME = 'locationUpdateTask';
const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5    // Update when device moves 5 meters
);

// This needs to be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case BACKGROUND_TASK_NAME:
        try {
          // Check if SOS is still active
          final isSOSActive = await DatabaseHelper.instance.getSOSStatus();
          if (!isSOSActive) return true;

          // Check if location services are enabled
          bool servicesEnabled = await Geolocator.isLocationServiceEnabled();
          debugPrint('Location services enabled: $servicesEnabled');
          if (!servicesEnabled) return true;

          // Get current position (permissions should already be granted)
          final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          // Get battery info
          final battery = Battery();
          final batteryLevel = await battery.batteryLevel;
          final batteryState = await battery.batteryState;
          final isCharging = batteryState == BatteryState.charging;

          // Log for debugging
          debugPrint('Background location update: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
          
          // Store location update locally
          await DatabaseHelper.instance.insertLocation({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': DateTime.now().toIso8601String(),
            'battery_level': batteryLevel,
            'is_charging': isCharging ? 1 : 0,
          });

          // Send location update to server
          final apiService = ApiService();
          final token = await DatabaseHelper.instance.getSOSToken();
          if (token != null) {
            await apiService.updateSOSLocation(
              token: token,
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            );
          }

          // Clean up old locations
          await DatabaseHelper.instance.deleteOldLocations(const Duration(hours: 24));

          return true;
        } catch (e) {
          debugPrint('Error in background task: $e');
          return true;
        }
      default:
        return true;
    }
  });
}

class BackgroundService {
  static final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static final ApiService _apiService = ApiService();
  static bool _isInitialized = false;
  static StreamSubscription<Position>? _locationSubscription;

  // Initialize background service
  static Future<void> initialize() async {
    if (!_isInitialized) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true
      );
      _isInitialized = true;
      debugPrint('Workmanager initialized');
    }
  }

  // Request necessary permissions
  static Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return false;
    }

    debugPrint('Location permissions granted');
    return true;
  }

  // Start SOS tracking
  static Future<void> startSOSTracking({
    String? location,
    String? message,
  }) async {
    // Ensure initialization
    if (!_isInitialized) {
      await initialize();
    }

    // Request permissions first
    bool permissionsGranted = await requestPermissions();
    if (!permissionsGranted) {
      debugPrint('Failed to get location permissions');
      return;
    }

    try {
      // Get current position for initial location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get Aadhaar number
      final aadhaarNumber = await _dbHelper.getAadhaarNumber();
      if (aadhaarNumber == null) {
        throw Exception('User not logged in');
      }

      // Create SOS request
      final sosResponse = await _apiService.createSOS(
        aadhaarNumber: aadhaarNumber,
        location: location,
        message: message,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );

      // Verify SOS creation was successful
      if (!sosResponse.containsKey('token')) {
        throw Exception('Failed to get SOS token from server');
      }

      debugPrint('SOS request created with token: ${sosResponse['token']}');

      // Update local SOS status
      await _dbHelper.setSOSStatus(true);
      
      // Start location streaming
      _startLocationStream();

      // Register periodic task as backup
      await Workmanager().registerPeriodicTask(
        BACKGROUND_TASK_NAME,
        BACKGROUND_TASK_NAME,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
      debugPrint('SOS tracking started successfully with ID: ${sosResponse['sos_id']}');
    } catch (e) {
      // Clean up if SOS creation fails
      await _dbHelper.setSOSStatus(false);
      await _dbHelper.clearSOSToken();
      debugPrint('Error starting SOS tracking: $e');
      rethrow;
    }
  }

  // Start location stream
  static void _startLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings
    ).listen((Position position) async {
      debugPrint('Location stream update: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      
      try {
        // Get battery info
        final battery = Battery();
        final batteryLevel = await battery.batteryLevel;
        final batteryState = await battery.batteryState;
        final isCharging = batteryState == BatteryState.charging;

        // Store location update locally
        await _dbHelper.insertLocation({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'battery_level': batteryLevel,
          'is_charging': isCharging ? 1 : 0,
        });

        // Send location update to server
        final token = await _dbHelper.getSOSToken();
        if (token != null) {
          await _apiService.updateSOSLocation(
            token: token,
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
          );
        }

        // Clean up old locations
        await _dbHelper.deleteOldLocations(const Duration(hours: 24));
      } catch (e) {
        debugPrint('Error storing location update: $e');
      }
    }, 
    onError: (error) {
      debugPrint('Location stream error: $error');
      // Attempt to restart the stream after an error
      Future.delayed(Duration(seconds: 5), () async {
        if (await _dbHelper.getSOSStatus()) {
          debugPrint('Attempting to restart location stream after error');
          _startLocationStream();
        }
      });
    },
    cancelOnError: false);

    // Add a periodic check to ensure stream is active
    Timer.periodic(Duration(minutes: 1), (timer) async {
      final isSOSActive = await _dbHelper.getSOSStatus();
      if (!isSOSActive) {
        timer.cancel();
        return;
      }

      if (_locationSubscription == null) {
        debugPrint('Location stream found inactive, restarting...');
        _startLocationStream();
      }
    });
  }

  // Stop SOS tracking
  static Future<void> stopSOSTracking() async {
    try {
      // Get token before clearing everything
      final token = await _dbHelper.getSOSToken();
      
      // Cancel location stream
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      
      // Update status and cancel background task
      await _dbHelper.setSOSStatus(false);
      await Workmanager().cancelByUniqueName(BACKGROUND_TASK_NAME);
      
      // Deactivate SOS on server if we have a token
      if (token != null) {
        await _apiService.deactivateSOS(token);
      }
      
      debugPrint('SOS tracking stopped successfully');
    } catch (e) {
      debugPrint('Error stopping SOS tracking: $e');
      rethrow;
    }
  }

  // Check if location services are enabled
  static Future<bool> checkLocationServices() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('Location services enabled: $isEnabled');
    return isEnabled;
  }
}
