import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class VolumeButtonService {
  static const platform = MethodChannel('com.example.women_safety_app/volume_button');
  static bool _initialized = false;
  static int _pressCount = 0;
  static DateTime? _lastPressTime;
  static const _pressTimeWindow = Duration(seconds: 3);
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static Function? _sosCallback;

  // Add a static reference to maintain state
  static VolumeButtonService? _instance;
  static VolumeButtonService get instance => _instance ??= VolumeButtonService._();

  VolumeButtonService._();

  static Future<void> initialize(Function onSOSTrigger) async {
    if (_initialized) return;
    
    _sosCallback = onSOSTrigger;
    
    // Initialize audio player with specific settings
    await _audioPlayer.setSource(AssetSource('audio/alert.mp3'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    
    // Set up method channel handler
    platform.setMethodCallHandler((call) async {
      if (call.method == 'volumeButtonPressed') {
        final bool isVolumeDown = call.arguments as bool? ?? false;
        if (isVolumeDown) {
          await _handleVolumeDownPress();
        }
      }
      return null;
    });

    // Set initial audio settings
    try {
      await platform.invokeMethod('configureAudio');
    } catch (e) {
      print("Error configuring audio: $e");
    }

    _initialized = true;
  }

  static Future<void> _handleVolumeDownPress() async {
    final now = DateTime.now();
    
    if (_lastPressTime == null ||
        now.difference(_lastPressTime!) > _pressTimeWindow) {
      _pressCount = 1;
    } else {
      _pressCount++;
    }
    
    _lastPressTime = now;
    
    if (_pressCount >= 5) {
      _pressCount = 0;
      await _activateSOSAudio();
      _sosCallback?.call();
    }
  }

  static Future<void> _activateSOSAudio() async {
    try {
      // Configure audio to play through phone speaker at max volume
      await platform.invokeMethod('configureAudio');
      
      if (!_isPlaying) {
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  static Future<void> playManualSOS() async {
    try {
      if (!_isPlaying) {
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print("Error playing manual SOS: $e");
    }
  }

  static Future<void> stopAlert() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  static bool isPlaying() {
    return _isPlaying;
  }

  static void dispose() {
    _audioPlayer.dispose();
    _initialized = false;
    _sosCallback = null;
  }
}