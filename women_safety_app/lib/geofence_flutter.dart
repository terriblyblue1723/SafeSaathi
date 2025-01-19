library geofence_flutter;

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

/// Geofence events state
enum GeofenceEvent { init, enter, exit }

/// Geofence plugin class
class Geofence {
  static StreamSubscription<Position>? _positionStream;
  static Stream<GeofenceEvent>? _geostream;
  static StreamController<GeofenceEvent> _controller = StreamController<GeofenceEvent>();
  static Position? _lastKnownPosition;
  static double? _centerLatitude;
  static double? _centerLongitude;
  static double? _fenceRadius;

  static double _parser(String value) {
    return double.parse(value);
  }

  static Stream<GeofenceEvent>? getGeofenceStream() {
    return _geostream;
  }

  static startGeofenceService({
    required String pointedLatitude,
    required String pointedLongitude,
    required String radiusMeter,
    required int eventPeriodInSeconds}) async {
    
    _centerLatitude = _parser(pointedLatitude);
    _centerLongitude = _parser(pointedLongitude);
    _fenceRadius = _parser(radiusMeter);
    
    debugPrint('Starting Geofence Service:');
    debugPrint('Center: $_centerLatitude, $_centerLongitude');
    debugPrint('Radius: $_fenceRadius meters');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    if (_positionStream == null) {
      _geostream = _controller.stream;
      _lastKnownPosition = null;

      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        ),
      ).listen((Position? position) async {
        if (position != null) {
          bool isMock = position.isMocked;
          debugPrint('Location Update:');
          debugPrint('Current Position: ${position.latitude}, ${position.longitude}');
          debugPrint('Is Mock Location: $isMock');
          
          double distanceInMeters = Geolocator.distanceBetween(
            _centerLatitude!, 
            _centerLongitude!, 
            position.latitude, 
            position.longitude
          );
          
          debugPrint('Distance from center: $distanceInMeters meters');
          debugPrint('Geofence radius: $_fenceRadius meters');

          if (_lastKnownPosition != null) {
            double speed = Geolocator.distanceBetween(
              _lastKnownPosition!.latitude,
              _lastKnownPosition!.longitude,
              position.latitude,
              position.longitude,
            ) / position.timestamp!.difference(_lastKnownPosition!.timestamp!).inSeconds;
            
            debugPrint('Speed: ${speed.toStringAsFixed(2)} m/s');
            if (speed > 55) {
              debugPrint('WARNING: Unrealistic speed detected!');
            }
          }

          // Check if location is outside geofence
          if (distanceInMeters > _fenceRadius!) {
            debugPrint('BREACH DETECTED: Outside geofence boundary!');
            _controller.add(GeofenceEvent.exit);
          } else {
            debugPrint('Inside geofence boundary');
            _controller.add(GeofenceEvent.enter);
          }

          _lastKnownPosition = position;
        }
      });
      
      debugPrint('Geofence monitoring started');
      _controller.add(GeofenceEvent.init);
    }
  }

  static stopGeofenceService() {
    debugPrint('Stopping Geofence Service');
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null;
      _lastKnownPosition = null;
      _centerLatitude = null;
      _centerLongitude = null;
      _fenceRadius = null;
    }
  }
}




