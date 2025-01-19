import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'bottonNavBar.dart';

class VideoRecordingPage extends StatefulWidget {
  final Function(String aadhaarNumber, XFile videoFile) onVideoRecorded;
  final String aadhaarNumber;

  const VideoRecordingPage({
    Key? key,
    required this.onVideoRecorded,
    required this.aadhaarNumber,
  }) : super(key: key);

  @override
  _VideoRecordingPageState createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool cameraInitialized = false;
  bool isRecording = false;
  String? videoPath;
  int _selectedIndex = 0;

  // Define consistent colors
  final Color primaryColor = const Color.fromARGB(255, 249, 68, 70);
  final Color secondaryColor = Colors.black54;
  final Color backgroundColor = Colors.white;
  final Color textColor = const Color(0xFF333333);
  final Color lightGrayColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: true, // Ensures AAC audio recording
    );

    await _cameraController.initialize();
    setState(() {
      cameraInitialized = true;
    });
  }

  Future<void> startRecording() async {
    if (!_cameraController.value.isInitialized) return;

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    try {
      await _cameraController.setFlashMode(FlashMode.off);
      await _cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
        videoPath = filePath;
      });
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    try {
      final XFile videoFile = await _cameraController.stopVideoRecording();
      setState(() {
        isRecording = false;
      });

      if (videoPath != null) {
        print("Video saved to: $videoPath");
      }

      // Pass video file and Aadhaar number to the callback function
      widget.onVideoRecorded(widget.aadhaarNumber, videoFile);
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraInitialized) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final scale = 1 / (_cameraController.value.aspectRatio * deviceRatio);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Record Video",
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3, // Takes up 3/4 of the available space
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: lightGrayColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Transform.rotate(
                  angle: 90 * 3.1416 / 180, // Rotate the camera preview by 90 degrees
                  child: Center(
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // Takes up 1/4 of the available space
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isRecording ? stopRecording : startRecording,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecording ? secondaryColor : primaryColor,
                        border: Border.all(
                          color: backgroundColor,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording ? secondaryColor : primaryColor).withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isRecording ? Icons.stop_rounded : Icons.videocam_rounded,
                          color: backgroundColor,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isRecording ? "Tap to stop recording" : "Tap to start recording",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
