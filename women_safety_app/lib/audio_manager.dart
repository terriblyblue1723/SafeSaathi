import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  Future<void> initialize() async {
    await _audioPlayer.setSource(AssetSource('audio/alert.mp3'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playAlert() async {
    try {
      if (!_isPlaying) {
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAlert() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  bool isPlaying() {
    return _isPlaying;
  }
}